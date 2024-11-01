# Difference Between the Number of Buffer, Inverter and Standard Cells in Placement VS CTS

## Table of Content

- [Task Log](#task-log)
- [Task Details](#task-details)
- [Task](#task)
- [Task Executiion](#task-execution)
- [Result](#result)
- [Conclusion](#conclusion)

## Task Log

|Project|Author|Start Date|End Date|
|---|---|---|---|
|CTS Analysis|A.B.M Tafsirul Islam|16-Apr-2024|16-Apr-2024| 


## Task Details
After executing the cts step there I found the violated timing path on the timing report window in gui mode. To view the timing report I updated the report. 

To resolve the violated path in placement step, tool use buffer and inverter as well as add or remove or replace or upsize/downsize some cells in cts step. 

## Task
The task is to find out the difference of the follwoing parameters in between placement and cts step:

1. Number of Buffer
2. Number of Inverter
3. Number of Std Cell 


## Task Execution

### Steps:
Go to the `~/OpenROAD/flow/` directory and do the following steps:

1. Execute the cts step: `make cts`
2. Open in gui mode: `make gui_cts`
3. Source the [timing_path_separation_cts.tcl](timing_path_separation_cts.tcl): `source ~/TI_script/timing_path_separation_cts.tcl` . It will generate a [file](timing_report_cts.txt) named `timing_report_cts.txt` that contains all the details info related to the violate timing path.
4. Run the [script](no_of_buf_inv.tcl): `tclsh no_of_buf_inv.tcl`

## Result

|Category|Placement|CTS|
|---|---|---|
|Buffer|3650|738|
|Inverter|1116|2413|
|Std Cells|34859|38007|

## Conclusion

From the result section, it can be stated that the number of buffer has been reduced in CTS stage and the number inverte has been increased in CTS stage. On the other hand the number of std cell has been increased in CTS stage.