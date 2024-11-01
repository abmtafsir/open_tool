# Seperate Pre-CTS and Post-CTS 

|Project|Author|Start Date|End Date|
|---|---|---|---|
|CTS Analysis|A.B.M Tafsirul Islam|26-Feb-2024|1-Mar-2024| 

## Task Execution

1. Dump the following two scripts in the script directory (`/home/abm-tafsir/OpenROAD-flow-scripts/flow/scripts`) 

    - pre-cts: [pre-cts.tcl](pre-cts.tcl)
    - post-cts: [post-cts.tcl](post-cts.tcl)
2. Edit the CTS part of the `Makefile` with custom script. Insert line `621 to 623` in the cts step as shown below:

    ```
    605 # ==============================================================================
    606 #   ____ _____ ____
    607 #  / ___|_   _/ ___|
    608 # | |     | | \___ \
    609 # | |___  | |  ___) |
    610 #  \____| |_| |____/
    611 #
    612 .PHONY: cts
    613 cts: $(RESULTS_DIR)/4_cts.odb \
    614      $(RESULTS_DIR)/4_cts.sdc
    615 # ==============================================================================
    616 
    617 ########################################################################
    618 ## custom script: dump pre-cts and post-cts reports in two seperate file
    619 ########################################################################
    620   mkdir -p $(LOG_DIR)/test-cts
    621   ($(OPENROAD_CMD) $(SCRIPTS_DIR)/pre-cts.tcl -metrics $(LOG_DIR)/test-cts/pre-cts.json) 2>&1 | tee $(LOG_DIR)/test-cts/pre-    cts.log
    622   ($(OPENROAD_CMD) $(SCRIPTS_DIR)/post-cts.tcl -metrics $(LOG_DIR)/test-cts/post-cts.json) 2>&1 | tee $(LOG_DIR)/test-cts/po    st-cts.log
    623 ########################################################################
    624 
    625 # Run TritonCTS
    626 # ------------------------------------------------------------------------------
    627 $(eval $(call do-step,4_1_cts,$(RESULTS_DIR)/3_place.odb $(RESULTS_DIR)/3_place.sdc,cts))
    628 
    629 # Filler cell insertion
    630 # ------------------------------------------------------------------------------
    631 $(eval $(call do-step,4_2_cts_fillcell,$(RESULTS_DIR)/4_1_cts.odb,fillcell))
    632 
    633 $(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.odb
    634 
    635 $(eval $(call do-copy,4_cts,4_2_cts_fillcell.odb))
    636 
    637 .PHONY: do-cts
    638 do-cts:
    639   $(UNSET_AND_MAKE) do-4_1_cts do-4_2_cts_fillcell do-4_cts
    640 
    641 .PHONY: clean_cts
    642 clean_cts:
    643   rm -rf $(RESULTS_DIR)/4_*cts*.odb $(RESULTS_DIR)/4_cts.sdc $(RESULTS_DIR)/4_*.v $(RESULTS_DIR)/4_*.def
    644   rm -f  $(REPORTS_DIR)/4_*
    645   rm -f  $(LOG_DIR)/4_*
    ```
3. Run the cts step of the makefile: `make cts`
    
    N.B: Do `make clean_all` before running the step 3.
4. After that we will get the following seperated files in test-cts directory in log directory.

    - [pre-cts.log](pre-cts.log)
    - [post-cts.log](post-cts.log)
    - [pre-cts.json](pre-cts.json)
    - [post-cts.json](post-cts.json)