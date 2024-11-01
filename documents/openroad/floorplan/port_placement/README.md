|Item|Description|
|---|---|
|Projrct|OpenROAD|
|Task|Port Placement|
|Author|ABM Tafsirul Islam|
|Supervisor|Kazi Shady|
|Label|Creation|
|Status|In Progress|
|Start Date|12-Jan-2024|
|End Date|-|

## Log

- 12-Jan-2024:
 - Task 1 Added


## Description

After running the floorplan step by `make floorplan` the db (`2_floorplan.odb`) is being created. Load the db by openning the openroad shell(`openroad`) with the command `read_db 2_floorplan.odb`. If you open the design in gui mode by `gui::show` you can observe that all the pin in `asap7/riscv32i` is placed at the bottom of the dsign.  

## Task 

1. Place the input pin at the top of the design and the output at the right side of the design.