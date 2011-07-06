
module dlsc_pcie_s6_outbound_tlp #(
    parameter ADDR      = 32,
    parameter TAG       = 5
) (
    // system
    input   wire                clk,
    input   wire                rst,

    // interface to address translator
    output  wire                trans_req,
    output  wire    [ADDR-1:2]  trans_req_addr,
    input   wire                trans_ack,
    input   wire    [63:2]      trans_ack_addr,
    input   wire                trans_ack_64,       // translated address uses upper 32 bits (requires 4DW header)

    // header from _read
    output  wire                rd_tlp_h_ready,
    input   wire                rd_tlp_h_valid,
    input   wire    [ADDR-1:2]  rd_tlp_h_addr,
    input   wire    [9:0]       rd_tlp_h_len,
    input   wire    [TAG-1:0]   rd_tlp_h_tag,
    input   wire    [3:0]       rd_tlp_h_be_first,
    input   wire    [3:0]       rd_tlp_h_be_last,

    // header from _write
    output  wire                wr_tlp_h_ready,
    input   wire                wr_tlp_h_valid,
    input   wire    [ADDR-1:2]  wr_tlp_h_addr,
    input   wire    [9:0]       wr_tlp_h_len,
    input   wire    [3:0]       wr_tlp_h_be_first,
    input   wire    [3:0]       wr_tlp_h_be_last,

    // data from _write
    output  reg                 wr_tlp_d_ready,
    input   wire                wr_tlp_d_valid,
    input   wire    [31:0]      wr_tlp_d_data,
    input   wire                wr_tlp_d_last,

    // output TLP
    input   wire                tlp_ready,
    output  wire                tlp_valid,
    output  wire    [31:0]      tlp_data,
    output  wire                tlp_last,

    // PCIe ID
    input   wire    [7:0]       bus_number,
    input   wire    [4:0]       dev_number,
    input   wire    [2:0]       func_number
);

wire [TAG-1:0]  wr_tlp_h_tag    = {TAG{1'b0}};


// ** Decouple output **

wire            tlp_ready_r;
reg             tlp_valid_r;
reg  [31:0]     tlp_data_r;
reg             tlp_last_r;

dlsc_rvh_decoupler #(
    .WIDTH      ( 33 )
) dlsc_rvh_decoupler_tlp (
    .clk        ( clk ),
    .rst        ( rst ),
    .in_en      ( 1'b1 ),
    .in_ready   ( tlp_ready_r ),
    .in_valid   ( tlp_valid_r ),
    .in_data    ( { tlp_last_r, tlp_data_r } ),
    .out_en     ( 1'b1 ),
    .out_ready  ( tlp_ready ),
    .out_valid  ( tlp_valid ),
    .out_data   ( { tlp_last  , tlp_data   } )
);


// ** Arbitrate **

wire            h_ready;
reg             h_valid         = 1'b0;

reg             h_read          = 1'b0;
reg  [ADDR-1:2] h_addr          = 0;
reg  [9:0]      h_len           = 0;
reg  [TAG-1:0]  h_tag           = 0;
reg  [3:0]      h_be_first      = 0;
reg  [3:0]      h_be_last       = 0;

assign          rd_tlp_h_ready  = !h_valid && rd_tlp_h_valid && (!h_read || !wr_tlp_h_valid);
assign          wr_tlp_h_ready  = !h_valid && wr_tlp_h_valid && ( h_read || !rd_tlp_h_valid);

always @(posedge clk) begin
    if(rst) begin
        h_valid     <= 1'b0;
        h_read      <= 1'b0;
    end else begin
        if(h_ready) begin
            h_valid     <= 1'b0;
        end
        if(rd_tlp_h_ready && rd_tlp_h_valid) begin
            h_valid     <= 1'b1;
            h_read      <= 1'b1;
        end
        if(wr_tlp_h_ready && wr_tlp_h_valid) begin
            h_valid     <= 1'b1;
            h_read      <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if(rd_tlp_h_ready && rd_tlp_h_valid) begin
        h_addr      <= rd_tlp_h_addr;
        h_len       <= rd_tlp_h_len;
        h_tag       <= rd_tlp_h_tag;
        h_be_first  <= rd_tlp_h_be_first;
        h_be_last   <= rd_tlp_h_be_last;
    end
    if(wr_tlp_h_ready && wr_tlp_h_valid) begin
        h_addr      <= wr_tlp_h_addr;
        h_len       <= wr_tlp_h_len;
        h_tag       <= wr_tlp_h_tag;
        h_be_first  <= wr_tlp_h_be_first;
        h_be_last   <= wr_tlp_h_be_last;
    end
end

assign          trans_req       = h_valid;
assign          trans_req_addr  = h_addr;


// ** Generate TLP **

localparam  ST_H0   = 0,
            ST_H1   = 1,
            ST_H2   = 2,
            ST_H3   = 3,
            ST_DATA = 4;

reg  [3:0]      st              = ST_H0;
reg  [3:0]      next_st;

always @(posedge clk) begin
    if(rst) begin
        st          <= ST_H0;
    end else if(tlp_ready_r && tlp_valid_r) begin
        st          <= next_st;
    end
end


always @* begin
    next_st             = st;

    h_ready             = 1'b0;

    wr_tlp_d_ready      = 1'b0;

    tlp_valid_r         = 1'b0;
    tlp_data_r          = 0;
    tlp_last_r          = 1'b0;

    if(st == ST_H0) begin
        // Format
        tlp_data_r[30]      = !h_read;      // data vs. non
        tlp_data_r[29]      = trans_ack_64; // 3DW vs 4DW
        // Type
        tlp_data_r[28:24]   = 5'b00000;     // memory
        // Length
        tlp_data_r[9:0]     = h_len;

        tlp_valid_r         = h_valid && trans_ack;

        next_st             = ST_H1;
    end

    if(st == ST_H1) begin
        // Requester ID
        tlp_data_r[31:16]   = { bus_number, dev_number, func_number };
        // Tag
        tlp_data_r[8+:TAG]  = h_tag;
        // Byte enables
        tlp_data_r[7:4]     = h_be_last;
        tlp_data_r[3:0]     = h_be_first;

        tlp_valid_r         = 1'b1;

        next_st             = ST_H2;
    end

    if(st == ST_H2) begin
        // Address
        tlp_data_r[31:0]    = trans_ack_64 ? trans_ack_addr[63:32] :
                                            { trans_ack_addr[31:2], 2'b00 };
        tlp_valid_r         = 1'b1;
        tlp_last_r          = !trans_ack_64 && h_read;

        h_ready             = !trans_ack_64;

        next_st             = trans_ack_64 ? ST_H3 : (h_read ? ST_H0 : ST_DATA);
    end

    if(st == ST_H3) begin
        // Address
        tlp_data_r[31:0]    = { trans_ack_addr[31:2], 2'b00 };

        tlp_valid_r         = 1'b1;
        tlp_last_r          = h_read;

        h_ready             = 1'b1;

        next_st             = h_read ? ST_H0 : ST_DATA;
    end

    if(st == ST_DATA) begin
        wr_tlp_d_ready      = tlp_ready_r;
        tlp_valid_r         = wr_tlp_d_valid;
        tlp_last_r          = wr_tlp_d_last;

        next_st             = wr_tlp_d_last ? ST_H0 : ST_DATA;
    end
end

endmodule

