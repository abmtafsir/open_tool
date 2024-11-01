# Open ROAD Frequently Asked Question
|Author|Project|Categories|Started|Ended|
|---|---|---|---|---|
|A.B.M Tafsirul Islam|OR FAQ|[Introduction](#introduction)<br>[ORFS Tuitorial](#orfs-tuitorial)<br>[Environment Variable](#environment-variable)<br> [References](#references)|13-Sep-2023|In Progress|

## Introduction

This is the OpenROAD flow script tutorial. Here we will discuss the complete run from RTL to GDS using ORFS. This document is basically for the details of those terminology that we should know to increase our knowledge-base regarding OpenROAD. 

Source [link](https://openroad-flow-scripts.readthedocs.io/en/latest/tutorials/FlowTutorial.html)

## [ORFS Tuitorial](https://openroad-flow-scripts.readthedocs.io/en/latest/tutorials/FlowTutorial.html)

<details>
<summary> 1. What is two stage pipeline in CPU? </summary>

***Ans:***
<br>**Pipelining:** It is a process of arrangement of hardware elements of CPU such that its overall performance should be increase. Simultaneus execution of more than one instruction takes place in pipelined process mean multiple instruction will be taking place at a time. In pipelining multiple instruction are overlapped in execution.[^1] 

**Two stage pipelining:** Stage 1 (Instruction Fetch) In this stage the CPU reads instructions from the address in the memory whose value is present in the program counter. Stage 2 (Instruction Decode) In this stage, instruction is decoded and the register file is accessed to get the values from the registers used in the instruction.

#
</details>

<details>
<summary> 2. What is ibex? </summary>

***Ans:***
<br>`ibex` is a 32 bit RISC-V CPU core written in system verilog (RV32IMC/EMC) with a two-stage pipeline.

#
</details>


## Synthesis 

## Floorplan

<details>
<summary> 1. Why it is possible to place a macro far from the port which is connected through a flop/reg.</summary>

***Ans:***
<br>
In synchronous digital design, the system is driven by a clock signal. All flip-flops or regs in the system are clocked by the same clock signal, which means they all update their outputs at the same time, on the rising or falling edge of the clock signal (depending on the design). Taking this as an advantage, we can place the macro far from the design periphery. 

The macro needs clock signal to operate. Similarly the flop or reg need the clock to generate the output. Say an example, the flop generate the output at first clock signal (rising) and it triggered the macro at second clock signal. Both take same time and for so we can place the macro far from the periphery through flop/reg. 

#
</details>

<details>
<summary> 2. Where we are using cpp, hpp, ord in the script and why </summary>

***Ans:*** 
<br> 

**For cpp and hpp:** We don't use this types file inside the flow. This is used to generate the command that is used for the tool

**For ord:** This is being used as an interactive shell like openroad or gui. 


#
</details>



## [Environment Variable](https://openroad-flow-scripts.readthedocs.io/en/latest/user/FlowVariables.html)

### 1. Library Setup

<details>

<summary> 1. What is .mk file </summary>

***Ans:*** 
<br> `.mk` extension is a more or less standard extension for make files that have other names than the defaults.

**Example:**
```
config.mk
```

# 
</details>

<details>
<summary> 2. What is TECH_LEF? </summary>

***Ans:***
<br>Here `TECH_LEF` is a variable name which actually indicate the path of technology lef. Technology LEF part contains the information regarding all the metal interconnects, via information and related design rules whereas cell LEF part contains information related to the geometry of each cell. [^2]

Technology LEF part contains the following information
- LEF Version ( like 5.7 or 5.8 )
- Units (for database, time,  resistance, capacitance)
- Manufacturing grids 
- Design rules and other details of BEOL (Back End Of Layers)
    -  Layer name (like poly, contact, via1, metal1 etc)
    - Layer type ( like routing, masterslice, cut etc)
    - Prefered direction (like horizontal or vertical)
    - Pitch
    - Minimum width
    - Spacing 
    - Sheet resistance

**Example:** `config.mk` of `asap7` contains
```
export TECH_LEF = $(PLATFORM_DIR)/lef/asap7_tech_1x_201209.lef
```

#
</details>

<details>
<summary> 3.What is SC_LEF? </summary>

***Ans:***
<br> Here `SC_LEF` is a variable name which actually means cell lef. Cell LEF part contains the information related to each cell present in the standard cell library in separate sections.[^3]

Cell LEF basically contains the following information

- Cell name (like AND2X2, CLKBUF1 etc)
- Class ( like CORE or PAD)
- Origin 0 0
- Size (width x height)
- Symmetry ( like XY, X, Y etc)
- Pin Information
    - Pin name (like A, B, Y etc)
    - Direction (like input, output, inout etc )
    - Use (like Signal, clock, power etc)
    - Shape  (Abutment in case of power pin)
    - Layer (like Metal1, Metal2 etc )
    - The rectangular coordinate of pin (llx lly urx ury)

**Example:** `config.mk` of `asap7` contains
```
export SC_LEF  = $(PLATFORM_DIR)/lef/asap7sc7p5t_28_R_1x_220121a.lef
```

#
</details> 

<details>
<summary> 4. What is GDS_FILES? </summary>

***Ans:***
<br> Here `GDS_FILES` is the variable name which represents the path of GDS file. It is a binary file format representing planar geometric shapes, text labels, and other information about the layout in hierarchical form. The data can be used to reconstruct all or part of the artwork to be used in sharing layouts, transferring artwork between different tools, or creating photomasks.[^4]

**Example:** `config.mk` of `asap7` contains
```
export GDS_FILES = $(PLATFORM_DIR)/gds/asap7sc7p5t_28_R_220121a.gds \ $(ADDITIONAL_GDS)
```
</details> 

<details>
<summary> 5. What is DONT_USE_CELLS? </summary>

***Ans:***
<br> Here `DONT_USE_CELLS` is a variable which contains the path of dont use cells.  "Don't use cells" are those cells which are present in the Library and we don't want to use those cells in our design.

We know when ever we are doing optimization or say using the tool like ICC for designing we have to provide a technolofy library. During mapping different logic of our design with proper cell or during optimatization of our design tool uses different types of cells (standard cell/ buffer/invertor/delaycell/fillercell) etc which are present in our specific library. Since these Library is usually design independent so they have a lot of cells which are not require for a particular design.

Now If we would not like to use any particular cells because of many reason (like - driving strength,fanout,size, or our design has some specific requirement or may be some type of cells are creating problem in our design during timing closer etc.) then we can mark or say set an attribute over those cells in our design as `don't use cell`. Now those cells will not be use in our design till the point those are like dont use cell.

Some time designer set few cells as dont use cells for some part of the design and then remove those attribute later on or vice versa.

**Example:** `config.mk` of `asap7` contains

```
# Dont use cells to ease congestion
# Specify at least one filler cell if none
export DONT_USE_CELLS = *x1p*_ASAP7* *xp*_ASAP7*
export DONT_USE_CELLS += SDF* ICG* DFFH*
#export DONT_USE_CELLS += SDF* DFFH*
```
#
</details>


## References

[^1]:https://www.youtube.com/watch?v=nv0yAm5gc-E 
[^2]:https://teamvlsi.com/2020/05/lef-lef-file-in-asic-design.html
[^3]:https://teamvlsi.com/2020/05/lef-lef-file-in-asic-design.
[^4]:https://en.wikipedia.org/wiki/GDSII#:~:text=It%20is%20a%20binary%20file,different%20tools%2C%20or%20creating%20photomasks.