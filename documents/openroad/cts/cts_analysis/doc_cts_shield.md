# Shield Checking

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

To ensure optimal signal integrity and reduce the EM and crosstalk effect shilding is being used. The goal is to protect the victim net and reduce coupling capacitance.[1]

## Task

The task is to find out whether there used shielding or not.

## Task Execution

### Steps:

1. Go to the location: `OpenROAD-flow-scripts/tools/OpenROAD/src/odb/test/gcd_pdn_def_access.tcl` 

2. The [file](gcd_pdn_def_access.tcl) contains a command named `getShield`.

## Result
From the above observation it can be stated that, there is a command that is dedicated for shielding. The following line found in the [file](gcd_pdn_def_access.tcl)

```
check "swire shield" {$swire getShield} NULL
```
As it is `NULL` so there used no shield. 

## Conclusion

From the above analysis we can say that there is a dedicated command for shiled named `getShield` but there used no shield as it set `NULL`


## Source

[1]: https://siliconvlsi.com/types-of-shielding-in-vlsi/