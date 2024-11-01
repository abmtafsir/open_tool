|Item|Description|
|---|---|
|Projrct|OpenROAD|
|Task|Seperate Pre-CTS and Post_CTS|
|Author|ABM Tafsirul Islam|
|Supervisor|Kazi Shady|
|Label|Creation|
|Status|Done|
|Start Date|23-Mar-2024|
|End Date|29-Jan-2024|

## Description

This task is related to the pre-cts and post-cts in cts step. After running the cts step with `make cts` command there generated a db (`4_cts.odb`) in result section and a log (`4_1_cts.log`) file in log directory.If you load the db in openroad with the command `read_db` it will read the db in openroad shell and will show the gui by executing the command `gui::show` in openroad shell.

## Steps of loading the cts db

1. Go to the flow directory: `cd ~/OpenROAD-flow-scripts/flow`
2. Clean all the previous generated file: `make clean all`

    **N.B:** When running the script for the initial time, Step 2 is not obligatory. However, I recommend performing a thorough cleanup initially. This ensures the removal of any existing files, providing a clean slate for a fresh start.
3. Run the floorplan step: `make cts`
4. Open the openroad shell: `openroad`
5. Load the db: `read_db results/asap7/riscv32i/base/4_cts.odb`
6. Show in gui: `gui::show`

## Task Details

After runnig the cts step it generates a log file in log directory named `4_1_cts.log`. This log file contains all the information related to cts step. There are two mejor steps called `pre-cts` and `post-cts` in the cts step which is also visible in log file. 

## Task

Seperate the `pre-cts` and `post-cts` individully and put them in a dedicated directory