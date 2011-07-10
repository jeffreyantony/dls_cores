
module dlsc_pcie_s6_outbound_read_buffer #(
    parameter LEN       = 4,
    parameter TAG       = 5,
    parameter BUFA      = 9,
    parameter MOT       = 16
) (
    // system
    input   wire                clk,
    input   wire                rst,

    // AXI read command tracking
    output  wire                axi_ar_ready,
    input   wire                axi_ar_valid,
    input   wire    [LEN-1:0]   axi_ar_len,

    // AXI read response
    input   wire                axi_r_ready,
    output  reg                 axi_r_valid,
    output  reg                 axi_r_last,
    output  reg     [31:0]      axi_r_data,
    output  reg     [1:0]       axi_r_resp,

    // writes from completion handler
    output  wire                cpl_ready,
    input   wire                cpl_valid,
    input   wire                cpl_last,
    input   wire    [31:0]      cpl_data,
    input   wire    [1:0]       cpl_resp,
    input   wire    [TAG-1:0]   cpl_tag,
    
    // writes from allocator
    input   wire                alloc_init,
    input   wire                alloc_valid,
    input   wire    [TAG:0]     alloc_tag,
    input   wire    [BUFA-1:0]  alloc_bufa,

    // feedback to allocator
    output  reg                 dealloc_tag,        // freed a tag
    output  reg                 dealloc_data        // freed a dword
);

`include "dlsc_synthesis.vh"

localparam      TAGS            = (2**TAG);


// Read data buffer

wire            buf_wr_en;
wire [BUFA-1:0] buf_wr_addr;
wire [33:0]     buf_wr_data;
reg             buf_rd_en;
reg  [BUFA-1:0] buf_rd_addr;
wire [33:0]     buf_rd_data;

dlsc_ram_dp #(
    .DATA           ( 34 ),
    .ADDR           ( BUFA ),
    .PIPELINE_WR    ( 0 ),
    .PIPELINE_RD    ( 1 )
) dlsc_ram_dp_r (
    .write_clk      ( clk ),
    .write_en       ( buf_wr_en ),
    .write_addr     ( buf_wr_addr ),
    .write_data     ( buf_wr_data ),
    .read_clk       ( clk ),
    .read_en        ( buf_rd_en ),
    .read_addr      ( buf_rd_addr ),
    .read_data      ( buf_rd_data )
);

reg             buf_rd_valid    = 0;

always @(posedge clk) begin
    if(rst) begin
        buf_rd_valid    <= 1'b0;
    end else begin
        buf_rd_valid    <= buf_rd_en;
    end
end


// Track read commands

wire            ar_full;
wire            ar_pop;

assign          axi_ar_ready    = !ar_full;

wire [LEN-1:0]  ar_len;

dlsc_fifo_shiftreg #(
    .DATA           ( LEN ),
    .DEPTH          ( MOT )
) dlsc_fifo_shiftreg_ar (
    .clk            ( clk ),
    .rst            ( rst ),
    .push_en        ( axi_ar_ready && axi_ar_valid ),
    .push_data      ( axi_ar_len ),
    .pop_en         ( ar_pop ),
    .pop_data       ( ar_len ),
    .empty          (  ),
    .full           ( ar_full ),
    .almost_empty   (  ),
    .almost_full    (  )
);

reg  [LEN-1:0]  r_cnt           = 0;
wire            r_last          = (ar_len == r_cnt);
wire            r_inc;

always @(posedge clk) begin
    if(ar_pop) begin
        r_cnt           <= 0;
    end else if(r_inc) begin
        r_cnt           <= r_cnt + 1;
    end
end


// Combine to form output

wire            r_empty;
wire            r_full;

wire            r_pop           = !r_empty && (!axi_r_valid || axi_r_ready);

assign          r_inc           = r_pop;
assign          ar_pop          = r_pop && r_last;

wire [1:0]      r_resp;
wire [31:0]     r_data;

dlsc_fifo_shiftreg #(
    .DATA           ( 34 ),
    .DEPTH          ( 16 ),
    .ALMOST_FULL    ( 4 )
) dlsc_fifo_shiftreg_r (
    .clk            ( clk ),
    .rst            ( rst ),
    .push_en        ( buf_rd_valid ),
    .push_data      ( buf_rd_data ),
    .pop_en         ( r_pop ),
    .pop_data       ( { r_resp, r_data } ),
    .empty          ( r_empty ),
    .full           (  ),
    .almost_empty   (  ),
    .almost_full    ( r_full )
);

always @(posedge clk) begin
    if(rst) begin
        axi_r_valid     <= 1'b0;
    end else begin
        if(axi_r_ready) begin
            axi_r_valid     <= 1'b0;
        end
        if(r_pop) begin
            axi_r_valid     <= 1'b1;
        end
    end
end

always @(posedge clk) begin
    if(r_pop) begin
        axi_r_last      <= r_last;
        axi_r_resp      <= r_resp;
        axi_r_data      <= r_data;
    end
end


// Dual-ported tag address memory

`DLSC_LUTRAM reg [BUFA:0] mem[TAGS-1:0];

wire [TAG-1:0]  mem_a_addr;
wire            mem_a_wr_en;
wire [BUFA:0]   mem_a_wr_data;
wire [BUFA:0]   mem_a_rd_data   = mem[mem_a_addr];
wire [TAG-1:0]  mem_b_addr;
wire [BUFA:0]   mem_b_rd_data   = mem[mem_b_addr];

always @(posedge clk) begin
    if(mem_a_wr_en) begin
        mem[mem_a_addr] <= mem_a_wr_data;
    end
end


// Port A: allocations and completions

wire [BUFA-1:0] cpl_addr        = mem_a_rd_data[BUFA-1:0];
wire [BUFA-1:0] cpl_addr_inc    = cpl_addr + { {(BUFA-1){1'b0}}, !cpl_last };   // increment on all but last

assign          cpl_ready       = alloc_valid ? 1'b0                : 1'b1;
assign          mem_a_addr      = alloc_valid ? alloc_tag[TAG-1:0]  : cpl_tag;
assign          mem_a_wr_en     = alloc_valid ? 1'b1                : cpl_valid;
assign          mem_a_wr_data   = alloc_valid ? {1'b0, alloc_bufa}  : {cpl_last, cpl_addr_inc};

assign          buf_wr_en       = cpl_ready && cpl_valid;
assign          buf_wr_addr     = cpl_addr;
assign          buf_wr_data     = { cpl_resp, cpl_data };


// Port B: AXI read

reg  [TAG:0]    read_tag        = 0;
reg  [BUFA-1:0] read_addr       = 0;

assign          mem_b_addr      = read_tag[TAG-1:0];

wire [BUFA-1:0] read_cpl_addr   = mem_b_rd_data[BUFA-1:0];
wire            read_cpl_done   = mem_b_rd_data[BUFA];

wire            read_tag_equ    = (read_tag  == alloc_tag);
wire            read_cpl_equ    = (read_addr == read_cpl_addr);

wire            buf_rd_en_pre   = !alloc_init && !r_full && !read_tag_equ && (!read_cpl_equ || read_cpl_done);

always @(posedge clk) begin
    buf_rd_en       <= buf_rd_en_pre;
    buf_rd_addr     <= read_addr;
end

always @(posedge clk) begin
    if(rst) begin
        dealloc_tag     <= 1'b0;
        dealloc_data    <= 1'b0;
        read_tag        <= 0;
        read_addr       <= 0;
    end else begin
        dealloc_tag     <= 1'b0;
        dealloc_data    <= 1'b0;
        if(buf_rd_en_pre) begin
            dealloc_data    <= 1'b1;
            read_addr       <= read_addr + 1;
            if(read_cpl_equ && read_cpl_done) begin
                dealloc_tag     <= 1'b1;
                read_tag        <= read_tag + 1;
            end
        end
    end
end


endmodule
