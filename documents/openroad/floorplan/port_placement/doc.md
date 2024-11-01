# Port Placement 

|Project|Author|Start Date|End Date|
|---|---|---|---|
|Port Placement|A.B.M Tafsirul Islam|12-Mar-2024|12-Mar-2024| 

## Objective
The input and output ports are placed at the bottom of the design. We have to placed the input ports at the bottom of the design and the output ports at the rigth side of the design.

## Method

### 1. Without Automation 

This [script](TI_io_pin_separation.tcl) is helpful to place the input ports to the top of the design and the output ports to the right side of the design. If we source the script in the interactive shell after load the db then it will place the ports on to the desired position.

**Steps:**

1. `make clean_all:` Before run any step its better to clean all the previous generated files with `make clean_all` command
2. `make floorplan:` Go to the `~/OpenROAD-flow-scripts/flow` directory and run the floorplan step with `make floorplan` command
3. `read_db 2_floorplan.odb:` Launch the openROAD interactive shell with `openroad` command and then load the db file with `read_db` command 
4. [TI_io_pin_separation.tcl](TI_io_pin_separation.tcl) : Source the script (click in the link) with `source ~/TI_script/TI_io_pin_separation.tcl` command in the openROAD interactive shell.

**Result:**

1. If we look closely at the design we can find that the input ports is being placed at the top and the output port placed at the right side of the design. There are 36 input ports and 99 output ports in the design. Those are place with the regular interval space means input ports is being places with 2.22 spacing and the output port is being place with 0.90 spacing. Point shoul be noted that the length of the x axis (where input port placed) is 80 microns and the length of the t axis (where output port placed) is 90 microns.  


### 1. With Automation

TBC
