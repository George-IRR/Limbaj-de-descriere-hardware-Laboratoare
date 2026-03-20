onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /test_bench/dut/clk_i
add wave -noupdate /test_bench/dut/rst_ni
add wave -noupdate -divider Params
add wave -noupdate -radix unsigned /test_bench/dut/LED_Lenght
add wave -noupdate -divider Counter
add wave -noupdate -radix unsigned -radixshowbase 0 /test_bench/dut/cnt_o
add wave -noupdate -divider Output
add wave -noupdate -radix unsigned /test_bench/dut/led_o
add wave -noupdate /test_bench/dut/last_led
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {92962 ps} 0}
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
WaveRestoreZoom {0 ps} {571604 ps}
