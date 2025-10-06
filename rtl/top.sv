`include "config_pkg.sv"
import config_pkg::*;

module top(
    input button_0,
    input button_1,

    input clk_100,
    input s_rst,
    input a_rst,

    output logic SCK_HP,
    output logic SCK_LP,
    output logic SCK_HN,
    output logic SCK_LN,
    output logic CS,
    output logic MOSI
  );

  logic next_count_wire;
  logic start_send_wire;
  logic ready_wire;
  logic valid_wire;
  logic sck_wire;
  logic [P_DATA_WIDTH-1:0] data_wire;

  button_handler handler(
    .clk_100(clk_100),
    .s_rst(s_rst),
    .a_rst(a_rst),
    .button_0(button_0),
    .button_1(button_1),

    .next_count_o(next_count_wire),
    .start_send_o(start_send_wire)
    );

  data_former former(
    .clk_100(clk_100),
    .s_rst(s_rst),
    .a_rst(a_rst),
    .next_count(next_count_wire),
    .start_send(start_send_wire),

    .ready(ready_wire),
    .valid(valid_wire),
    .data(data_wire)
    );

  clk_divider clk_divider(
    .clk_100(clk_100),
    .s_rst(s_rst),
    .a_rst(a_rst),

    .sck_ready(ready_wire),
    .sck_out(sck_wire)
    );

  transmitter transmitter(
    .clk_100(clk_100),
    .s_rst(s_rst),
    .a_rst(a_rst),

    .sck_in(sck_wire),
    .ready(ready_wire),
    .valid(valid_wire),
    .data_in(data_wire),

    .SCK_HP(SCK_HP),
    .SCK_LP(SCK_LP),
    .SCK_HN(SCK_HN),
    .SCK_LN(SCK_LN),
    .CS(CS),
    .MOSI(MOSI)
    );

endmodule
