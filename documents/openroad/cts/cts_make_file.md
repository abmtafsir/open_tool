# CTS Makefile Analysis

|Project|Author|Start Date|End Date|
|---|---|---|---|
|CTS Makefile Analysis|A.B.M Tafsirul Islam|11-Mar-2024|11-Mar-2024| 

# CTS Portion

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
617 # Run TritonCTS
618 # ------------------------------------------------------------------------------
619 $(eval $(call do-step,4_1_cts,$(RESULTS_DIR)/3_place.odb $(RESULTS_DIR)/3_place.sdc,cts))
620 
621 # Filler cell insertion
622 # ------------------------------------------------------------------------------
623 $(eval $(call do-step,4_2_cts_fillcell,$(RESULTS_DIR)/4_1_cts.odb,fillcell))
624 
625 $(RESULTS_DIR)/4_cts.sdc: $(RESULTS_DIR)/4_cts.odb
626 
627 $(eval $(call do-copy,4_cts,4_2_cts_fillcell.odb))
628 
629 .PHONY: do-cts
630 do-cts:
631   $(UNSET_AND_MAKE) do-4_1_cts do-4_2_cts_fillcell do-4_cts
632 
633 .PHONY: clean_cts
634 clean_cts:
635   rm -rf $(RESULTS_DIR)/4_*cts*.odb $(RESULTS_DIR)/4_cts.sdc $(RESULTS_DIR)/4_*.v $(RESULTS_DIR)/4_*.def
636   rm -f  $(REPORTS_DIR)/4_*
637   rm -f  $(LOG_DIR)/4_*
```

# Analysis

- **Line 612:** 

    - The .PHONY target cts is defined to indicate that cts is not an actual file but a target name.

- **Line 613 - 614:** 
    - cts target depends on `4_cts.odb` and `4_cts.sdc` files in the `RESULTS_DIR`.

- **Line 619:** 
    
    - `$(eval ...):` is a GNU Make function used to evaluate and expand makefile expressions or rules dynamically.
    - `$(call ...):` is another GNU Make function used to invoke a function.
    - `do-step:` is likely a function defined elsewhere in the Makefile.
    - `4_1_cts:` is a target name or identifier for this step.
    - `$(RESULTS_DIR)/3_place.odb $(RESULTS_DIR)/3_place.sdc:` are dependencies for this step.

- **Line 625:** 
        
    - `$(RESULTS_DIR)/4_cts.sdc:` This is the target file that the rule aims to generate or update. It is a Synopsys Design Constraints (SDC) file used in the Clock Tree Synthesis (CTS) process. 
    - `$(RESULTS_DIR)/4_cts.odb:` This is the prerequisite file that needs to exist or be updated before $(RESULTS_DIR)/4_cts.sdc can be generated. 

- **Line 627:**

    - `$(eval ...):` This is a GNU Make function used to evaluate and expand makefile expressions or rules dynamically.

    - `$(call ...):` This is another GNU Make function used to invoke a function.

    - `do-copy:` This is likely a function defined elsewhere in the Makefile that handles copying files.

    - `4_cts:` This is the stem of the source file.

    - `4_2_cts_fillcell.odb:` This is the stem of the target file.

- **Line 630 - 631:**

    - `do-cts:` This is the target that the rule aims to build. It represents a step or task in the build process, likely related to performing Clock Tree Synthesis (CTS).

    - `do-4_1_cts, do-4_2_cts_fillcell, do-4_cts:` These are phony targets, likely defined elsewhere in the Makefile, each representing a specific subtask or sub-step in the CTS process.

    **N.B:** When `make do-cts` is invoked, GNU Make will ensure that all three dependent targets `(do-4_1_cts, do-4_2_cts_fillcell, and do-4_cts)` are executed in sequence. This ensures that the necessary sub-steps of the CTS process are completed in the correct order.