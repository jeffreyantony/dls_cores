// 
// Copyright (c) 2011, Daniel Strother < http://danstrother.com/ >
// All rights reserved.
// 
// Redistribution and use in source and binary forms, with or without
// modification, are permitted provided that the following conditions are met:
//   - Redistributions of source code must retain the above copyright notice,
//     this list of conditions and the following disclaimer.
//   - Redistributions in binary form must reproduce the above copyright
//     notice, this list of conditions and the following disclaimer in the
//     documentation and/or other materials provided with the distribution.
//   - The name of the author may not be used to endorse or promote products
//     derived from this software without specific prior written permission.
// 
// THIS SOFTWARE IS PROVIDED BY THE AUTHOR "AS IS" AND ANY EXPRESS OR IMPLIED
// WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
// MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO
// EVENT SHALL THE AUTHOR BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
// SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED
// TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR
// PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF
// LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING
// NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
// SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
//

// auto-generated by dlsc_sortnet_generate_module.pl
// using Perl Algorithm::Networksort
// algorithm:   batcher
// inputs:      3
// levels:      3
// comparators: 3

module dlsc_sortnet_3 #(
    parameter META      = 1,        // width of bypassed metadata
    parameter DATA      = 16,       // width of data for each element
    parameter ID        = 1,        // width of IDs for each element
    parameter PIPELINE  = 0,
    // derived; don't touch
    parameter ID_I      = (3*ID),
    parameter DATA_I    = (3*DATA)
) (
    input   wire                    clk,
    input   wire                    rst,

    input   wire                    in_valid,       // qualifier
    input   wire    [META-1:0]      in_meta,        // metadata to be delay-matched to sorting operation
    input   wire    [DATA_I-1:0]    in_data,        // unsorted data
    input   wire    [ID_I-1:0]      in_id,          // identifiers for unsorted data

    output  wire                    out_valid,      // delayed qualifier
    output  wire    [META-1:0]      out_meta,       // delayed in_meta
    output  wire    [DATA_I-1:0]    out_data,       // sorted data
    output  wire    [ID_I-1:0]      out_id          // identifiers for sorted data
);


// ** inputs **
wire    [ID-1:0]    lvl0_id [2:0];
wire    [DATA-1:0]  lvl0_data [2:0];
assign lvl0_id[0]   = in_id  [ (0*  ID) +:   ID ];
assign lvl0_data[0] = in_data[ (0*DATA) +: DATA ];
assign lvl0_id[1]   = in_id  [ (1*  ID) +:   ID ];
assign lvl0_data[1] = in_data[ (1*DATA) +: DATA ];
assign lvl0_id[2]   = in_id  [ (2*  ID) +:   ID ];
assign lvl0_data[2] = in_data[ (2*DATA) +: DATA ];


// ** level 1 **
// [[0,2]]

wire    [ID-1:0]    lvl1_id [2:0];
wire    [DATA-1:0]  lvl1_data [2:0];

// level 1: compex(0,2)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_1_0_2 (
    .clk        ( clk ),
    .in_id0     ( lvl0_id[0] ),
    .in_data0   ( lvl0_data[0] ),
    .in_id1     ( lvl0_id[2] ),
    .in_data1   ( lvl0_data[2] ),
    .out_id0    ( lvl1_id[0] ),
    .out_data0  ( lvl1_data[0] ),
    .out_id1    ( lvl1_id[2] ),
    .out_data1  ( lvl1_data[2] )
);

// level 1: pass-through 1
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_1_1 (
    .clk        ( clk ),
    .in_data    ( lvl0_data[1] ),
    .out_data   ( lvl1_data[1] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_1_1 (
    .clk        ( clk ),
    .in_data    ( lvl0_id[1] ),
    .out_data   ( lvl1_id[1] )
);


// ** level 2 **
// [[0,1]]

wire    [ID-1:0]    lvl2_id [2:0];
wire    [DATA-1:0]  lvl2_data [2:0];

// level 2: compex(0,1)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_2_0_1 (
    .clk        ( clk ),
    .in_id0     ( lvl1_id[0] ),
    .in_data0   ( lvl1_data[0] ),
    .in_id1     ( lvl1_id[1] ),
    .in_data1   ( lvl1_data[1] ),
    .out_id0    ( lvl2_id[0] ),
    .out_data0  ( lvl2_data[0] ),
    .out_id1    ( lvl2_id[1] ),
    .out_data1  ( lvl2_data[1] )
);

// level 2: pass-through 2
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_2_2 (
    .clk        ( clk ),
    .in_data    ( lvl1_data[2] ),
    .out_data   ( lvl2_data[2] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_2_2 (
    .clk        ( clk ),
    .in_data    ( lvl1_id[2] ),
    .out_data   ( lvl2_id[2] )
);


// ** level 3 **
// [[1,2]]

wire    [ID-1:0]    lvl3_id [2:0];
wire    [DATA-1:0]  lvl3_data [2:0];

// level 3: compex(1,2)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( 1 )
) dlsc_compex_inst_3_1_2 (
    .clk        ( clk ),
    .in_id0     ( lvl2_id[1] ),
    .in_data0   ( lvl2_data[1] ),
    .in_id1     ( lvl2_id[2] ),
    .in_data1   ( lvl2_data[2] ),
    .out_id0    ( lvl3_id[1] ),
    .out_data0  ( lvl3_data[1] ),
    .out_id1    ( lvl3_id[2] ),
    .out_data1  ( lvl3_data[2] )
);

// level 3: pass-through 0
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (1 > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_3_0 (
    .clk        ( clk ),
    .in_data    ( lvl2_data[0] ),
    .out_data   ( lvl3_data[0] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (1 > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_3_0 (
    .clk        ( clk ),
    .in_data    ( lvl2_id[0] ),
    .out_data   ( lvl3_id[0] )
);


// ** outputs **
assign out_id  [ (0*  ID) +:   ID ] = lvl3_id[0];
assign out_data[ (0*DATA) +: DATA ] = lvl3_data[0];
assign out_id  [ (1*  ID) +:   ID ] = lvl3_id[1];
assign out_data[ (1*DATA) +: DATA ] = lvl3_data[1];
assign out_id  [ (2*  ID) +:   ID ] = lvl3_id[2];
assign out_data[ (2*DATA) +: DATA ] = lvl3_data[2];


// ** delay valid/meta **
dlsc_pipedelay_valid #(
    .DATA       ( META ),
    .DELAY      ( 2 * (PIPELINE?2:1) + 2 ) // 1 or 2 cycles per intermediate stage; last stage always takes 2
) dlsc_pipedelay_valid_inst (
    .clk        ( clk ),
    .rst        ( rst ),
    .in_valid   ( in_valid ),
    .in_data    ( in_meta ),
    .out_valid  ( out_valid ),
    .out_data   ( out_meta )
);

endmodule

