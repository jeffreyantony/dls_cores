
include $(DLSC_MAKEFILE_TOP)

DLSC_DEPENDS    += axi_tlm

SP_TESTBENCH    += dlsc_axi_tlm_tb.sp

SP_FILES        += dlsc_axi4lb_tlm_master_32b.sp
SP_FILES        += dlsc_axi4lb_tlm_slave_32b.sp

V_PARAMS_DEF    +=

sims0:
	$(MAKE) -f $(THIS) V_PARAMS=""

include $(DLSC_MAKEFILE_BOT)

