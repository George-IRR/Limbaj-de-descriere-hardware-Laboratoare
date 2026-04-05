onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_bench/dut/clk_i
add wave -noupdate /test_bench/dut/rst_ni
add wave -noupdate -radix unsigned -childformat {{{/test_bench/dut/column_o[2]} -radix unsigned} {{/test_bench/dut/column_o[1]} -radix unsigned} {{/test_bench/dut/column_o[0]} -radix unsigned}} -subitemconfig {{/test_bench/dut/column_o[2]} {-height 15 -radix unsigned} {/test_bench/dut/column_o[1]} {-height 15 -radix unsigned} {/test_bench/dut/column_o[0]} {-height 15 -radix unsigned}} /test_bench/dut/column_o
add wave -noupdate /test_bench/dut/row_o
add wave -noupdate -radix unsigned /test_bench/dut/cnt_o
add wave -noupdate /test_bench/dut/last_led
add wave -noupdate /test_bench/display_dut/clk_i
add wave -noupdate /test_bench/display_dut/rst_ni
add wave -noupdate /test_bench/display_dut/column_i
add wave -noupdate /test_bench/display_dut/row_i
add wave -noupdate /test_bench/display_dut/HEX0
add wave -noupdate /test_bench/display_dut/HEX1
add wave -noupdate /test_bench/display_dut/HEX2
add wave -noupdate /test_bench/display_dut/HEX3
add wave -noupdate /test_bench/display_dut/HEX4
add wave -noupdate /test_bench/display_dut/HEX5
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1268872 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {1248700 ps} {1607964 ps}
