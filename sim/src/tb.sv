`timescale 1ns/1ps

`include "../../rtl/config_pkg.sv"
import config_pkg::*;

module tb();
    logic button_0, button_1;
    logic clk_100;
    logic s_rst, a_rst;
    logic SCK_HP, SCK_LP, SCK_HN, SCK_LN, CS;
    logic MOSI;

    // instantiate DUT
    top dut (
        .button_0(button_0),
        .button_1(button_1),
        .clk_100(clk_100),
        .s_rst(s_rst),
        .a_rst(a_rst),

        .SCK_HP(SCK_HP),
        .SCK_LP(SCK_LP),
        .SCK_HN(SCK_HN),
        .SCK_LN(SCK_LN),
        .CS(CS),
        .MOSI(MOSI)
        );

    // clock
    initial begin
        clk_100 = 0;
        forever #5 clk_100 = ~clk_100; // 100MHz -> period 10ns
    end

    initial begin
    // initial resets
    a_rst = 1;
    s_rst = 1;
    button_0 = 0;
    button_1 = 0;
    #20;
    a_rst = 0;
    #20;
    s_rst = 0;

    // increment data_cnt once (simulate button_0 press)
    #50;
    button_0 = 1;
    #10;
    button_0 = 0;

    // wait and request send (button_1)
    #200;
    button_1 = 1;
    #10;
    button_1 = 0;

    // wait for completion
    #2000;

    $stop;
    end

    // dump
    initial begin
        $dumpfile("spi_core_tb.vcd");
        $dumpvars(0, tb);
    end

endmodule
