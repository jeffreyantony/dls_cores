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

// Module Description:
// 2-level synchronizer flipflop for asynchronous domain crossing.
// BYPASS parameter turns module into a wire (use for simplifying parameterized
// async crossings).

module dlsc_syncflop #(
    parameter               BYPASS  = 0,
    parameter               DATA    = 1,
    parameter               DEPTH   = 2, 
`ifndef ICARUS
    // Icarus crashes with explicit parameter size; Verilator fails without it.
    parameter [DATA-1:0]    RESET   = {DATA{1'b0}}
`else
    parameter               RESET   = {DATA{1'b0}}
`endif
) (
    // asynchronous input
    input   wire    [DATA-1:0]  in,

    // synchronized output
    input   wire                clk,
    input   wire                rst,
    output  wire    [DATA-1:0]  out
);

generate
if(BYPASS) begin:GEN_BYPASS
    assign out = in;
end else begin:GEN_ASYNC
    genvar j;
    for(j=0;j<DATA;j=j+1) begin:GEN_SYNCFLOPS
        dlsc_syncflop_slice #(
            .DEPTH  ( DEPTH ),
            .RESET  ( RESET[j] ),
            .ASYNC  ( 0 )
        ) dlsc_syncflop_slice_inst  (
            .clk    ( clk ),
            .rst    ( rst ),
            .in     ( in[j] ),
            .out    ( out[j] )
        );
    end
end
endgenerate

endmodule

