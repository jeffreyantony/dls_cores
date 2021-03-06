
include $(DLSC_MAKEFILE_TOP)

DLSC_DEPENDS    += pcie

V_DUT           += dlsc_pcie_s6_outbound_read_req.v

SP_TESTBENCH    += dlsc_pcie_s6_outbound_read_req_tb.sp

V_PARAMS_DEF    += \
    ADDR=32 \
    LEN=4 \
    MAX_SIZE=4096 \
    MERGING=1 \
    MERGE_WINDOW=4

sims0:
	$(MAKE) -f $(THIS) V_PARAMS=""
	$(MAKE) -f $(THIS) V_PARAMS="MAX_SIZE=128"
	$(MAKE) -f $(THIS) V_PARAMS="MAX_SIZE=256 MERGING=0 LEN=6"

sims1:
	$(MAKE) -f $(THIS) V_PARAMS="MERGE_WINDOW=0"
	$(MAKE) -f $(THIS) V_PARAMS="LEN=1"

sims2:
	$(MAKE) -f $(THIS) V_PARAMS="MERGE_WINDOW=1"
	$(MAKE) -f $(THIS) V_PARAMS="LEN=8"
	$(MAKE) -f $(THIS) V_PARAMS="ADDR=13"

sims3:
	$(MAKE) -f $(THIS) V_PARAMS="MERGE_WINDOW=7"
	$(MAKE) -f $(THIS) V_PARAMS="ADDR=13 LEN=2"

include $(DLSC_MAKEFILE_BOT)

