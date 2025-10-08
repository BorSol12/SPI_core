onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group tb /tb/clk_100
add wave -noupdate -expand -group tb /tb/s_rst
add wave -noupdate -expand -group tb /tb/a_rst
add wave -noupdate -expand -group tb /tb/button_0
add wave -noupdate -expand -group tb /tb/button_1
add wave -noupdate -expand -group tb -color Magenta /tb/SCK_LP
add wave -noupdate -expand -group tb -color Magenta /tb/SCK_LN
add wave -noupdate -expand -group tb -color Magenta /tb/SCK_HP
add wave -noupdate -expand -group tb -color Magenta /tb/SCK_HN
add wave -noupdate -expand -group tb /tb/CS
add wave -noupdate -expand -group tb /tb/MOSI
add wave -noupdate -expand -group Top /tb/dut/clk_100
add wave -noupdate -expand -group Top /tb/dut/s_rst
add wave -noupdate -expand -group Top /tb/dut/a_rst
add wave -noupdate -expand -group Top /tb/dut/button_0
add wave -noupdate -expand -group Top /tb/dut/button_1
add wave -noupdate -expand -group Top /tb/dut/SCK_HP
add wave -noupdate -expand -group Top /tb/dut/SCK_LP
add wave -noupdate -expand -group Top /tb/dut/SCK_HN
add wave -noupdate -expand -group Top /tb/dut/SCK_LN
add wave -noupdate -expand -group Top /tb/dut/CS
add wave -noupdate -expand -group Top /tb/dut/MOSI
add wave -noupdate -expand -group Top /tb/dut/next_count_wire
add wave -noupdate -expand -group Top /tb/dut/start_send_wire
add wave -noupdate -expand -group Top /tb/dut/ready_wire
add wave -noupdate -expand -group Top /tb/dut/valid_wire
add wave -noupdate -expand -group Top /tb/dut/sck_wire
add wave -noupdate -expand -group Top /tb/dut/data_wire
add wave -noupdate -expand -group button_handler /tb/dut/handler/clk_100
add wave -noupdate -expand -group button_handler /tb/dut/handler/s_rst
add wave -noupdate -expand -group button_handler /tb/dut/handler/a_rst
add wave -noupdate -expand -group button_handler /tb/dut/handler/button_0
add wave -noupdate -expand -group button_handler /tb/dut/handler/button_1
add wave -noupdate -expand -group button_handler /tb/dut/handler/start_send_o
add wave -noupdate -expand -group button_handler /tb/dut/handler/start_send
add wave -noupdate -expand -group button_handler /tb/dut/handler/next_count_o
add wave -noupdate -expand -group button_handler /tb/dut/handler/next_count
add wave -noupdate -expand -group sync_fd_button_0 /tb/dut/handler/sync_fd_button_0/clk_i
add wave -noupdate -expand -group sync_fd_button_0 /tb/dut/handler/sync_fd_button_0/data_i
add wave -noupdate -expand -group sync_fd_button_0 /tb/dut/handler/sync_fd_button_0/data_sync_o
add wave -noupdate -expand -group sync_fd_button_0 /tb/dut/handler/sync_fd_button_0/data_sync_pe_o
add wave -noupdate -expand -group sync_fd_button_0 /tb/dut/handler/sync_fd_button_0/data_sync_ne_o
add wave -noupdate -expand -group sync_fd_button_0 /tb/dut/handler/sync_fd_button_0/data_reg
add wave -noupdate -expand -group sync_fd_button_1 /tb/dut/handler/sync_fd_button_1/clk_i
add wave -noupdate -expand -group sync_fd_button_1 /tb/dut/handler/sync_fd_button_1/data_i
add wave -noupdate -expand -group sync_fd_button_1 /tb/dut/handler/sync_fd_button_1/data_sync_o
add wave -noupdate -expand -group sync_fd_button_1 /tb/dut/handler/sync_fd_button_1/data_sync_pe_o
add wave -noupdate -expand -group sync_fd_button_1 /tb/dut/handler/sync_fd_button_1/data_sync_ne_o
add wave -noupdate -expand -group sync_fd_button_1 /tb/dut/handler/sync_fd_button_1/data_reg
add wave -noupdate -expand -group data_former /tb/dut/former/clk_100
add wave -noupdate -expand -group data_former /tb/dut/former/s_rst
add wave -noupdate -expand -group data_former /tb/dut/former/a_rst
add wave -noupdate -expand -group data_former /tb/dut/former/next_count
add wave -noupdate -expand -group data_former /tb/dut/former/start_send
add wave -noupdate -expand -group data_former /tb/dut/former/ready
add wave -noupdate -expand -group data_former /tb/dut/former/valid
add wave -noupdate -expand -group data_former /tb/dut/former/data
add wave -noupdate -expand -group data_former /tb/dut/former/data_cnt
add wave -noupdate -expand -group divider /tb/dut/clk_divider/clk_100
add wave -noupdate -expand -group divider /tb/dut/clk_divider/s_rst
add wave -noupdate -expand -group divider /tb/dut/clk_divider/a_rst
add wave -noupdate -expand -group divider /tb/dut/clk_divider/sck_ready
add wave -noupdate -expand -group divider /tb/dut/clk_divider/sck_out
add wave -noupdate -expand -group divider /tb/dut/clk_divider/clk_cnt
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/clk_100
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/s_rst
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/a_rst
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/sck_in
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/sck_in_d
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/sck_en
add wave -noupdate -expand -group transmitter -radix decimal /tb/dut/transmitter/bit_cnt
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/CS
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/valid
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/ready
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/data_in
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/MOSI
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/shift_reg
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/state
add wave -noupdate -expand -group transmitter /tb/dut/transmitter/next_state
add wave -noupdate -color Cyan /tb/dut/transmitter/SCK_LP
add wave -noupdate -color Cyan /tb/dut/transmitter/SCK_HN
add wave -noupdate -color Cyan /tb/dut/transmitter/SCK_HP
add wave -noupdate -color Cyan /tb/dut/transmitter/SCK_LN
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1045000 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 325
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
WaveRestoreZoom {0 ps} {3675372 ps}
