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

`ifndef DLSC_SYNTHESIS_INCLUDED

`ifdef SYNTHESIS
    `define DLSC_SYNTHESIS

    `ifdef XILINX
        `define DLSC_SYNTHESIS_XILINX
        `define DLSC_SYNTHESIS_DEFINED

        `define DLSC_BRAM               (* ram_style = "block", RDADDR_COLLISION_HWCONFIG = "performance" *)
        `define DLSC_LUTRAM             (* ram_style = "distributed" *)
        `define DLSC_SHREG              (* shreg_extract = "yes" *)
        `define DLSC_NO_SHREG           (* shreg_extract = "no" *)
        `define DLSC_KEEP_REG           (* equivalent_register_removal = "no" *)
        `define DLSC_PIPE_REG           (* equivalent_register_removal = "no", shreg_extract="no" *)
        `define DLSC_FANOUT_REG         (* equivalent_register_removal = "no", shreg_extract="no", register_duplication = "yes", max_fanout = "reduce" *)
        `define DLSC_SYNCFLOP           (* equivalent_register_removal = "no", shreg_extract="no", register_duplication = "no", ASYNC_REG = "TRUE", HBLKNM = "dlsc_syncflops_blknm", IOB = "FALSE", KEEP = "TRUE", OPTIMIZE = "OFF" *)

    `endif // XILINX

    `ifdef ALTERA
        // TODO
    `endif // ALTERA

    `ifndef DLSC_SYNTHESIS_DEFINED
        `define DLSC_SYNTHESIS_GENERIC
    `endif // DLSC_SYNTHESIS_DEFINED

`endif // SYNTHESIS

`ifndef DLSC_SYNTHESIS_DEFINED
    `define DLSC_SYNTHESIS_DEFINED

    `define DLSC_BRAM
    `define DLSC_LUTRAM
    `define DLSC_SHREG
    `define DLSC_NO_SHREG
    `define DLSC_KEEP_REG
    `define DLSC_PIPE_REG
    `define DLSC_FANOUT_REG
    `define DLSC_SYNCFLOP

`endif // DLSC_SYNTHESIS_DEFINED

`endif // DLSC_SYNTHESIS_INCLUDED

