onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /tb/clk_100
add wave -noupdate -expand -group tb /tb/s_rst
add wave -noupdate -expand -group tb /tb/a_rst
add wave -noupdate -expand -group tb /tb/button_0
add wave -noupdate -expand -group tb /tb/button_1
add wave -noupdate -expand -group tb /tb/SCK_HP
add wave -noupdate -expand -group tb /tb/SCK_LP
add wave -noupdate -expand -group tb /tb/SCK_HN
add wave -noupdate -expand -group tb /tb/SCK_LN
add wave -noupdate -expand -group tb /tb/CS
add wave -noupdate -expand -group tb /tb/MOSI
add wave -noupdate -expand -group top /tb/dut/clk_100
add wave -noupdate -expand -group top /tb/dut/s_rst
add wave -noupdate -expand -group top /tb/dut/a_rst
add wave -noupdate -expand -group top /tb/dut/P_DATA_WIDTH
add wave -noupdate -expand -group top /tb/dut/P_CLK_DIV
add wave -noupdate -expand -group top /tb/dut/P_CS_POLAR
add wave -noupdate -expand -group top /tb/dut/button_0
add wave -noupdate -expand -group top /tb/dut/button_1
add wave -noupdate -expand -group top /tb/dut/SCK_HP
add wave -noupdate -expand -group top /tb/dut/SCK_LP
add wave -noupdate -expand -group top /tb/dut/SCK_HN
add wave -noupdate -expand -group top /tb/dut/SCK_LN
add wave -noupdate -expand -group top /tb/dut/CS
add wave -noupdate -expand -group top /tb/dut/MOSI
add wave -noupdate -expand -group top /tb/dut/next_count_wire
add wave -noupdate -expand -group top /tb/dut/start_send_wire
add wave -noupdate -expand -group top /tb/dut/ready_wire
add wave -noupdate -expand -group top /tb/dut/valid_wire
add wave -noupdate -expand -group top /tb/dut/data_wire
add wave -noupdate -expand -group handler /tb/dut/handler/clk_100
add wave -noupdate -expand -group handler /tb/dut/handler/s_rst
add wave -noupdate -expand -group handler /tb/dut/handler/a_rst
add wave -noupdate -expand -group handler /tb/dut/handler/button_0
add wave -noupdate -expand -group handler /tb/dut/handler/button_1
add wave -noupdate -expand -group handler /tb/dut/handler/next_count
add wave -noupdate -expand -group handler /tb/dut/handler/start_send
add wave -noupdate -expand -group handler /tb/dut/handler/button_0_prev
add wave -noupdate -expand -group handler /tb/dut/handler/button_1_prev
add wave -noupdate -expand -group handler /tb/dut/handler/button_0_sync
add wave -noupdate -expand -group handler /tb/dut/handler/button_1_sync
add wave -noupdate -expand -group former /tb/dut/former/clk_100
add wave -noupdate -expand -group former /tb/dut/former/s_rst
add wave -noupdate -expand -group former /tb/dut/former/a_rst
add wave -noupdate -expand -group former /tb/dut/former/P_DATA_WIDTH
add wave -noupdate -expand -group former /tb/dut/former/next_count
add wave -noupdate -expand -group former /tb/dut/former/start_send
add wave -noupdate -expand -group former /tb/dut/former/ready
add wave -noupdate -expand -group former /tb/dut/former/valid
add wave -noupdate -expand -group former /tb/dut/former/data
add wave -noupdate -expand -group former /tb/dut/former/data_cnt
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/clk_100
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/s_rst
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/a_rst
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/P_DATA_WIDTH
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/P_CLK_DIV
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/P_CS_POLAR
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/valid
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/data
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/ready
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/SCK_HP
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/SCK_LP
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/SCK_HN
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/SCK_LN
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/CS
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/MOSI
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/sck
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/shift_en
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/bit_cnt
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/div_cnt
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/shift_reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {19962 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 214
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ps} {143922 ps}
