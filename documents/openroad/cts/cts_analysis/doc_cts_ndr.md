# NDR Checking

## Table of Content

- [Task Log](#task-log)
- [Task Details](#task-details)
- [Task](#task)
- [Task Executiion](#task-execution)
- [Result](#result)
- [Conclusion](#conclusion)
- [Source](#source)

## Task Log

|Project|Author|Start Date|End Date|
|---|---|---|---|
|CTS|A.B.M Tafsirul Islam|18-Apr-2024|18-Apr-2024| 


## Task Details

NDR stands for NON Default Routing. These are some default rules that has been followed to resolve the IREM and crosstalk issues in terms of metal routing. Those default rule includes min width, min spacing. These default rules comes from the foundry (it can be find in TECH LEF).   

Most commonly using NDR rules are:

- 2s2w: Double Spacing, Double Width
- 3s3w: Triple Spacing, Triple Width
- 2s1w: Double Spacing, Single Width

**WHY CLOCK NETS NEED NDR RULES?**

**ANS:** Clock nets are always active nets means while the power of the chip is turned on the clock net takes the power to switch its state (high to low and vice-versa) until the power turned off with very high frequency. Due to this types of power hunger reason there is a high possibility to occured EM (Electro Migration) and crosstalk in clock nets. As the entire chip timing depends on the clock signal so it should not effect by the crosstalk or noise.[1] So,

- To avoid EM: need extra width
- To avoid crosstalk: need extra spacing  


## Task

The task is to find out if there is any ndr appiled or not?

## Task Execution

### Steps:

1. Go to the location: `/home/abm-tafsir/OpenROAD-flow-scripts/tools/OpenROAD/src/cts/test`

2. Open the [file](simple_test.tcl)       : `simple_test.tcl`



## Result

In the following file named `simple_test.tcl` there is no ndr rules present in this current version that we are using. But the latest version carries the ndr rules. The link of the latest version is [here](https://github.com/The-OpenROAD-Project/OpenROAD/blob/master/src/cts/test/simple_test.tcl)

The following lines would be seen in the tcl `post_cts_opt.tcl` file.

```
source "helpers.tcl"
read_lef Nangate45/Nangate45.lef
read_liberty Nangate45/Nangate45_typ.lib
read_def "16sinks.def"

create_clock -period 5 clk

set_wire_rc -clock -layer metal3

clock_tree_synthesis -root_buf CLKBUF_X3 \
                     -buf_list CLKBUF_X3 \
                     -wire_unit 20 \
                     -obstruction_aware \
                     -apply_ndr    

set def_file [make_result_file simple_test_out.def]
write_def $def_file
diff_files simple_test_out.defok $def_file
```
We can see in above that there applied the ndr.

**NOTE:** There is a command that is related to NDR - `getNonDefaultRules` in the following path `OpenROAD-flow-scripts/tools/OpenROAD/src/odb/test/gcd_pdn_def_access.tcl` 

The file is attatched [here](gcd_pdn_def_access.tcl)

## Conclusion

From the avobe observation we can stated that there is no ndr in our current vesion but there present ndr in the latest version.

## Source

[1]: https://vlsitalks.com/physical-design/cts/