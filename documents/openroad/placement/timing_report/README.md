|Item|Description|
|---|---|
|Project|OpenROAD|
|Task|Timing Report Analysis|
|Author|ABM Tafsirul Islam|
|Supervisor|Kazi Shady|
|Label|Creation|
|Status|In Progress|
|Start Date|26-Feb-2024|
|End Date|01-Mar-2024|

## Description

This task is related to the timing analysis in placement step. After running the placement step with `make gui_place` command there generated a log file in log directory. The name of the log file is `3_5_place_dp.log`. Here I found some necessary info after going through the file. But the focus was in the timing report means the timing path which are violated. After analyzing the log with gui view I found that there is only the worst path that is violated generated in the `3_5_place_dp.log`. But we can see all the violated path in the gui dashboard which is not visible in log file or any other file. We used the command `report_check -from <start_point> -to <end_point>` in the interactive shell to find out the timing information of a path in the terminal as well as in the gui dash board



## Steps of loading the placement db

1. Go to the flow directory: `cd ~/OpenROAD-flow-scripts/flow`
2. Clean all the previous generated file: `make clean all`

    **N.B:** When running the script for the initial time, Step 2 is not obligatory. However, I recommend performing a thorough cleanup initially. This ensures the removal of any existing files, providing a clean slate for a fresh start.
3. Run the placement step: `make gui_place` . It will execute the placement step and open the gui consecutively.
4. Click on the `Timing Report` and `Update` in gui panel. 

## Task Details

After updating the timing report, if we look the gui carefully we will find that there are a lot of violated path visible in the dashboard. The negative slack is the indication of violated path. 

On the other hand if we go through the log file (`3_5_place_dp.log`) we can see that there are only few violated path are visible. But there is no file that carries all the timing report of the violated path.

If we execute the command `report_check -from <start_point> -to <end_point> ` in the interactive shell we can find out the timing information of a path in the terminal as well as in the gui dash board. 


## Task

1. Write a script that can generate a file which carries all the violated timing path. 

2. Write a script that can generate a csv file which carries the following information:

|start Point| End Point| Cell Name| Delay|
|---|---|---|---|
|instr[4]|riscv/dp/\_18868\_/D|BUFx2_ASAP7_75t_R|10.69|

## Execution Steps

1. The following script contains all the timing path that will generate a file (`timing_report`) that contains all the info related to timing path. 

   - [timing_path_separation.tcl](timing_path_separation.tcl)


2. Source the script at interactive shell in gui

   - `source timing_path_separation.tcl`

3. The following script will generate the csv file which contins the target information.

    - [timing_report_v1.tcl](timing_report_v1.tcl)

## Output File

- [timing_report.txt](timing_report.txt)
- [timing_report.csv](timing_report.csv)

## File Summary 

- `timing_path_separation.tcl` : contains all the timing path. This file will generate `timing_report.txt` file

- `timing_report.txt` : contains all the information related to violated timing path

- `timing_report_v1.tcl` : script that generate the csv file

- `timing_report.csv` : output csv file
- `doc.md` : contains all the necessary doccumentation related to timing analysis in placement step
