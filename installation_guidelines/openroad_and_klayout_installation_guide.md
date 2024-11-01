## Introduction:
This is the installation process of openroad opentool in our local pc. 

## Pre Requisite:
1. It is recommended to use the terminal on wsl or Ubuntu

## Steps:
1. Open terminal on Ubuntu 
2. Clone and Install Dependencies:
    
    - `git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts`
    - `cd OpenROAD-flow-scripts`
    - `git checkout c5fbdc29` # This is the version we will use for our custom flow development.
    - `sudo ./setup.sh`
    
3. Build
    - `./build_openroad.sh --local`

4. Verify Installation: 
The binaries should be available on your $PATH after setting up the environment. The make command runs from RTL-GDSII generation for default design gcd with nangate45 PDK.
    - Open your bashrc and add this line: `source ~/OpenROAD-flow-scripts/env.sh`
    - `yosys -help`
    - `openroad -help`
    - `cd flow`
    - `make`

5. You can view final layout images in OpenROAD GUI using this command:
    - `make gui_final`

## Installing Klayout
Installing Klayout in Ubuntu is straightforward. Open a new terminal in Ubuntu and Type:
```
sudo apt-get install -y klayout
```
Enter the password if it's required.  

**(NOTE:)** This will install klayout and all it's dependencies without asking for further clarification. install without the `-y` option to choose what you want to do. 
