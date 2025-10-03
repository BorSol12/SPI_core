vlib work
vmap work work

vlog -sv rtl/config_pkg.sv
vlog -sv rtl/top.sv
vlog -sv rtl/button_handler.sv
vlog -sv rtl/data_former.sv
vlog -sv rtl/transmitter.sv

vlog -sv sim/src/*.sv

vsim -gui -voptargs=+acc work.tb

add wave -r sim:/tb/*
run -all
