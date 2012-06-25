
// example CSR bus ports

input   wire                    csr_clk,
input   wire                    csr_rst,
input   wire                    csr_cmd_valid,  // qualifier for all csr_cmd_* signals
input   wire                    csr_cmd_write,  // transaction is a write (otherwise it is a read)
input   wire    [CSR_ADDR-1:0]  csr_cmd_addr,   // address for transaction
input   wire    [CSR_DATA-1:0]  csr_cmd_data,   // write data (only valid for write operation)
output  reg                     csr_rsp_valid,  // qualifier for all csr_rsp_* signals
output  reg                     csr_rsp_error,  // transaction failed
output  reg     [CSR_DATA-1:0]  csr_rsp_data,   // read data (only valid for read operation)

/*

Command/response paths are qualified by a 'valid' signal (cmd_valid or
rsp_valid). 'valid' is asserted for only 1 cycle for each transaction. There is
no way to throttle an individual command/response path (no 'ready' qualifier).

Only 1 transaction may be in flight at a given time, allowing slaves to
effectively throttle transactions by not immediately providing a response. Once
a slave generate a response (asserts 'rsp_valid'), it must be able to accept
another command on the following cycle.

A new command can only be issued on the cycle following a response (at the
earliest; later is, of course, okay). Asynchronous (0-cycle) responses are
allowed, but not recommended.

There is no support for transaction metadata (e.g. access protection). Such
things must be handled by the CSR bus bridge.

Responses are always required - even for writes. rsp_error can indicate failure
for both read and write operations.

Response signals must idle at 0 (when rsp_valid is deasserted), in order to
support ORing all slave signals together (cheaper than a mux). These OR gates
are expected to be very high fanin, so slaves should always register their
outputs. For most slaves, it is expected that their output registers will be
the only level of pipelining present (that is, their responses will always be
1-cycle).

All command signals are expected to be very high fanout. They must be driven
directly from registers. A 2-level system is recommended: the 1st level of
registers exist in the CSR bus bridge, while the 2nd level exists in the
address decoders. This yields 2-levels of registering for all high-fanout
signals, and 1-level of registering for per-slave cmd_valid signals.

Slaves are only required to perform a minimum amount of address decoding.
cmd_valid for each slave must be uniquely generated by high-level address
decoding logic. cmd_valid for a given slave should only ever be asserted when
that slave is actually being addressed.

All transactions are naturally-aligned. Strobes are not supported. The minimum
accessible piece of data is equal to the width of the bus. Unrelated fields
should not be grouped in the same register.

Registers with read-side-effects are discouraged (but not prohibited). If
required, they must be naturally-aligned. It is recommended that they be
aligned to the widest bus in the system.

Flag registers (e.g. interrupts) should be clearable by writing a 1.

Registers/fields that are wider than the bus must be little-endian (LSbits are
at offset 0). They are assumed to be accessed from low to high addresses. Any
slave implementing atomic accesses for wide fields should latch read values on
access to the lowest address, and commit write values (or read-side-effects) on
access to the highest address.



Transaction timing examples:

clk         _/-\_/-\_/-\_/-\_/-\_/-\_/-\_/-\_/-\_/-\_/-\_/-\

cmd_valid   _/---\_______/---\___/---\______________________
rsp_valid   __/---\__________/---\___________/---\__________

               0           1   2   3     4     5

0: transaction #0 command + response (asynchronous; 0-cycle response)
1: transaction #1 command (issued with 3-cycle delay from previous response)
2: transaction #1 response (registered; 1 cycle-response)
3: transaction #2 command (issued with minimum 1-cycle delay from previous response)
4: response is delayed; no further commands may be issued until response is received
5: transaction #2 response (slow slave; 3-cycle response)

*/
