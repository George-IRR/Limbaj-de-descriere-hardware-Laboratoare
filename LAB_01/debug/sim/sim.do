vlib work
vmap work work

vlog  ../../hdl/counter_preset.v
vlog  ../hdl/ck_rst_tb.v
vlog  ../hdl/counter_preset_tb.v
vlog  ../hdl/counter_preset_test.v

vsim -gui work.counter_preset_test 

do wave.do

run -all

