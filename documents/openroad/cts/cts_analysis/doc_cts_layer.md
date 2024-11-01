# CTS Layer Checking

## Table of Content

- [Task Log](#task-log)
- [Task Details](#task-details)
- [Task](#task)
- [Task Executiion](#task-execution)
- [Result](#result)
- [Conclusion](#conclusion)

## Task Log

|Project|Author|Start Date|End Date|
|---|---|---|---|
|CTS|A.B.M Tafsirul Islam|18-Apr-2024|18-Apr-2024| 


## Task Details

The purpous of CTS is to reduce the skew and latency/delay of the clock. CTS is the technique of balancing the skew and delay of all the clock inputs by inserting buffer or inverter in the clock network. 

While builing the clock network it need to route the clock network with a specific metal layer.

## Task

The task is to find out the metal layer that is used to route the clock tree network.

## Task Execution

### Steps:

1. Go to the location: `/home/abm-tafsir/OpenROAD-flow-scripts/tools/OpenROAD/src/cts/test`

2. Open the [file](post_cts_opt.tcl)       : `post_cts_opt.tcl`



## Result

The following lines would be seen in the tcl `post_cts_opt.tcl` file.

```
set_wire_rc -signal -layer metal3
set_wire_rc -clock -layer metal5
```
So it can be stated that for clock route `metal 5` has been used.

## Conclusion

From the above observation we found that `metal 5` has been used for clock network routing
