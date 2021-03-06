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
// inputs:      8
// levels:      6
// comparators: 19

module dlsc_sortnet_8 #(
    parameter META      = 1,        // width of bypassed metadata
    parameter DATA      = 16,       // width of data for each element
    parameter ID        = 1,        // width of IDs for each element
    parameter PIPELINE  = 0,
    // derived; don't touch
    parameter ID_I      = (8*ID),
    parameter DATA_I    = (8*DATA)
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
wire    [ID-1:0]    lvl0_id [7:0];
wire    [DATA-1:0]  lvl0_data [7:0];
assign lvl0_id[0]   = in_id  [ (0*  ID) +:   ID ];
assign lvl0_data[0] = in_data[ (0*DATA) +: DATA ];
assign lvl0_id[1]   = in_id  [ (1*  ID) +:   ID ];
assign lvl0_data[1] = in_data[ (1*DATA) +: DATA ];
assign lvl0_id[2]   = in_id  [ (2*  ID) +:   ID ];
assign lvl0_data[2] = in_data[ (2*DATA) +: DATA ];
assign lvl0_id[3]   = in_id  [ (3*  ID) +:   ID ];
assign lvl0_data[3] = in_data[ (3*DATA) +: DATA ];
assign lvl0_id[4]   = in_id  [ (4*  ID) +:   ID ];
assign lvl0_data[4] = in_data[ (4*DATA) +: DATA ];
assign lvl0_id[5]   = in_id  [ (5*  ID) +:   ID ];
assign lvl0_data[5] = in_data[ (5*DATA) +: DATA ];
assign lvl0_id[6]   = in_id  [ (6*  ID) +:   ID ];
assign lvl0_data[6] = in_data[ (6*DATA) +: DATA ];
assign lvl0_id[7]   = in_id  [ (7*  ID) +:   ID ];
assign lvl0_data[7] = in_data[ (7*DATA) +: DATA ];


// ** level 1 **
// [[0,4],[1,5],[2,6],[3,7]]

wire    [ID-1:0]    lvl1_id [7:0];
wire    [DATA-1:0]  lvl1_data [7:0];

// level 1: compex(0,4)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_1_0_4 (
    .clk        ( clk ),
    .in_id0     ( lvl0_id[0] ),
    .in_data0   ( lvl0_data[0] ),
    .in_id1     ( lvl0_id[4] ),
    .in_data1   ( lvl0_data[4] ),
    .out_id0    ( lvl1_id[0] ),
    .out_data0  ( lvl1_data[0] ),
    .out_id1    ( lvl1_id[4] ),
    .out_data1  ( lvl1_data[4] )
);

// level 1: compex(1,5)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_1_1_5 (
    .clk        ( clk ),
    .in_id0     ( lvl0_id[1] ),
    .in_data0   ( lvl0_data[1] ),
    .in_id1     ( lvl0_id[5] ),
    .in_data1   ( lvl0_data[5] ),
    .out_id0    ( lvl1_id[1] ),
    .out_data0  ( lvl1_data[1] ),
    .out_id1    ( lvl1_id[5] ),
    .out_data1  ( lvl1_data[5] )
);

// level 1: compex(2,6)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_1_2_6 (
    .clk        ( clk ),
    .in_id0     ( lvl0_id[2] ),
    .in_data0   ( lvl0_data[2] ),
    .in_id1     ( lvl0_id[6] ),
    .in_data1   ( lvl0_data[6] ),
    .out_id0    ( lvl1_id[2] ),
    .out_data0  ( lvl1_data[2] ),
    .out_id1    ( lvl1_id[6] ),
    .out_data1  ( lvl1_data[6] )
);

// level 1: compex(3,7)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_1_3_7 (
    .clk        ( clk ),
    .in_id0     ( lvl0_id[3] ),
    .in_data0   ( lvl0_data[3] ),
    .in_id1     ( lvl0_id[7] ),
    .in_data1   ( lvl0_data[7] ),
    .out_id0    ( lvl1_id[3] ),
    .out_data0  ( lvl1_data[3] ),
    .out_id1    ( lvl1_id[7] ),
    .out_data1  ( lvl1_data[7] )
);


// ** level 2 **
// [[0,2],[1,3],[4,6],[5,7]]

wire    [ID-1:0]    lvl2_id [7:0];
wire    [DATA-1:0]  lvl2_data [7:0];

// level 2: compex(0,2)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_2_0_2 (
    .clk        ( clk ),
    .in_id0     ( lvl1_id[0] ),
    .in_data0   ( lvl1_data[0] ),
    .in_id1     ( lvl1_id[2] ),
    .in_data1   ( lvl1_data[2] ),
    .out_id0    ( lvl2_id[0] ),
    .out_data0  ( lvl2_data[0] ),
    .out_id1    ( lvl2_id[2] ),
    .out_data1  ( lvl2_data[2] )
);

// level 2: compex(1,3)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_2_1_3 (
    .clk        ( clk ),
    .in_id0     ( lvl1_id[1] ),
    .in_data0   ( lvl1_data[1] ),
    .in_id1     ( lvl1_id[3] ),
    .in_data1   ( lvl1_data[3] ),
    .out_id0    ( lvl2_id[1] ),
    .out_data0  ( lvl2_data[1] ),
    .out_id1    ( lvl2_id[3] ),
    .out_data1  ( lvl2_data[3] )
);

// level 2: compex(4,6)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_2_4_6 (
    .clk        ( clk ),
    .in_id0     ( lvl1_id[4] ),
    .in_data0   ( lvl1_data[4] ),
    .in_id1     ( lvl1_id[6] ),
    .in_data1   ( lvl1_data[6] ),
    .out_id0    ( lvl2_id[4] ),
    .out_data0  ( lvl2_data[4] ),
    .out_id1    ( lvl2_id[6] ),
    .out_data1  ( lvl2_data[6] )
);

// level 2: compex(5,7)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_2_5_7 (
    .clk        ( clk ),
    .in_id0     ( lvl1_id[5] ),
    .in_data0   ( lvl1_data[5] ),
    .in_id1     ( lvl1_id[7] ),
    .in_data1   ( lvl1_data[7] ),
    .out_id0    ( lvl2_id[5] ),
    .out_data0  ( lvl2_data[5] ),
    .out_id1    ( lvl2_id[7] ),
    .out_data1  ( lvl2_data[7] )
);


// ** level 3 **
// [[2,4],[3,5],[0,1],[6,7]]

wire    [ID-1:0]    lvl3_id [7:0];
wire    [DATA-1:0]  lvl3_data [7:0];

// level 3: compex(2,4)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_3_2_4 (
    .clk        ( clk ),
    .in_id0     ( lvl2_id[2] ),
    .in_data0   ( lvl2_data[2] ),
    .in_id1     ( lvl2_id[4] ),
    .in_data1   ( lvl2_data[4] ),
    .out_id0    ( lvl3_id[2] ),
    .out_data0  ( lvl3_data[2] ),
    .out_id1    ( lvl3_id[4] ),
    .out_data1  ( lvl3_data[4] )
);

// level 3: compex(3,5)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_3_3_5 (
    .clk        ( clk ),
    .in_id0     ( lvl2_id[3] ),
    .in_data0   ( lvl2_data[3] ),
    .in_id1     ( lvl2_id[5] ),
    .in_data1   ( lvl2_data[5] ),
    .out_id0    ( lvl3_id[3] ),
    .out_data0  ( lvl3_data[3] ),
    .out_id1    ( lvl3_id[5] ),
    .out_data1  ( lvl3_data[5] )
);

// level 3: compex(0,1)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_3_0_1 (
    .clk        ( clk ),
    .in_id0     ( lvl2_id[0] ),
    .in_data0   ( lvl2_data[0] ),
    .in_id1     ( lvl2_id[1] ),
    .in_data1   ( lvl2_data[1] ),
    .out_id0    ( lvl3_id[0] ),
    .out_data0  ( lvl3_data[0] ),
    .out_id1    ( lvl3_id[1] ),
    .out_data1  ( lvl3_data[1] )
);

// level 3: compex(6,7)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_3_6_7 (
    .clk        ( clk ),
    .in_id0     ( lvl2_id[6] ),
    .in_data0   ( lvl2_data[6] ),
    .in_id1     ( lvl2_id[7] ),
    .in_data1   ( lvl2_data[7] ),
    .out_id0    ( lvl3_id[6] ),
    .out_data0  ( lvl3_data[6] ),
    .out_id1    ( lvl3_id[7] ),
    .out_data1  ( lvl3_data[7] )
);


// ** level 4 **
// [[2,3],[4,5]]

wire    [ID-1:0]    lvl4_id [7:0];
wire    [DATA-1:0]  lvl4_data [7:0];

// level 4: compex(2,3)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_4_2_3 (
    .clk        ( clk ),
    .in_id0     ( lvl3_id[2] ),
    .in_data0   ( lvl3_data[2] ),
    .in_id1     ( lvl3_id[3] ),
    .in_data1   ( lvl3_data[3] ),
    .out_id0    ( lvl4_id[2] ),
    .out_data0  ( lvl4_data[2] ),
    .out_id1    ( lvl4_id[3] ),
    .out_data1  ( lvl4_data[3] )
);

// level 4: compex(4,5)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_4_4_5 (
    .clk        ( clk ),
    .in_id0     ( lvl3_id[4] ),
    .in_data0   ( lvl3_data[4] ),
    .in_id1     ( lvl3_id[5] ),
    .in_data1   ( lvl3_data[5] ),
    .out_id0    ( lvl4_id[4] ),
    .out_data0  ( lvl4_data[4] ),
    .out_id1    ( lvl4_id[5] ),
    .out_data1  ( lvl4_data[5] )
);

// level 4: pass-through 0
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_4_0 (
    .clk        ( clk ),
    .in_data    ( lvl3_data[0] ),
    .out_data   ( lvl4_data[0] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_4_0 (
    .clk        ( clk ),
    .in_data    ( lvl3_id[0] ),
    .out_data   ( lvl4_id[0] )
);

// level 4: pass-through 1
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_4_1 (
    .clk        ( clk ),
    .in_data    ( lvl3_data[1] ),
    .out_data   ( lvl4_data[1] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_4_1 (
    .clk        ( clk ),
    .in_data    ( lvl3_id[1] ),
    .out_data   ( lvl4_id[1] )
);

// level 4: pass-through 6
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_4_6 (
    .clk        ( clk ),
    .in_data    ( lvl3_data[6] ),
    .out_data   ( lvl4_data[6] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_4_6 (
    .clk        ( clk ),
    .in_data    ( lvl3_id[6] ),
    .out_data   ( lvl4_id[6] )
);

// level 4: pass-through 7
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_4_7 (
    .clk        ( clk ),
    .in_data    ( lvl3_data[7] ),
    .out_data   ( lvl4_data[7] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_4_7 (
    .clk        ( clk ),
    .in_data    ( lvl3_id[7] ),
    .out_data   ( lvl4_id[7] )
);


// ** level 5 **
// [[1,4],[3,6]]

wire    [ID-1:0]    lvl5_id [7:0];
wire    [DATA-1:0]  lvl5_data [7:0];

// level 5: compex(1,4)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_5_1_4 (
    .clk        ( clk ),
    .in_id0     ( lvl4_id[1] ),
    .in_data0   ( lvl4_data[1] ),
    .in_id1     ( lvl4_id[4] ),
    .in_data1   ( lvl4_data[4] ),
    .out_id0    ( lvl5_id[1] ),
    .out_data0  ( lvl5_data[1] ),
    .out_id1    ( lvl5_id[4] ),
    .out_data1  ( lvl5_data[4] )
);

// level 5: compex(3,6)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( PIPELINE )
) dlsc_compex_inst_5_3_6 (
    .clk        ( clk ),
    .in_id0     ( lvl4_id[3] ),
    .in_data0   ( lvl4_data[3] ),
    .in_id1     ( lvl4_id[6] ),
    .in_data1   ( lvl4_data[6] ),
    .out_id0    ( lvl5_id[3] ),
    .out_data0  ( lvl5_data[3] ),
    .out_id1    ( lvl5_id[6] ),
    .out_data1  ( lvl5_data[6] )
);

// level 5: pass-through 0
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_5_0 (
    .clk        ( clk ),
    .in_data    ( lvl4_data[0] ),
    .out_data   ( lvl5_data[0] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_5_0 (
    .clk        ( clk ),
    .in_data    ( lvl4_id[0] ),
    .out_data   ( lvl5_id[0] )
);

// level 5: pass-through 2
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_5_2 (
    .clk        ( clk ),
    .in_data    ( lvl4_data[2] ),
    .out_data   ( lvl5_data[2] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_5_2 (
    .clk        ( clk ),
    .in_data    ( lvl4_id[2] ),
    .out_data   ( lvl5_id[2] )
);

// level 5: pass-through 5
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_5_5 (
    .clk        ( clk ),
    .in_data    ( lvl4_data[5] ),
    .out_data   ( lvl5_data[5] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_5_5 (
    .clk        ( clk ),
    .in_data    ( lvl4_id[5] ),
    .out_data   ( lvl5_id[5] )
);

// level 5: pass-through 7
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_5_7 (
    .clk        ( clk ),
    .in_data    ( lvl4_data[7] ),
    .out_data   ( lvl5_data[7] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (PIPELINE > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_5_7 (
    .clk        ( clk ),
    .in_data    ( lvl4_id[7] ),
    .out_data   ( lvl5_id[7] )
);


// ** level 6 **
// [[1,2],[3,4],[5,6]]

wire    [ID-1:0]    lvl6_id [7:0];
wire    [DATA-1:0]  lvl6_data [7:0];

// level 6: compex(1,2)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( 1 )
) dlsc_compex_inst_6_1_2 (
    .clk        ( clk ),
    .in_id0     ( lvl5_id[1] ),
    .in_data0   ( lvl5_data[1] ),
    .in_id1     ( lvl5_id[2] ),
    .in_data1   ( lvl5_data[2] ),
    .out_id0    ( lvl6_id[1] ),
    .out_data0  ( lvl6_data[1] ),
    .out_id1    ( lvl6_id[2] ),
    .out_data1  ( lvl6_data[2] )
);

// level 6: compex(3,4)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( 1 )
) dlsc_compex_inst_6_3_4 (
    .clk        ( clk ),
    .in_id0     ( lvl5_id[3] ),
    .in_data0   ( lvl5_data[3] ),
    .in_id1     ( lvl5_id[4] ),
    .in_data1   ( lvl5_data[4] ),
    .out_id0    ( lvl6_id[3] ),
    .out_data0  ( lvl6_data[3] ),
    .out_id1    ( lvl6_id[4] ),
    .out_data1  ( lvl6_data[4] )
);

// level 6: compex(5,6)
dlsc_compex #(
    .DATA       ( DATA ),
    .ID         ( ID ),
    .PIPELINE   ( 1 )
) dlsc_compex_inst_6_5_6 (
    .clk        ( clk ),
    .in_id0     ( lvl5_id[5] ),
    .in_data0   ( lvl5_data[5] ),
    .in_id1     ( lvl5_id[6] ),
    .in_data1   ( lvl5_data[6] ),
    .out_id0    ( lvl6_id[5] ),
    .out_data0  ( lvl6_data[5] ),
    .out_id1    ( lvl6_id[6] ),
    .out_data1  ( lvl6_data[6] )
);

// level 6: pass-through 0
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (1 > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_6_0 (
    .clk        ( clk ),
    .in_data    ( lvl5_data[0] ),
    .out_data   ( lvl6_data[0] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (1 > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_6_0 (
    .clk        ( clk ),
    .in_data    ( lvl5_id[0] ),
    .out_data   ( lvl6_id[0] )
);

// level 6: pass-through 7
dlsc_pipedelay #(
    .DATA       ( DATA ),
    .DELAY      ( (1 > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_data_6_7 (
    .clk        ( clk ),
    .in_data    ( lvl5_data[7] ),
    .out_data   ( lvl6_data[7] )
);
dlsc_pipedelay #(
    .DATA       ( ID ),
    .DELAY      ( (1 > 0) ? 2 : 1 )
) dlsc_pipedelay_inst_id_6_7 (
    .clk        ( clk ),
    .in_data    ( lvl5_id[7] ),
    .out_data   ( lvl6_id[7] )
);


// ** outputs **
assign out_id  [ (0*  ID) +:   ID ] = lvl6_id[0];
assign out_data[ (0*DATA) +: DATA ] = lvl6_data[0];
assign out_id  [ (1*  ID) +:   ID ] = lvl6_id[1];
assign out_data[ (1*DATA) +: DATA ] = lvl6_data[1];
assign out_id  [ (2*  ID) +:   ID ] = lvl6_id[2];
assign out_data[ (2*DATA) +: DATA ] = lvl6_data[2];
assign out_id  [ (3*  ID) +:   ID ] = lvl6_id[3];
assign out_data[ (3*DATA) +: DATA ] = lvl6_data[3];
assign out_id  [ (4*  ID) +:   ID ] = lvl6_id[4];
assign out_data[ (4*DATA) +: DATA ] = lvl6_data[4];
assign out_id  [ (5*  ID) +:   ID ] = lvl6_id[5];
assign out_data[ (5*DATA) +: DATA ] = lvl6_data[5];
assign out_id  [ (6*  ID) +:   ID ] = lvl6_id[6];
assign out_data[ (6*DATA) +: DATA ] = lvl6_data[6];
assign out_id  [ (7*  ID) +:   ID ] = lvl6_id[7];
assign out_data[ (7*DATA) +: DATA ] = lvl6_data[7];


// ** delay valid/meta **
dlsc_pipedelay_valid #(
    .DATA       ( META ),
    .DELAY      ( 5 * (PIPELINE?2:1) + 2 ) // 1 or 2 cycles per intermediate stage; last stage always takes 2
) dlsc_pipedelay_valid_inst (
    .clk        ( clk ),
    .rst        ( rst ),
    .in_valid   ( in_valid ),
    .in_data    ( in_meta ),
    .out_valid  ( out_valid ),
    .out_data   ( out_meta )
);

endmodule

