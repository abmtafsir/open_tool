## Introduction:

## Pre Requisite:
1. It is recommended to use the terminal on wsl or ubuntu 
## Steps:
1. Open terminal on Ubuntu 
2. Clone and Install Dependencies:
    - git clone --recursive https://github.com/The-OpenROAD-Project/OpenROAD-flow-scripts
    - cd OpenROAD-flow-scripts
    - sudo ./setup.sh

3. Build
    - ./build_openroad.sh --local

4. Verify Installation: 
The binaries should be available on your $PATH after setting up the environment. The make command runs from RTL-GDSII generation for default design gcd with nangate45 PDK.
    - Open your bashrc and add this line: ~/OpenROAD-flow-scripts/env.sh
    - yosys -help
    - openroad -help
    - cd flow
    - make

5. You can view final layout images in OpenROAD GUI using this command:
    - make gui_final

