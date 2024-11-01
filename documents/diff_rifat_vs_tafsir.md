# Difference Between Rifat's and Tafsir's Flow

|Project|Author|Start Date|End Date|
|---|---|---|---|
|Flow Difference|A.B.M Tafsirul Islam|25-Mar-2024|25-Mar-2024| 

## Task Details
In Rifat's design there is no violated timing path means all of his timing path is met. On the otherhand the macro placement sequence is not same too. The problem is, we are using same design but there is a huge difference between our report, result, log and gui::show. 

Find out the reason behind the above problem.

## Checker Board

Based on some specification we checked the similarities and mismatching of the design between us.

|Category|Item|Same/Different|
|---|---|---|
|Constraint|Clock Period|Same (1660)|
|Constraint|External Input Delay|Same (207)|
|Cell|Total Cell||
|Cell|Total Std Cell||
|Config File|Design Name|Same|
|Config File|Module Name|Same|
|COnfig File|Verilog FIle|Same|
|Constraint|SDC FIle|Same|
|Library|.lib|Same|
|Library|.lef|Same|
|Library|Tech Lib|Same|
|Library|Std Cell Lib|Same|
|Log File Version|1_1_yosys.log|Diff|
|Macro|Macro Placement Sequence|Diff|
|Macro|Macro Sequence|Diff|
|Macro|Macro Orientation|Same|
|Macro|X, Y Position|Diff|
|Memory Version|fakeram_256 x 32|Diff|
|Pin|Pin Placement|Same|
|Pin|Total Pin||
|Verilog File|1_1_yosys.v (pin connection)|Diff|
|Verilog File|1_1_yosys.v (wire)|Diff|
|Verilog File|1_1_yosys.v (netlist)|Diff|

## Conclusion

The biggest difference between us is the version.Our version of the design is not same.