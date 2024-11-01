# Analyzing Setup Violations and Resolving Timing Paths between Placement and CTS

|Project|Author|Start Date|End Date|
|---|---|---|---|
|CTS Analysis|A.B.M Tafsirul Islam|26-Feb-2024|1-Mar-2024| 
  
## Task Execution
 
### Identify Setup Violation Reason

In Very Large Scale Integration (VLSI) design, setup violation refers to a timing issue that occurs when the data at the input of a flip-flop or latch does not stabilize within the required setup time before the arrival of the clock edge. This violation can lead to incorrect data being captured or latched by the flip-flop, potentially causing malfunction or incorrect operation of the digital circuit. The main reasons behind setup violations in VLSI design include:

1. **Clock Skew**: Clock skew refers to the variation in arrival times of the clock signal at different elements of the circuit. When there is significant skew, some flip-flops may receive the clock edge earlier or later than expected, causing setup violations. ***Here `report_clock_skew` command refers to show the clock skew.***

    - **Placement Skew:**

      ```
      Clock clk
      Latency      CRPR       Skew
      riscv/dp/_18848_/CLK v
      1237.68
      dmem/dmem0/clk ^
        0.00      0.00    1237.68
      ```

    - **CTS Skew:**

      ```
      Clock clk
      Latency      CRPR       Skew
      riscv/dp/_19134_/CLK v
      253.99
      riscv/dp/_19889_/CLK ^
      111.18      0.00     142.81
      ```

    - **Discussion:** Here we can see that the skew is high in placement stage rather than in CTS stage. This can be one of the reason for setup violation in placement stage.

2. **Clock Jitter**: Clock jitter is the variation in the period of the clock signal over time. Excessive clock jitter can cause the clock edge to arrive unpredictably, leading to setup violations if the data signal does not stabilize in time.

3. **Propagation Delay**: Propagation delay is the time it takes for a signal to travel through a combinational logic path. If the propagation delay exceeds the setup time of a flip-flop, it can result in setup violations.***Here due to the long distance of the logic path the propagation delay occurs which is on of the reason of setup violation***

4. **High-Frequency Operation**: In high-speed designs, the clock period becomes shorter, reducing the setup time available for data to stabilize. This increases the risk of setup violations if the circuit is not properly designed or optimized for high frequencies.

5. **Clock Buffers and Distribution**: Issues with clock buffers, such as excessive skew or jitter introduced by poorly designed clock distribution networks, can contribute to setup violations across the chip.

6. **Variability**: Process, voltage, and temperature (PVT) variations can affect the performance of transistors and interconnects in an integrated circuit. Variability can lead to unexpected delays that may cause setup violations under certain conditions.

7. **Design Complexity**: Complex designs with multiple clock domains, asynchronous interfaces, or intricate timing requirements are more prone to setup violations if timing constraints are not carefully analyzed and met during the design phase.




### Analyze Small and Large Timing Violated Paths between Placement and CTS
 
#### Small Violated Path (Placement Step)

Here, small violated path (**placement step**) is given below:
 
```
Startpoint: instr[4] (input port clocked by clk)
Endpoint: riscv/dp/_18921_ (falling edge-triggered flip-flop clocked by clk')
Path Group: clk
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   0.00    0.00   clock network delay (ideal)
 207.50  207.50 ^ input external delay
   0.00  207.50 ^ instr[4] (in)
  10.86  218.36 ^ input27/Y (BUFx2_ASAP7_75t_R)
  33.06  251.42 ^ _39_/Y (AO22x2_ASAP7_75t_R)
  20.42  271.84 v riscv/_085_/Y (INVx1_ASAP7_75t_R)
  77.35  349.19 v riscv/_086_/Y (OR5x2_ASAP7_75t_R)
  33.20  382.40 ^ riscv/_087_/Y (CKINVDCx20_ASAP7_75t_R)
  44.44  426.83 v riscv/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)
 131.74  558.57 v riscv/dp/_09995_/Y (AND2x2_ASAP7_75t_R)
  23.84  582.41 v load_slew155/Y (BUFx16f_ASAP7_75t_R)
  29.73  612.15 v wire154/Y (BUFx16f_ASAP7_75t_R)
  72.47  684.61 v max_length153/Y (BUFx16f_ASAP7_75t_R)
  37.62  722.23 v riscv/dp/_10800_/Y (AO221x1_ASAP7_75t_R)
  27.61  749.84 v riscv/dp/_10801_/Y (OA211x2_ASAP7_75t_R)
  35.54  785.38 v riscv/dp/_10802_/Y (AO221x2_ASAP7_75t_R)
  25.24  810.62 ^ riscv/dp/_10803_/Y (NAND2x2_ASAP7_75t_R)
  61.82  872.43 ^ riscv/dp/_18830_/SN (HAxp5_ASAP7_75t_R)
  27.60  900.03 ^ riscv/dp/_14416_/Y (OR2x2_ASAP7_75t_R)
  13.28  913.32 ^ riscv/dp/_14417_/Y (AO21x1_ASAP7_75t_R)
  12.93  926.25 ^ riscv/dp/_14418_/Y (AO21x1_ASAP7_75t_R)
  18.95  945.19 ^ riscv/dp/_14419_/Y (OA211x2_ASAP7_75t_R)
  25.34  970.53 ^ riscv/dp/_14420_/Y (OA31x2_ASAP7_75t_R)
  26.90  997.43 ^ riscv/dp/_14432_/Y (OA31x2_ASAP7_75t_R)
  21.89 1019.32 ^ riscv/dp/_15278_/Y (OA21x2_ASAP7_75t_R)
  20.73 1040.06 ^ riscv/dp/_15362_/Y (OA21x2_ASAP7_75t_R)
  16.44 1056.50 ^ riscv/dp/_15761_/Y (OR2x2_ASAP7_75t_R)
  14.49 1070.98 ^ riscv/dp/_15762_/Y (AO21x1_ASAP7_75t_R)
  10.66 1081.65 v riscv/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)
  26.94 1108.58 ^ riscv/dp/_18739_/CON (FAx1_ASAP7_75t_R)
  12.94 1121.52 v riscv/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)
  11.98 1133.49 ^ riscv/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)
  22.29 1155.79 ^ riscv/dp/_15438_/Y (AO221x1_ASAP7_75t_R)
  21.66 1177.45 ^ riscv/dp/_15441_/Y (AO22x1_ASAP7_75t_R)
  78.49 1255.93 ^ riscv/dp/_15442_/Y (AO31x2_ASAP7_75t_R)
 170.10 1426.04 v dmem/_155_/Y (NOR3x2_ASAP7_75t_R)
  91.36 1517.40 v dmem/_210_/Y (AO22x1_ASAP7_75t_R)
  23.62 1541.01 v dmem/_211_/Y (AO21x2_ASAP7_75t_R)
  28.65 1569.66 v riscv/dp/_15881_/Y (AND3x4_ASAP7_75t_R)
  31.60 1601.27 v riscv/dp/_15900_/Y (OA33x2_ASAP7_75t_R)
  33.55 1634.81 v riscv/dp/_15901_/Y (OA21x2_ASAP7_75t_R)
  32.21 1667.02 v riscv/dp/_16288_/Y (AND3x1_ASAP7_75t_R)
  15.88 1682.90 v riscv/dp/_16289_/Y (AO21x1_ASAP7_75t_R)
   0.00 1682.91 v riscv/dp/_18921_/D (DFFLQNx2_ASAP7_75t_R)
        1682.91   data arrival time

1660.00 1660.00   clock clk' (fall edge)
   0.00 1660.00   clock network delay (ideal)
   0.00 1660.00   clock reconvergence pessimism
        1660.00 v riscv/dp/_18921_/CLK (DFFLQNx2_ASAP7_75t_R)
 -10.23 1649.77   library setup time
        1649.77   data required time
---------------------------------------------------------
        1649.77   data required time
        -1682.91   data arrival time
---------------------------------------------------------
         -33.13   slack (VIOLATED)
 
```
 
**Reasons for violated path are:**
1. Setup path is violated for the timing period
2. Long distance of the logic path.


#### Small Violated Path (CTS Step)
Here, small violated path (**CTS step)** that is corresponding to the placement step is given below that has been met:
 
```
Startpoint: instr[4] (input port clocked by clk)
Endpoint: riscv/dp/_18921_ (falling edge-triggered flip-flop clocked by clk')
Path Group: clk
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   0.00    0.00   clock network delay (propagated)
 207.50  207.50 ^ input external delay
   0.00  207.50 ^ instr[4] (in)
  10.87  218.37 ^ input27/Y (BUFx2_ASAP7_75t_R)
  33.07  251.44 ^ _39_/Y (AO22x2_ASAP7_75t_R)
  20.59  272.03 v riscv/_085_/Y (INVx1_ASAP7_75t_R)
  77.35  349.37 v riscv/_086_/Y (OR5x2_ASAP7_75t_R)
  33.11  382.48 ^ riscv/_087_/Y (CKINVDCx20_ASAP7_75t_R)
  45.16  427.64 v riscv/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)
 159.50  587.14 v riscv/dp/_09959_/Y (AND2x6_ASAP7_75t_R)
  96.47  683.61 v riscv/dp/_11206_/Y (OA21x2_ASAP7_75t_R)
  28.54  712.15 v riscv/dp/_11227_/Y (OA211x2_ASAP7_75t_R)
  71.03  783.19 ^ riscv/dp/_11228_/Y (AOI221x1_ASAP7_75t_R)
  38.86  822.04 v riscv/dp/_11229_/Y (INVx2_ASAP7_75t_R)
  25.87  847.92 ^ riscv/dp/_18816_/CON (HAxp5_ASAP7_75t_R)
  15.38  863.29 v riscv/dp/_18816_/SN (HAxp5_ASAP7_75t_R)
  25.17  888.46 v riscv/dp/_14423_/Y (OR2x2_ASAP7_75t_R)
  36.62  925.08 v riscv/dp/_14424_/Y (OR4x1_ASAP7_75t_R)
  21.98  947.06 v riscv/dp/_14431_/Y (OA22x2_ASAP7_75t_R)
  21.95  969.00 v riscv/dp/_14432_/Y (OA31x2_ASAP7_75t_R)
  23.30  992.30 v riscv/dp/_15278_/Y (OA21x2_ASAP7_75t_R)
  22.08 1014.38 v riscv/dp/_15362_/Y (OA21x2_ASAP7_75t_R)
  19.62 1034.00 v riscv/dp/_15761_/Y (OR2x2_ASAP7_75t_R)
  15.76 1049.75 v riscv/dp/_15762_/Y (AO21x1_ASAP7_75t_R)
  13.33 1063.09 ^ riscv/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)
  23.05 1086.14 v riscv/dp/_18739_/CON (FAx1_ASAP7_75t_R)
  23.73 1109.87 v riscv/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)
  12.10 1121.97 ^ riscv/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)
  22.33 1144.31 ^ riscv/dp/_15438_/Y (AO221x1_ASAP7_75t_R)
  21.58 1165.89 ^ riscv/dp/_15441_/Y (AO22x1_ASAP7_75t_R)
  58.30 1224.19 ^ riscv/dp/_15442_/Y (AO31x2_ASAP7_75t_R)
 203.88 1428.07 v dmem/_155_/Y (NOR3x2_ASAP7_75t_R)
  54.62 1482.68 v dmem/_210_/Y (AO22x1_ASAP7_75t_R)
  23.61 1506.29 v dmem/_211_/Y (AO21x2_ASAP7_75t_R)
  28.78 1535.07 v riscv/dp/_15881_/Y (AND3x4_ASAP7_75t_R)
  31.71 1566.78 v riscv/dp/_15900_/Y (OA33x2_ASAP7_75t_R)
  33.64 1600.41 v riscv/dp/_15901_/Y (OA21x2_ASAP7_75t_R)
  32.23 1632.65 v riscv/dp/_16288_/Y (AND3x1_ASAP7_75t_R)
  15.93 1648.57 v riscv/dp/_16289_/Y (AO21x1_ASAP7_75t_R)
   0.01 1648.58 v riscv/dp/_18921_/D (DFFLQNx2_ASAP7_75t_R)
        1648.58   data arrival time

1660.00 1660.00   clock clk' (fall edge)
 119.29 1779.29   clock network delay (propagated)
   0.00 1779.29   clock reconvergence pessimism
        1779.29 v riscv/dp/_18921_/CLK (DFFLQNx2_ASAP7_75t_R)
  -7.75 1771.54   library setup time
        1771.54   data required time
---------------------------------------------------------
        1771.54   data required time
        -1648.58   data arrival time
---------------------------------------------------------
         122.96   slack (MET)
```

**N.B:** The analysis behind the reason of met the slack in cts step is given in **Compare Timing Paths Between Placement and CTS (For small violation)** section
 
#### Large violated path (Placement Step)
 
Here, large violated path (placement step) is given below:
 
```
    Startpoint: instr[4] (input port clocked by clk)
    Endpoint: riscv/dp/_18868_ (falling edge-triggered flip-flop clocked by clk')
    Path Group: clk
    Path Type: max

      Delay    Time   Description
    ---------------------------------------------------------
      0.00    0.00   clock clk (rise edge)
      0.00    0.00   clock network delay (ideal)
    207.50  207.50 ^ input external delay
      0.00  207.50 ^ instr[4] (in)
      10.86  218.36 ^ input27/Y (BUFx2_ASAP7_75t_R)
      33.06  251.42 ^ _39_/Y (AO22x2_ASAP7_75t_R)
      20.42  271.84 v riscv/_085_/Y (INVx1_ASAP7_75t_R)
      77.35  349.19 v riscv/_086_/Y (OR5x2_ASAP7_75t_R)
      33.20  382.40 ^ riscv/_087_/Y (CKINVDCx20_ASAP7_75t_R)
      44.44  426.83 v riscv/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)
    131.74  558.57 v riscv/dp/_09995_/Y (AND2x2_ASAP7_75t_R)
      23.84  582.41 v load_slew155/Y (BUFx16f_ASAP7_75t_R)
      29.73  612.15 v wire154/Y (BUFx16f_ASAP7_75t_R)
      72.47  684.61 v max_length153/Y (BUFx16f_ASAP7_75t_R)
      37.62  722.23 v riscv/dp/_10800_/Y (AO221x1_ASAP7_75t_R)
      27.61  749.84 v riscv/dp/_10801_/Y (OA211x2_ASAP7_75t_R)
      35.54  785.38 v riscv/dp/_10802_/Y (AO221x2_ASAP7_75t_R)
      25.24  810.62 ^ riscv/dp/_10803_/Y (NAND2x2_ASAP7_75t_R)
      61.82  872.43 ^ riscv/dp/_18830_/SN (HAxp5_ASAP7_75t_R)
      27.60  900.03 ^ riscv/dp/_14416_/Y (OR2x2_ASAP7_75t_R)
      13.28  913.32 ^ riscv/dp/_14417_/Y (AO21x1_ASAP7_75t_R)
      12.93  926.25 ^ riscv/dp/_14418_/Y (AO21x1_ASAP7_75t_R)
      18.95  945.19 ^ riscv/dp/_14419_/Y (OA211x2_ASAP7_75t_R)
      25.34  970.53 ^ riscv/dp/_14420_/Y (OA31x2_ASAP7_75t_R)
      26.90  997.43 ^ riscv/dp/_14432_/Y (OA31x2_ASAP7_75t_R)
      21.89 1019.32 ^ riscv/dp/_15278_/Y (OA21x2_ASAP7_75t_R)
      20.73 1040.06 ^ riscv/dp/_15362_/Y (OA21x2_ASAP7_75t_R)
      16.44 1056.50 ^ riscv/dp/_15761_/Y (OR2x2_ASAP7_75t_R)
      14.49 1070.98 ^ riscv/dp/_15762_/Y (AO21x1_ASAP7_75t_R)
      10.66 1081.65 v riscv/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)
      26.94 1108.58 ^ riscv/dp/_18739_/CON (FAx1_ASAP7_75t_R)
      12.94 1121.52 v riscv/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)
      11.98 1133.49 ^ riscv/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)
      22.29 1155.79 ^ riscv/dp/_15438_/Y (AO221x1_ASAP7_75t_R)
      21.66 1177.45 ^ riscv/dp/_15441_/Y (AO22x1_ASAP7_75t_R)
      78.49 1255.93 ^ riscv/dp/_15442_/Y (AO31x2_ASAP7_75t_R)
    170.10 1426.04 v dmem/_155_/Y (NOR3x2_ASAP7_75t_R)
      91.58 1517.61 v dmem/_256_/Y (AO22x1_ASAP7_75t_R)
      22.19 1539.80 v dmem/_257_/Y (AO21x1_ASAP7_75t_R)
      35.38 1575.18 v riscv/dp/_15964_/Y (AND4x2_ASAP7_75t_R)
      22.12 1597.31 v riscv/dp/_16008_/Y (AO21x1_ASAP7_75t_R)
      15.72 1613.03 v riscv/dp/_16009_/Y (AO21x1_ASAP7_75t_R)
      23.71 1636.74 v riscv/dp/_16011_/Y (AO221x1_ASAP7_75t_R)
      9.35 1646.09 ^ riscv/dp/_16012_/Y (NAND2x1_ASAP7_75t_R)
      22.73 1668.82 ^ riscv/dp/_16013_/Y (OA31x2_ASAP7_75t_R)
      50.67 1719.49 v riscv/dp/_16014_/Y (OAI21x1_ASAP7_75t_R)
      63.21 1782.71 v riscv/dp/_16016_/Y (OA21x2_ASAP7_75t_R)
      0.01 1782.71 v riscv/dp/_18868_/D (DFFLQNx2_ASAP7_75t_R)
            1782.71   data arrival time

    1660.00 1660.00   clock clk' (fall edge)
      0.00 1660.00   clock network delay (ideal)
      0.00 1660.00   clock reconvergence pessimism
            1660.00 v riscv/dp/_18868_/CLK (DFFLQNx2_ASAP7_75t_R)
    -10.20 1649.80   library setup time
            1649.80   data required time
    ---------------------------------------------------------
            1649.80   data required time
            -1782.71   data arrival time
    ---------------------------------------------------------
            -132.92   slack (VIOLATED)
```

**Reasons for violated path are:**
1. Setup path is violated for the timing period
2. Long distance of the logic path.

#### Large violated path (CTS Step)

Here, the similar large violated path in cts step that has been met is given below:
 
```
Startpoint: instr[4] (input port clocked by clk)
Endpoint: riscv/dp/_18868_ (falling edge-triggered flip-flop clocked by clk')
Path Group: clk
Path Type: max

  Delay    Time   Description
---------------------------------------------------------
   0.00    0.00   clock clk (rise edge)
   0.00    0.00   clock network delay (propagated)
 207.50  207.50 ^ input external delay
   0.00  207.50 ^ instr[4] (in)
  10.87  218.37 ^ input27/Y (BUFx2_ASAP7_75t_R)
  33.07  251.44 ^ _39_/Y (AO22x2_ASAP7_75t_R)
  20.59  272.03 v riscv/_085_/Y (INVx1_ASAP7_75t_R)
  77.35  349.37 v riscv/_086_/Y (OR5x2_ASAP7_75t_R)
  33.11  382.48 ^ riscv/_087_/Y (CKINVDCx20_ASAP7_75t_R)
  45.16  427.64 v riscv/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)
 159.50  587.14 v riscv/dp/_09959_/Y (AND2x6_ASAP7_75t_R)
  96.47  683.61 v riscv/dp/_11206_/Y (OA21x2_ASAP7_75t_R)
  28.54  712.15 v riscv/dp/_11227_/Y (OA211x2_ASAP7_75t_R)
  71.03  783.19 ^ riscv/dp/_11228_/Y (AOI221x1_ASAP7_75t_R)
  38.86  822.04 v riscv/dp/_11229_/Y (INVx2_ASAP7_75t_R)
  25.87  847.92 ^ riscv/dp/_18816_/CON (HAxp5_ASAP7_75t_R)
  15.38  863.29 v riscv/dp/_18816_/SN (HAxp5_ASAP7_75t_R)
  25.17  888.46 v riscv/dp/_14423_/Y (OR2x2_ASAP7_75t_R)
  36.62  925.08 v riscv/dp/_14424_/Y (OR4x1_ASAP7_75t_R)
  21.98  947.06 v riscv/dp/_14431_/Y (OA22x2_ASAP7_75t_R)
  21.95  969.00 v riscv/dp/_14432_/Y (OA31x2_ASAP7_75t_R)
  23.30  992.30 v riscv/dp/_15278_/Y (OA21x2_ASAP7_75t_R)
  22.08 1014.38 v riscv/dp/_15362_/Y (OA21x2_ASAP7_75t_R)
  19.62 1034.00 v riscv/dp/_15761_/Y (OR2x2_ASAP7_75t_R)
  15.76 1049.75 v riscv/dp/_15762_/Y (AO21x1_ASAP7_75t_R)
  13.33 1063.09 ^ riscv/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)
  23.05 1086.14 v riscv/dp/_18739_/CON (FAx1_ASAP7_75t_R)
  23.73 1109.87 v riscv/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)
  12.10 1121.97 ^ riscv/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)
  22.33 1144.31 ^ riscv/dp/_15438_/Y (AO221x1_ASAP7_75t_R)
  21.58 1165.89 ^ riscv/dp/_15441_/Y (AO22x1_ASAP7_75t_R)
  58.30 1224.19 ^ riscv/dp/_15442_/Y (AO31x2_ASAP7_75t_R)
 203.88 1428.07 v dmem/_155_/Y (NOR3x2_ASAP7_75t_R)
  54.62 1482.68 v dmem/_256_/Y (AO22x1_ASAP7_75t_R)
  22.12 1504.81 v dmem/_257_/Y (AO21x1_ASAP7_75t_R)
  35.42 1540.23 v riscv/dp/_15964_/Y (AND4x2_ASAP7_75t_R)
  22.12 1562.35 v riscv/dp/_16008_/Y (AO21x1_ASAP7_75t_R)
  15.72 1578.07 v riscv/dp/_16009_/Y (AO21x1_ASAP7_75t_R)
  23.71 1601.78 v riscv/dp/_16011_/Y (AO221x1_ASAP7_75t_R)
   9.30 1611.08 ^ riscv/dp/_16012_/Y (NAND2x1_ASAP7_75t_R)
  22.76 1633.84 ^ riscv/dp/_16013_/Y (OA31x2_ASAP7_75t_R)
  51.55 1685.39 v riscv/dp/_16014_/Y (OAI21x1_ASAP7_75t_R)
  61.91 1747.30 v riscv/dp/_16016_/Y (OA21x2_ASAP7_75t_R)
   0.01 1747.30 v riscv/dp/_18868_/D (DFFLQNx2_ASAP7_75t_R)
        1747.30   data arrival time

1660.00 1660.00   clock clk' (fall edge)
 126.96 1786.96   clock network delay (propagated)
   0.00 1786.96   clock reconvergence pessimism
        1786.96 v riscv/dp/_18868_/CLK (DFFLQNx2_ASAP7_75t_R)
  -7.68 1779.28   library setup time
        1779.28   data required time
---------------------------------------------------------
        1779.28   data required time
        -1747.30   data arrival time
---------------------------------------------------------
          31.98   slack (MET)
```

**N.B:** The analysis behind the reason of met the slack in cts step is given in **Compare Timing Paths Between Placement and CTS (For small violation)** section 
 

## Compare Timing Paths Between Placement and CTS (For small violation)

### Difference between Placement and CTS stage
||Placement|||CTS||
|---|---|---|---|---|---| 
|  Delay|Time|Description|  Delay |  Time | Description|
|0|0|clock clk (rise edge)|0|0|  clock clk (rise edge)|
|0|0|clock network delay (ideal)|0|0|clock network delay (propagated)|
|207.5|207.5|input external delay|207.5|207.5|input external delay|
|0|207.5|instr[4] (in)|0|207.5|instr[4] (in)|
|10.86|218.36|input27/Y (BUFx2_ASAP7_75t_R)|10.87|218.37| input27/Y (BUFx2_ASAP7_75t_R)|
|33.06|251.42|_39_/Y (AO22x2_ASAP7_75t_R)|33.07|251.44|_39_/Y (AO22x2_ASAP7_75t_R)|
|20.42|271.84|risc/_085_/Y (INVx1_ASAP7_75t_R)|20.59|272.03|risc/_085_/Y (INVx1_ASAP7_75t_R)|
|77.35|349.19|risc/_086_/Y (OR5x2_ASAP7_75t_R)|77.35|349.37|risc/_086_/Y (OR5x2_ASAP7_75t_R)|
|33.2|382.4|risc/_087_/Y (CKINVDCx20_ASAP7_75t_R)|33.11|382.48|risc/_087_/Y (CKINVDCx20_ASAP7_75t_R)|
|44.44|426.83|risc/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)|45.16|427.64|risc/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)|
|131.74|558.57|risc/dp/_09995_/Y **(AND2x2_ASAP7_75t_R)**|159.5|587.14|risc/dp/_09959_/Y **(AND2x6_ASAP7_75t_R)**|
|23.84|582.41|load_slew155/Y (**BUFx16f_ASAP7_75t_R**)|96.47|683.61|risc/dp/_11206_/Y (OA21x2_ASAP7_75t_R)|
|29.73|612.15|wire154/Y (**BUFx16f_ASAP7_75t_R**)|28.54|712.15|risc/dp/_11227_/Y (OA211x2_ASAP7_75t_R)|
|72.47|684.61|max_length153/Y (**BUFx16f_ASAP7_75t_R**)|71.03|783.19|risc/dp/_11228_/Y (AOI221x1_ASAP7_75t_R)|
|37.62|722.23|risc/dp/_10800_/Y (AO221x1_ASAP7_75t_R)|38.86|822.04|risc/dp/_11229_/Y (INVx2_ASAP7_75t_R)|
|27.61|749.84|risc/dp/_10801_/Y (OA211x2_ASAP7_75t_R)|25.87|847.92|risc/dp/_18816_/CON (HAxp5_ASAP7_75t_R)|
|35.54|785.38|risc/dp/_10802_/Y (**AO221x2_ASAP7_75t_R**)|15.38|863.29|risc/dp/_18816_/SN (HAxp5_ASAP7_75t_R)|
|25.24|810.62|risc/dp/_10803_/Y (**NAND2x2_ASAP7_75t_R**)|25.17|888.46|risc/dp/_14423_/Y (OR2x2_ASAP7_75t_R)|
|61.82|872.43|risc/dp/_18830_/SN (HAxp5_ASAP7_75t_R)|36.62|925.08|risc/dp/_14424_/Y (OR4x1_ASAP7_75t_R)|
|27.6|900.03|risc/dp/_14416_/Y (OR2x2_ASAP7_75t_R)|21.98|947.06|risc/dp/_14431_/Y (OA22x2_ASAP7_75t_R)|
|13.28|913.32|risc/dp/_14417_/Y (AO21x1_ASAP7_75t_R)|21.95|969|risc/dp/_14432_/Y (OA31x2_ASAP7_75t_R)|
|12.93|926.25|risc/dp/_14418_/Y (AO21x1_ASAP7_75t_R)|23.3|992.3|risc/dp/_15278_/Y (OA21x2_ASAP7_75t_R)|
|18.95|945.19|risc/dp/_14419_/Y (OA211x2_ASAP7_75t_R)|22.08|1014.38|risc/dp/_15362_/Y (OA21x2_ASAP7_75t_R)|
|25.34|970.53|risc/dp/_14420_/Y (OA31x2_ASAP7_75t_R)|19.62|1034|risc/dp/_15761_/Y (OR2x2_ASAP7_75t_R)|
|26.9|997.43|risc/dp/_14432_/Y (OA31x2_ASAP7_75t_R)|15.76|1049.75|risc/dp/_15762_/Y (AO21x1_ASAP7_75t_R)|
|21.89|1019.32|risc/dp/_15278_/Y (OA21x2_ASAP7_75t_R)|13.33|1063.09|risc/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)|
|20.73|1040.06|risc/dp/_15362_/Y (OA21x2_ASAP7_75t_R)|23.05|1086.14|risc/dp/_18739_/CON (FAx1_ASAP7_75t_R)|
|16.44|1056.5|risc/dp/_15761_/Y (OR2x2_ASAP7_75t_R)|23.73|1109.87|risc/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)|
|14.49|1070.98|risc/dp/_15762_/Y (AO21x1_ASAP7_75t_R)|12.1|1121.97|risc/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)|
|10.66|1081.65|risc/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)|22.33|1144.31|risc/dp/_15438_/Y (AO221x1_ASAP7_75t_R)|
|26.94|1108.58|risc/dp/_18739_/CON (FAx1_ASAP7_75t_R)|21.58|1165.89|risc/dp/_15441_/Y (AO22x1_ASAP7_75t_R)|
|12.94|1121.52|risc/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)|58.3|1224.19|risc/dp/_15442_/Y (AO31x2_ASAP7_75t_R)|
|11.98|1133.49|risc/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)|203.88|1428.07|dmem/_155_/Y (NOR3x2_ASAP7_75t_R)|
|22.29|1155.79|risc/dp/_15438_/Y (AO221x1_ASAP7_75t_R)|54.62|1482.68|dmem/_210_/Y (AO22x1_ASAP7_75t_R)|
|21.66|1177.45|risc/dp/_15441_/Y (AO22x1_ASAP7_75t_R)|23.61|1506.29|dmem/_211_/Y (AO21x2_ASAP7_75t_R)|
|78.49|1255.93|risc/dp/_15442_/Y (AO31x2_ASAP7_75t_R)|28.78|1535.07|risc/dp/_15881_/Y (AND3x4_ASAP7_75t_R)|
|170.1|1426.04|dmem/_155_/Y (NOR3x2_ASAP7_75t_R)|31.71|1566.78|risc/dp/_15900_/Y (OA33x2_ASAP7_75t_R)|
|91.36|1517.4|dmem/_210_/Y (AO22x1_ASAP7_75t_R)|33.64|1600.41|risc/dp/_15901_/Y (OA21x2_ASAP7_75t_R)|
|23.62|1541.01|dmem/_211_/Y (AO21x2_ASAP7_75t_R)|32.23|1632.65|risc/dp/_16288_/Y (AND3x1_ASAP7_75t_R)|
|28.65|1569.66|risc/dp/_15881_/Y (AND3x4_ASAP7_75t_R)|15.93|1648.57|risc/dp/_16289_/Y (AO21x1_ASAP7_75t_R)|
|31.6|1601.27|risc/dp/_15900_/Y (OA33x2_ASAP7_75t_R)|0.01|1648.58|risc/dp/_18921_/D (DFFLQNx2_ASAP7_75t_R)|
|33.55|1634.81|risc/dp/_15901_/Y (OA21x2_ASAP7_75t_R)||||
|32.21|1667.02|risc/dp/_16288_/Y (AND3x1_ASAP7_75t_R)||||
|15.88|1682.9|risc/dp/_16289_/Y (AO21x1_ASAP7_75t_R)||||
|0|1682.91|risc/dp/_18921_/D (DFFLQNx2_ASAP7_75t_R)||||
|||||||
|       |1682.91|data arrial time|        |1648.58| data arrial time|
|1660|1660|clock clk' (fall edge)|1660|1660| clock clk' (fall edge)|
|0|1660|clock network delay (ideal)|119.29|1779.29|clock network delay (propagated)|
|0|1660|clock reconergence pessimism|0|1779.29|clock reconergence pessimism|
|       |1660|risc/dp/_18921_/CLK (DFFLQNx2_ASAP7_75t_R)|        |1779.29|risc/dp/_18921_/CLK (DFFLQNx2_ASAP7_75t_R)|
|-10.23|1649.77|library setup time|-7.75|1771.54| library setup time|
|       |1649.77|data required time|       |1771.54|data required time|
|||||||
|       |1649.77|data required time|        |1771.54|data required time|
|       |-1682.91|data arrial time|        |-1648.58| data arrial time|
|||||||
|       |-33.13|slack (VIOLATED)|        |122.96|slack (MET)|


### Report and Reason

- **AND2x2_ASAP7_75t_R** cell used in placement step but in cts step **AND2x6_ASAP7_75t_R** used instead of **AND2x2_ASAP7_75t_R**  cell. Here it is clearly visible that the driving strength is being increased from 2 to 6. For so, the delay increased in cts.
- Buffer chain of **BUFx16f_ASAP7_75t_R** cell is being removed in cts. 
- **AO221x2_ASAP7_75t_R** and **NAND2x2_ASAP7_75t_R** cell is being removed in cts.
- Data arrival time in placement is **1682.91**. On the otherhand in cts is **1648.58**. Due to the removal of some std cells,buffer and also increasing the driving strength of the cell in cts step, it took less time for the data to arrived.
- Clock network delay in placement is **1660**and in cts is **1779.29**. The clock is ideal in placement step and for so there is no clock network delay but in cts the clock is real and there is a clock network delay. This clock network delay increases the total data required time rather than placement. This difference is more visible than other mismatched delay of std cells. For so, the slack is being met in cts.
**N.B:** Prpagated and propagation is not similer thing.
- The library setup time in placement is -10.23 and in cts is -7.75. All the cells in this timing path is taken from similar library thats why the library set up time occured once both in placement and cts. But it reduced in cts step.


## Compare Timing Paths Between Placement and CTS (For large violation)
 
### Difference between Placement and CTS stage
 
||Placement|||CTS||
---|---|---|---|---|---|
|Delay|Time|Description|Delay|Time|Description|
|0|0|clock clk (rise edge)|0|0|clock clk (rise edge)|
|0|0|clock network delay (ideal)|0|0|clock network delay(propagated)|
|207.5|207.5|input external delay|207.5|207.5|input external delay|
|0|207.5|instr[4] (in)|0|207.5|instr[4] (in)|
|10.86|218.36|input27/Y (BUFx2_ASAP7_75t_R)|10.87|218.37|input27/Y (BUFx2_ASAP7_75t_R)|
|33.06|251.42|_39_/Y (AO22x2_ASAP7_75t_R)|33.07|251.44|_39_/Y (AO22x2_ASAP7_75t_R)|
|20.42|271.84|risc/_085_/Y (INVx1_ASAP7_75t_R)|20.59|272.03|risc/_085_/Y (INVx1_ASAP7_75t_R)|
|77.35|349.19|risc/_086_/Y (OR5x2_ASAP7_75t_R)|77.35|349.37|risc/_086_/Y (OR5x2_ASAP7_75t_R)|
|33.2|382.4|risc/_087_/Y (CKINVDCx20_ASAP7_75t_R)|33.11|382.48|risc/_087_/Y (CKINVDCx20_ASAP7_75t_R)|
|44.44|426.83|risc/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)|45.16|427.64|risc/dp/_09958_/Y (CKINVDCx20_ASAP7_75t_R)|
|131.74|558.57|risc/dp/_09995_/Y (**AND2x2_ASAP7_75t_R**)|159.5|587.14|risc/dp/_09959_/Y (**AND2x6_ASAP7_75t_R**)|
|23.84|582.41|load_slew155/Y (**BUFx16f_ASAP7_75t_R**)|96.47|683.61|risc/dp/_11206_/Y (OA21x2_ASAP7_75t_R)|
|29.73|612.15|wire154/Y (**BUFx16f_ASAP7_75t_R**)|28.54|712.15|risc/dp/_11227_/Y (OA211x2_ASAP7_75t_R)|
|72.47|684.61|max_length153/Y (**BUFx16f_ASAP7_75t_R**)|71.03|783.19|risc/dp/_11228_/Y (AOI221x1_ASAP7_75t_R)|
|37.62|722.23|risc/dp/_10800_/Y (AO221x1_ASAP7_75t_R)|38.86|822.04|risc/dp/_11229_/Y (INVx2_ASAP7_75t_R)|
|27.61|749.84|risc/dp/_10801_/Y (OA211x2_ASAP7_75t_R)|25.87|847.92|risc/dp/_18816_/CON (HAxp5_ASAP7_75t_R)|
|35.54|785.38|risc/dp/_10802_/Y (**AO221x2_ASAP7_75t_R**)|15.38|863.29|risc/dp/_18816_/SN (HAxp5_ASAP7_75t_R)|
|25.24|810.62|risc/dp/_10803_/Y (**NAND2x2_ASAP7_75t_R**)|25.17|888.46|risc/dp/_14423_/Y (OR2x2_ASAP7_75t_R)|
|61.82|872.43|risc/dp/_18830_/SN (HAxp5_ASAP7_75t_R)|36.62|925.08|risc/dp/_14424_/Y (OR4x1_ASAP7_75t_R)|
|27.6|900.03|risc/dp/_14416_/Y (OR2x2_ASAP7_75t_R)|21.98|947.06|risc/dp/_14431_/Y (OA22x2_ASAP7_75t_R)|
|13.28|913.32|risc/dp/_14417_/Y (AO21x1_ASAP7_75t_R)|21.95|969|risc/dp/_14432_/Y (OA31x2_ASAP7_75t_R)|
|12.93|926.25|risc/dp/_14418_/Y (AO21x1_ASAP7_75t_R)|23.3|992.3|risc/dp/_15278_/Y (OA21x2_ASAP7_75t_R)|
|18.95|945.19|risc/dp/_14419_/Y (OA211x2_ASAP7_75t_R)|22.08|1014.38|risc/dp/_15362_/Y (OA21x2_ASAP7_75t_R)|
|25.34|970.53|risc/dp/_14420_/Y (OA31x2_ASAP7_75t_R)|19.62|1034|risc/dp/_15761_/Y (OR2x2_ASAP7_75t_R)|
|26.9|997.43|risc/dp/_14432_/Y (OA31x2_ASAP7_75t_R)|15.76|1049.75|risc/dp/_15762_/Y (AO21x1_ASAP7_75t_R)|
|21.89|1019.32|risc/dp/_15278_/Y (OA21x2_ASAP7_75t_R)|13.33|1063.09|risc/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)|
|20.73|1040.06|risc/dp/_15362_/Y (OA21x2_ASAP7_75t_R)|23.05|1086.14|risc/dp/_18739_/CON (FAx1_ASAP7_75t_R)|
|16.44|1056.5|risc/dp/_15761_/Y (OR2x2_ASAP7_75t_R)|23.73|1109.87|risc/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)|
|14.49|1070.98|risc/dp/_15762_/Y (AO21x1_ASAP7_75t_R)|12.1|1121.97|risc/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)|
|10.66|1081.65|risc/dp/_15763_/Y (NAND2x1_ASAP7_75t_R)|22.33|1144.31|risc/dp/_15438_/Y (AO221x1_ASAP7_75t_R)|
|26.94|1108.58|risc/dp/_18739_/CON (FAx1_ASAP7_75t_R)|21.58|1165.89|risc/dp/_15441_/Y (AO22x1_ASAP7_75t_R)|
|12.94|1121.52|risc/dp/_15436_/Y (XNOR2x1_ASAP7_75t_R)|58.3|1224.19|risc/dp/_15442_/Y (AO31x2_ASAP7_75t_R)|
|11.98|1133.49|risc/dp/_15437_/Y (OAI22x1_ASAP7_75t_R)|203.88|1428.07|dmem/_155_/Y (NOR3x2_ASAP7_75t_R)|
|22.29|1155.79|risc/dp/_15438_/Y (AO221x1_ASAP7_75t_R)|54.62|1482.68|dmem/_256_/Y (AO22x1_ASAP7_75t_R)|
|21.66|1177.45|risc/dp/_15441_/Y (AO22x1_ASAP7_75t_R)|22.12|1504.81|dmem/_257_/Y (AO21x1_ASAP7_75t_R)|
|78.49|1255.93|risc/dp/_15442_/Y (AO31x2_ASAP7_75t_R)|35.42|1540.23|risc/dp/_15964_/Y (AND4x2_ASAP7_75t_R)|
|170.1|1426.04|dmem/_155_/Y (NOR3x2_ASAP7_75t_R)|22.12|1562.35|risc/dp/_16008_/Y (AO21x1_ASAP7_75t_R)|
|91.58|1517.61|dmem/_256_/Y (AO22x1_ASAP7_75t_R)|15.72|1578.07|risc/dp/_16009_/Y (AO21x1_ASAP7_75t_R)|
|22.19|1539.8|dmem/_257_/Y (AO21x1_ASAP7_75t_R)|23.71|1601.78|risc/dp/_16011_/Y (AO221x1_ASAP7_75t_R)|
|35.38|1575.18|risc/dp/_15964_/Y (AND4x2_ASAP7_75t_R)|9.3|1611.08|risc/dp/_16012_/Y (NAND2x1_ASAP7_75t_R)|
|22.12|1597.31|risc/dp/_16008_/Y (AO21x1_ASAP7_75t_R)|22.76|1633.84|risc/dp/_16013_/Y (OA31x2_ASAP7_75t_R)|
|15.72|1613.03|risc/dp/_16009_/Y (AO21x1_ASAP7_75t_R)|51.55|1685.39|risc/dp/_16014_/Y (OAI21x1_ASAP7_75t_R)|
|23.71|1636.74|risc/dp/_16011_/Y (AO221x1_ASAP7_75t_R)|61.91|1747.3|risc/dp/_16016_/Y (OA21x2_ASAP7_75t_R)|
|9.35|1646.09|risc/dp/_16012_/Y (NAND2x1_ASAP7_75t_R)|0.01|1747.3|risc/dp/_18868_/D (DFFLQNx2_ASAP7_75t_R)|
|22.73|1668.82|risc/dp/_16013_/Y (OA31x2_ASAP7_75t_R)||||
|50.67|1719.49|risc/dp/_16014_/Y (OAI21x1_ASAP7_75t_R)||||
|63.21|1782.71|risc/dp/_16016_/Y (OA21x2_ASAP7_75t_R)||||
|0.01|1782.71|risc/dp/_18868_/D (DFFLQNx2_ASAP7_75t_R)||||
|||||||
|       |**1782.71**|**data arrial time**|        |**1747.3**|**data arrial time**|
|1660|1660|clock clk' (fall edge)|1660|1660| clock clk' (fall edge)|
|**0**|**1660**|**clock network delay (ideal)**|**126.96**|**1786.96**|**clock network delay (propagated)**|
|0|1660|clock reconergence pessimism|0|1786.96|clock reconergence pessimism|
|       |1660|risc/dp/_18868_/CLK (DFFLQNx2_ASAP7_75t_R)|        |1786.96|risc/dp/_18868_/CLK (DFFLQNx2_ASAP7_75t_R)|
|-10.2|1649.8|library setup time|-7.68|1779.28| library setup time|
|       |1649.8|data required time|        |1779.28| data required time|
|-------|-------|-------|--------|---------|--------|
|       |1649.8|data required time|        |1779.28|data required time|
|       |-1782.71|data arrial time|        |-1747.3|data arrial time|
|-------|--------|------|--------|---------|--------|
|       |-132.92|slack (VIOLATED)|        |31.98|slack (MET)|


### Result and Reason
- **AND2x2_ASAP7_75t_R** cell used in placement step but in cts step **AND2x6_ASAP7_75t_R** used instead of **AND2x2_ASAP7_75t_R**  cell. Here it is clearly visible that the driving strength is being increased from 2 to 6. For so, the delay increased in cts.
- Buffer chain of **BUFx16f_ASAP7_75t_R** cell is being removed in cts. 
- **AO221x2_ASAP7_75t_R** and **NAND2x2_ASAP7_75t_R** is being removed in cts.
- Data arrival time in placement is **1782.71**. On the otherhand in cts is **1747.3**. Due to the removal of some std cells,buffer and also increasing the driving strength of the cell in cts step, it took less time for the data to arrived.
- Clock network delay in placement is **1660**and in cts is **1786.96**. The clock is ideal in placement step and for so there is no clock network delay but in cts the clock is real and there is a clock network delay. This clock network delay increases the total data required time rather than placement. This difference is more visible than other mismatched delay of std cells. For so, the slack is being met in cts.
**N.B:** Prpagated and propagation is not similer thing.
- The library setup time in placement is **-10.2** and in cts is **-7.68**. All the cells in this timing path is taken from similar library thats why the library set up time occured once both in placement and cts. But it reduced in cts step.


## FAQ

1. What is clock reconergence pessimism (CRP)?
Ans: Go to the [link](https://www.vlsi-expert.com/2011/02/clock-reconvergence-pessimism-crp-basic.html)
