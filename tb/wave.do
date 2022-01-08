onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_fifo/wr_clk
add wave -noupdate /tb_fifo/wr_rst
add wave -noupdate -color Yellow /tb_fifo/rd_clk
add wave -noupdate -color Yellow /tb_fifo/rd_rst
add wave -noupdate -expand -group ITF /tb_fifo/itf/push
add wave -noupdate -expand -group ITF -color Coral /tb_fifo/itf/full
add wave -noupdate -expand -group ITF -color {Medium Orchid} -radix hexadecimal /tb_fifo/itf/data_in
add wave -noupdate -expand -group ITF /tb_fifo/itf/pop
add wave -noupdate -expand -group ITF -color Coral /tb_fifo/itf/empty
add wave -noupdate -expand -group ITF -color {Medium Orchid} -radix hexadecimal /tb_fifo/itf/data_out
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {594 ps} 0}
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
configure wave -timelineunits ps
update
WaveRestoreZoom {0 ps} {8 ps}
