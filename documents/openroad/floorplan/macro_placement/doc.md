# Macro Placement

|Project|Author|Start Date|End Date|
|---|---|---|---|
|Macro Placement|A.B.M Tafsirul Islam|11-Mar-2024|11-Mar-2024| 
 
## Objective

Utilize the generated floorplan database (`2_floorplan.odb`) to visualize and analyze the macro placement within the floorplan step using OpenROAD and automate the process with custom script.




 
## Task 

### Details:
If you look the gui carefully you will find that there are four macros in the design `asap7/riscv32i`. The macros are placed side by side but not maintained the hierarchy (`dmem/dmem2, dmem/dmem0, dmem/dmem3, dmem/dmem1`). The task is to placed the macro by maintaining the hierarchy (`dmem/dmem0, deme/dmem1, dmem/dmem2, dmem/dmem3`). But there is a problem regarding placement status of macro.

If you click the coursor on one of the macro, the information regarding that macro will be shown in the inspector window.There you will find that the placement status is locked means you can't move the placement of the macro neither manually in gui nor using any custom script. 

### Task - 01. Script to Change Placement Status and Maintain Hierarchy in GUI

- **Objective**: To change the placement of the macro by maintaining the hierarchy by sourcing a custom script in the interactive shell of openROAD. 
- **Method**: Employed advanced open tools to conduct an exhaustive examination of the design's macro placement with a custom tcl scripts for maintaining the hierarchy.

- **Steps:**
1. Load the floorplan database (`2_floorplan.odb`) in OpenROAD shell using the `read_db` command.
2. Execute the `gui::show` command to display the graphical user interface (GUI) for visualization.
3. Source the follwing script in interactive shell with the `source task1_TI_macro_placement.tcl` command:

    ```
    # Steps to follow:
    # Open "openroad" interactive shell
    # Load db with "read_bd Path/to/go/file_name"
    # Source the following script: "source TI_read_macro_placement.tcl"
    # Show in gui: "gui::show" 
    # Selec the macro and change "placement status: placed" in gui
    # Source the following script with "source -verbose macro_placement_rearrange.tcl"

    # ord is a shell which is being dedicated to work for some commands
    # get_db_block: is the data base for all blocks which contains all the instances 
    set block [ord::get_db_block] 

    # getInst: command finds the instances from the database of block.
    # getMaster: command finds the master db of the instance
    # getType: command finds the type of the instance  
    foreach inst [$block getInsts] {
        if {[[$inst getMaster] getType ] == "BLOCK"} { ; # finds the instances that are dedicated for the BLOCK (macro)
            $inst setPlacementStatus PLACED ; # changed the placement status from locked to placed
        
        }
    
    }

    # macro orientation according to hierarchy
    place_cell -inst_name dmem/dmem0 -orient MY -origin {16.368 39.744}
    place_cell -inst_name dmem/dmem1 -orient MY -origin {30.72 39.744}
    place_cell -inst_name dmem/dmem2 -orient MY -origin {45.12 39.744}
    place_cell -inst_name dmem/dmem3 -orient MY -origin {59.472 39.744}
    ```

**N.B:** Here is the script [link](task1_TI_macro_placement.tcl) 

4. After sourcing the above script the status will be changed from `LOCKED` to `PLACED` and macro will be placed mainting the hierarchy `dmem/dmem0, deme/dmem1, dmem/dmem2, dmem/dmem3`
 
### Task - 02. Automated Floorplan Process with Custom Script Integration
- **Objective**: The process of changing the status of the macro (from `LOCKED` to `PLACED`) and mainting the hierarchy `dmem/dmem0, deme/dmem1, dmem/dmem2, dmem/dmem3` is being generated automatically by running the floorplan step with `make floorplan` commnad.
- **Method**: Change the makefile by replacing the custom script's loaction with the default script loaction.

- **Steps:**

    - Write a tcl file with the following script:
    
        ```
        source $::env(SCRIPTS_DIR)/load.tcl
        load_design 2_3_floorplan_tdms.odb 1_synth.sdc "Starting macro placement"

        proc find_macros {} {
        set macros ""

        set db [ord::get_db]
        set block [[$db getChip] getBlock]
        foreach inst [$block getInsts] {
            set inst_master [$inst getMaster]

            # BLOCK means MACRO cells
            if { [string match [$inst_master getType] "BLOCK"] } {
            append macros " " $inst
            }
        }
        return $macros
        }

        if {[find_macros] != ""} {
        # If wrappers defined replace macros with their wrapped version
        # # ----------------------------------------------------------------------------
        if {[info exists ::env(MACRO_WRAPPERS)]} {
            source $::env(MACRO_WRAPPERS)

            set wrapped_macros [dict keys [dict get $wrapper around]]
            set db [ord::get_db]
            set block [ord::get_db_block]

            foreach inst [$block getInsts] {
            if {[lsearch -exact $wrapped_macros [[$inst getMaster] getName]] > -1} {
                set new_master [dict get $wrapper around [[$inst getMaster] getName]]
                puts "Replacing [[$inst getMaster] getName] with $new_master for [$inst getName]"
                $inst swapMaster [$db findMaster $new_master]
            }
            }
        }

        lassign $::env(MACRO_PLACE_HALO) halo_x halo_y
        lassign $::env(MACRO_PLACE_CHANNEL) channel_x channel_y
        set halo_max [expr max($halo_x, $halo_y)]
        set channel_max [expr max($channel_x, $channel_y)]
        set blockage_width [expr max($halo_max, $channel_max/2)]

        
        if {[info exists ::env(MACRO_BLOCKAGE_HALO)]} {
            set blockage_width $::env(MACRO_BLOCKAGE_HALO)
        }

        if {[info exists ::env(RTLMP_FLOW)]} {
            puts "HierRTLMP Flow enabled..."
            set additional_rtlmp_args ""
            if { [info exists ::env(RTLMP_MAX_LEVEL)]} {
                append additional_rtlmp_args " -max_num_level $env(RTLMP_MAX_LEVEL)"
            }
            if { [info exists ::env(RTLMP_MAX_INST)]} {
                append additional_rtlmp_args " -max_num_inst $env(RTLMP_MAX_INST)"
            }
            if { [info exists ::env(RTLMP_MIN_INST)]} {
                append additional_rtlmp_args " -min_num_inst $env(RTLMP_MIN_INST)"
            }
            if { [info exists ::env(RTLMP_MAX_MACRO)]} {
                append additional_rtlmp_args " -max_num_macro $env(RTLMP_MAX_MACRO)"
            }
            if { [info exists ::env(RTLMP_MIN_MACRO)]} {
                append additional_rtlmp_args " -min_num_macro $env(RTLMP_MIN_MACRO)"
            }
            
            append additional_rtlmp_args " -halo_width $halo_max"

            if { [info exists ::env(RTLMP_MIN_AR)]} {
                append additional_rtlmp_args " -min_ar $env(RTLMP_MIN_AR)"
            }
            if { [info exists ::env(RTLMP_AREA_WT)]} {
                append additional_rtlmp_args " -area_weight $env(RTLMP_AREA_WT)"
            }
            if { [info exists ::env(RTLMP_WIRELENGTH_WT)]} {
                append additional_rtlmp_args " -wirelength_weight $env(RTLMP_WIRELENGTH_WT)"
            }
            if { [info exists ::env(RTLMP_OUTLINE_WT)]} {
                append additional_rtlmp_args " -outline_weight $env(RTLMP_OUTLINE_WT)"
            }
            if { [info exists ::env(RTLMP_BOUNDARY_WT)]} {
                append additional_rtlmp_args " -boundary_weight $env(RTLMP_BOUNDARY_WT)"
            }

            if { [info exists ::env(RTLMP_NOTCH_WT)]} {
                append additional_rtlmp_args " -notch_weight $env(RTLMP_NOTCH_WT)"
            }

            if { [info exists ::env(RTLMP_DEAD_SPACE)]} {
                append additional_rtlmp_args " -dead_space $env(RTLMP_DEAD_SPACE)"
            }
            if { [info exists ::env(RTLMP_CONFIG_FILE)]} {
                append additional_rtlmp_args " -config_file $env(RTLMP_CONFIG_FILE)"
            }
            if { [info exists ::env(RTLMP_RPT_DIR)]} {
                append additional_rtlmp_args " -report_directory $env(RTLMP_RPT_DIR)"
            }

            if { [info exists ::env(RTLMP_FENCE_LX)]} {
                append additional_rtlmp_args " -fence_lx $env(RTLMP_FENCE_LX)"
            }
            if { [info exists ::env(RTLMP_FENCE_LY)]} {
                append additional_rtlmp_args " -fence_ly $env(RTLMP_FENCE_LY)"
            }
            if { [info exists ::env(RTLMP_FENCE_UX)]} {
                append additional_rtlmp_args " -fence_ux $env(RTLMP_FENCE_UX)"
            }
            if { [info exists ::env(RTLMP_FENCE_UY)]} {
                append additional_rtlmp_args " -fence_uy $env(RTLMP_FENCE_UY)"
            }


            puts "Call Macro Placer $additional_rtlmp_args"

            rtl_macro_placer \
                        {*}$additional_rtlmp_args

            puts "Delete buffers for RTLMP flow..."
            remove_buffers
        } else {
            if {[info exists ::env(MACRO_PLACEMENT_TCL)]} {
            source $::env(MACRO_PLACEMENT_TCL)
            puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT_TCL)"
            } elseif {[info exists ::env(MACRO_PLACEMENT)]} {
            source $::env(SCRIPTS_DIR)/read_macro_placement.tcl
            puts "\[INFO\]\[FLOW-xxxx\] Using manual macro placement file $::env(MACRO_PLACEMENT)"
            read_macro_placement $::env(MACRO_PLACEMENT)
            } else {
            macro_placement \
                -halo $::env(MACRO_PLACE_HALO) \
                -channel $::env(MACRO_PLACE_CHANNEL)
            }
        }

        source $::env(SCRIPTS_DIR)/placement_blockages.tcl
        block_channels $blockage_width 
        } else {
        puts "No macros found: Skipping macro_placement"
        }



        # Steps to follow:
        # Open "openroad" interactive shell
        # Load db with "read_bd Path/to/go/file_name"
        # Source the following script: "source TI_read_macro_placement.tcl"
        # Show in gui: "gui::show" 
        # Selec the macro and change "placement status: placed" in gui
        # Source the following script with "source -verbose macro_placement_rearrange.tcl"

        # ord is a shell which is being dedicated to work for some commands
        # get_db_block: is the data base for all blocks which contains all the instances 
        set block [ord::get_db_block] 

        # getInst: command finds the instances from the database of block.
        # getMaster: command finds the master db of the instance
        # getType: command finds the type of the instance  
        foreach inst [$block getInsts] {
            if {[[$inst getMaster] getType ] == "BLOCK"} { ; # finds the instances that are dedicated for the BLOCK (macro)
                $inst setPlacementStatus PLACED ; # changed the placement status from locked to placed
            
            }
        
        }

        # macro orientation according to hierarchy
        place_cell -inst_name dmem/dmem0 -orient MY -origin {16.368 39.744}
        place_cell -inst_name dmem/dmem1 -orient MY -origin {30.72 39.744}
        place_cell -inst_name dmem/dmem2 -orient MY -origin {45.12 39.744}
        place_cell -inst_name dmem/dmem3 -orient MY -origin {59.472 39.744}

        if {![info exists save_checkpoint] || $save_checkpoint} {
        write_db $::env(RESULTS_DIR)/2_4_floorplan_macro.odb
        }
        ``` 

    **N.B:** Here is the script [link](TI_read_macro_placement.tcl)

    - Saved the file to the following location:

        ```
        ~/OpenROAD-flow-scripts/flow/scripts
        ```

    - Change the follwing portion of the makefile with the name of the file (without `.tcl` extension). Such as the name of my script is `TI_read_macro_placement.tcl` and I placed it instead of the default script named `macro_place.tcl` without the `.tcl` extension below:

        ```
        # STEP 4: Macro Placement
        #-------------------------------------------------------------------------------
        #$(eval $(call do-step,2_4_floorplan_macro,$(RESULTS_DIR)/2_3_floorplan_tdms.odb $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_s    ynth.sdc $(MACRO_PLACEMENT) $(MACRO_PLACEMENT_TCL),macro_place))
        $(eval $(call do-step,2_4_floorplan_macro,$(RESULTS_DIR)/2_3_floorplan_tdms.odb $(RESULTS_DIR)/1_synth.v $(RESULTS_DIR)/1_sy    nth.sdc $(MACRO_PLACEMENT) $(MACRO_PLACEMENT_TCL),TI_read_macro_placement))

        ```

    - Save the file and execute the following command:

        ```
        make floorplan
        ```

    - Now load the `2_floorplan.odb ` with `openroad` and view it in gui by `gui::show`

- **Steps**:
  1. **Data Extraction**: Extracted the list of violated paths obtained from the timing analysis reports.
  2. **File Formatting**: Organized the extracted data into a structured format suitable for storage and future reference.
  3. **File Creation**: Created a dedicated file, named "timing_report.txt" to house the documented list of violated paths. This step was done manually by the following command:
  
		```
		report_checks -from <strart_point> -to <end_point> >> timing_report.txt
		```
 

## Result

### Task - 01 :

Here the macro has been placed with mainting the hieraechy but we have to source it manually in the interactive shell by openning the `openroad`

### Task - 02:

Here the macro has been placed with full automation by changing the location of the custom script in the makefile.