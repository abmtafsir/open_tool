# Placement Makefile Analysis

|Project|Author|Start Date|End Date|
|---|---|---|---|
|Placement Makefile Analysis|A.B.M Tafsirul Islam|13-Mar-2024|13-Mar-2024| 

# Placement Portion

```# ==============================================================================
#  ____  _        _    ____ _____
# |  _ \| |      / \  / ___| ____|
# | |_) | |     / _ \| |   |  _|
# |  __/| |___ / ___ \ |___| |___
# |_|   |_____/_/   \_\____|_____|
#
.PHONY: place
place: $(RESULTS_DIR)/3_place.odb \
       $(RESULTS_DIR)/3_place.sdc
# ==============================================================================
# STEP 1: Global placement without placed IOs, timing-driven, and routability-driven.
#-------------------------------------------------------------------------------
$(eval $(call do-step,3_1_place_gp_skip_io,$(RESULTS_DIR)/2_floorplan.odb $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES),global_place_skip_io))

# STEP 2: IO placement (non-random)
#-------------------------------------------------------------------------------
ifndef IS_CHIP
$(eval $(call do-step,3_2_place_iop,$(RESULTS_DIR)/3_1_place_gp_skip_io.odb $(IO_CONSTRAINTS),io_placement))
else
$(eval $(call do-copy,3_2_place_iop,3_1_place_gp_skip_io.odb,$(IO_CONSTRAINTS)))
endif

# STEP 3: Global placement with placed IOs, timing-driven, and routability-driven.
#-------------------------------------------------------------------------------
$(eval $(call do-step,3_3_place_gp,$(RESULTS_DIR)/3_2_place_iop.odb $(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES),global_place))

# STEP 4: Resizing & Buffering
#-------------------------------------------------------------------------------
$(eval $(call do-step,3_4_place_resized,$(RESULTS_DIR)/3_3_place_gp.odb $(RESULTS_DIR)/2_floorplan.sdc,resize))

.PHONY: clean_resize
clean_resize:
	rm -f $(RESULTS_DIR)/3_4_place_resized.odb

# STEP 5: Detail placement
#-------------------------------------------------------------------------------
$(eval $(call do-step,3_5_place_dp,$(RESULTS_DIR)/3_4_place_resized.odb,detail_place))

$(eval $(call do-copy,3_place,3_5_place_dp.odb,))

$(eval $(call do-copy,3_place,2_floorplan.sdc,,.sdc))

.PHONY: do-place
do-place:
	$(UNSET_AND_MAKE) do-3_1_place_gp_skip_io do-3_2_place_iop do-3_3_place_gp do-3_4_place_resized do-3_5_place_dp do-3_place do-3_place.sdc

# Clean Targets
#-------------------------------------------------------------------------------
.PHONY: clean_place
clean_place:
	rm -f $(RESULTS_DIR)/3_*place*.odb
	rm -f $(RESULTS_DIR)/3_place.sdc
	rm -f $(RESULTS_DIR)/3_*.def $(RESULTS_DIR)/3_*.v
	rm -f $(REPORTS_DIR)/3_*
	rm -f $(LOG_DIR)/3_*
```



# Analysis 

There are 5 steps in placement stage of the design. They are as followings:

1. Global placement without placed IOs, timing-driven, and routability-driven.

    ***do-step:***

    - ***stem (base name of a file):*** 3_1_place_gp_skip_io
    - ***dependencies:***  2_floorplan.odb, 2_floorplan.sdc, $(LIB_FILES)
    - ***tcl file:*** global_place_skip_io

2. IO placement (non-random)

    ***do-step:***
    - ***stem (base name of a file):*** 3_2_place_iop
    - ***dependencies:***  \$(RESULTS_DIR)/3_1_place_gp_skip_io.odb $(IO_CONSTRAINTS)
    - ***tcl file:*** io_placement

    ***do-copy:***
    - ***stem of target:*** 3_2_place_iop
    - ***basename of file to be copied:*** 3_1_place_gp_skip_io.odb
    - ***further dependencies:*** $(IO_CONSTRAINTS)

3. Global placement with placed IOs, timing-driven, and routability-driven.

    ***do-step:***
    - ***stem (base name of a file):*** 3_3_place_gp
    - ***dependencies:***  \$(RESULTS_DIR)/3_2_place_iop.odb \$(RESULTS_DIR)/2_floorplan.sdc $(LIB_FILES)
    - ***tcl file:*** global_place

4. Resizing & Buffering

    ***do-step:***
    - ***stem (base name of a file):*** 3_4_place_resized
    - ***dependencies:***  \$(RESULTS_DIR)/3_3_place_gp.odb $(RESULTS_DIR)/2_floorplan.sdc
    - ***tcl file:*** resize
5. Detail placement

    ***do-step:***
    - ***stem (base name of a file):*** 3_2_place_iop
    - ***dependencies:***  $(RESULTS_DIR)/3_4_place_resized.odb
    - ***tcl file:*** detail_place

    ***do-copy:***
    - ***stem of target:*** 3_place
    - ***basename of file to be copied:*** 3_5_place_dp.odb
    - ***further dependencies:*** 

    ***do-copy:***
    - ***stem of target:*** 3_place
    - ***basename of file to be copied:*** 2_floorplan.sdc
    - ***further dependencies:*** .sdc


Also, there are some additional steps under the following targets in the placement stage. Such as:

1. .PHONY: place
2. .PHONY: clean_resize
3. .PHONY: do-place
4. .PHONY: clean_place

There is a common target in each step mentioned above named as `do-step` and in step 2 and 5 there is a target named `do-copy` which is being called by the bash command `call`. 

**do-step:**

```
# The do- substeps of each of these stages are subject to change.
#
# $(1) stem, e.g. 2_1_floorplan , stem represent the base name of the file
# $(2) dependencies
# $(3) tcl script step
# $(4) extension of result, default .odb
# $(5) folder of target, default $(RESULTS_DIR)
define do-step
$(if $(5),$(5),$(RESULTS_DIR))/$(1)$(if $(4),$(4),.odb): $(2)
	$$(UNSET_AND_MAKE) do-$(1)

.PHONY: do-$(1)
do-$(1):
	($(TIME_CMD) $(OPENROAD_CMD) $(SCRIPTS_DIR)/$(3).tcl -metrics $(LOG_DIR)/$(1).json) 2>&1 | tee $(LOG_DIR)/$(1).log
endef
```

Here, `stem` is the base name of a file without any extension. 

**do-copy:**

```
# generate make rules to copy a file, if a dependency change and
# a do- sibling rule that copies the file unconditionally.
#
# The file is copied within the $(RESULTS_DIR)
#
# $(1) stem of target, e.g. 2_2_floorplan_io
# $(2) basename of file to be copied
# $(3) further dependencies
# $(4) target extension, default .odb
define do-copy
$(RESULTS_DIR)/$(1)$(if $(4),$(4),.odb): $(RESULTS_DIR)/$(2) $(3)
	$$(UNSET_AND_MAKE) do-$(1)$(if $(4),$(4),)

.PHONY: do-$(1)$(if $(4),$(4),)
do-$(1)$(if $(4),$(4),):
	cp $(RESULTS_DIR)/$(2) $(RESULTS_DIR)/$(1)$(if $(4),$(4),.odb)
endef
```