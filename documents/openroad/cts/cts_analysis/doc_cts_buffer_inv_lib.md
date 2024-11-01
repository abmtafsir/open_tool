# Check Buffer Used in CTS and Its Library

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

The buffer that used in CTS is not similar as normal buffer used in other step. CTS buffer are special types of buffer.

## Task

- Find out which buffer from the library is being used in CTS.
- Driving strength of the buffer
- Find out the library locaion of the reference buffer and inverter.

## Task Execution

### Steps:

1. Go to the location: `~/OpenROAD-flow-scripts/flow/platforms/asap7/config.mk` 

2. The [file](config.mk) the CTS buffer

## Result
- From the above observation it can be stated that, the bufer that is used in CTS is as below:

    ```
    104 # TritonCTS options
    105 export CTS_BUF_CELL            ?= BUFx4_ASAP7_75t_R
    106 
    107 export CTS_BUF_DISTANCE        ?= 60

    ```

- The driving strength of the buffer is `4`
- Library location of reference buf/inv: `~/OpenROAD-flow-scripts/flow/objects/asap7/riscv32i/base/lib/asap7sc7p5t_INVBUF_RVT_FF_nldm_220122.lib ` and `~/OpenROAD-flow-scripts/flow/objects/asap7/riscv32i/base/lib/merged.lib`

## Conclusion

From the above analysis we can say that there used `BUFx4_ASAP7_75t_R` as CTS buffer. The library that stored the buffer and inverter is mentioned above


