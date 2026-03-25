vlib work
vmap work work

vlog  ../../hdl/seq_counter.v
vlog  ../../hdl/display.v

vlog  ../hdl/tb.v

vsim -gui work.test_bench 

do wave.do

run -all

