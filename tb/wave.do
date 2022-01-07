onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fifo/clk
add wave -noupdate /tb_fifo/rst
add wave -noupdate -expand -group ITF /tb_fifo/itf/push
add wave -noupdate -expand -group ITF /tb_fifo/itf/full
add wave -noupdate -expand -group ITF -radix hexadecimal /tb_fifo/itf/data_in
add wave -noupdate -expand -group ITF /tb_fifo/itf/pop
add wave -noupdate -expand -group ITF /tb_fifo/itf/empty
add wave -noupdate -expand -group ITF /tb_fifo/itf/data_out
add wave -noupdate -expand -group DUT /tb_fifo/dut/wrclk
add wave -noupdate -expand -group DUT /tb_fifo/dut/wr_rst
add wave -noupdate -expand -group DUT /tb_fifo/dut/rdclk
add wave -noupdate -expand -group DUT /tb_fifo/dut/rd_rst
add wave -noupdate -expand -group DUT -radix hexadecimal /tb_fifo/dut/data_in
add wave -noupdate -expand -group DUT /tb_fifo/dut/push
add wave -noupdate -expand -group DUT /tb_fifo/dut/full
add wave -noupdate -expand -group DUT /tb_fifo/dut/data_out
add wave -noupdate -expand -group DUT /tb_fifo/dut/pop
add wave -noupdate -expand -group DUT /tb_fifo/dut/empty
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {8 ps}
