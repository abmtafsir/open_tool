# Difference Between Routing SDC with Previous Steps SDC

|Project|Author|Start Date|End Date|
|---|---|---|---|
|Routing|A.B.M Tafsirul Islam|2-Apr-2024|2-Apr-2024| 

## Task Details

After running the routing step there dump a`5_route.sdc` file in result directory. Compare the `5_route.sdc` file with the main sdc file (`constraint.sdc`) and also compare with the previous steps sdc file. 

## Observation

|`5_route.sdc` vs|Comment|
|---|---|
|config.sdc|No difference in clock period. <br>**set_propagated_clock [get_clocks {clk}] present in route**|
|1_synth.sdc|No difference in clock period.<br>**set_propagated_clock [get_clocks {clk}] present in route**|
|2_floorplan.sdc|**set_propagated_clock [get_clocks {clk}]** present in route|
|3_place.sdc|**set_propagated_clock [get_clocks {clk}]** present in route|
|4_cts.sdc|No difference|