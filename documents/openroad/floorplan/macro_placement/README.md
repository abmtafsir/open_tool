|Item|Description|
|---|---|
|Projrct|OpenROAD|
|Task|Macro Placement|
|Author|ABM Tafsirul Islam|
|Supervisor|Kazi Shady|
|Label|Creation|
|Status|In Progress|
|Start Date|1-Jan-2024|
|End Date|7-Jan-2024|

## Description

This task is related to the macro placement in floorplan step. After running the floorplan step with `make floorplan` command there generated a db in result section. The name of the db is `2_floorplan.odb`. If you load the db in openroad with the command `read_db` it will read the db in openroad shell and will show the gui by executing the command `gui::show` in openroad shell.

## Steps of loading the floorplan db

1. Go to the flow directory: `cd ~/OpenROAD-flow-scripts/flow`
2. Clean all the previous generated file: `make clean all`

    **N.B:** When running the script for the initial time, Step 2 is not obligatory. However, I recommend performing a thorough cleanup initially. This ensures the removal of any existing files, providing a clean slate for a fresh start.
3. Run the floorplan step: `make floorplan`
4. Open the openroad shell: `openroad`
5. Load the db: `read_db results/asap7/riscv32i/base/2_floorplan.odb`
6. Show in gui: `gui::show`

## Task Details

If you look the gui carefully you will find that there are four macros in the design `asap7/riscv32i`. The macros are placed side by side but not maintained the hierarchy (`dmem/dmem2, dmem/dmem0, dmem/dmem3, dmem/dmem1`). The task is to placed the macro by maintaining the hierarchy (`dmem/dmem0, deme/dmem1, dmem/dmem2, dmem/dmem3`). But there is a problem regarding placement status of macro.

If you click the coursor on one of the macro, the information regarding that macro will be shown in the inspector window.There you will find that the placement status is locked means you can't move the placement of the macro neither manually in gui nor using any custom script. 

## Task

1. Write a script that can change the placement status to `PLACED` from `LOCKED` or anything else and also can place the macro by maintaing the hierarchy such as `dmem/dmem0, deme/dmem1, dmem/dmem2, dmem/dmem3`. Source the script after loading the db in openroad shell(write `openroad` to open the openroad shell) with `source path/to/custom/script`

2. Place the script to the flow that can avoid the manual soucing of the custom script means the process will be full automated. You just run the `make floorplan` from the flow and that will source the custom sript automatically and execute the full floorplan process by placing the macro maintaining the hierarchy.