`include "config_pkg.sv"
import config_pkg::*;

module data_former(
    input clk_100,
    input s_rst,
    input a_rst,
    input next_count,
    input start_send,

    input        ready,
    output logic valid,
    output logic [P_DATA_WIDTH-1:0] data
    );

logic [P_DATA_WIDTH-1:0] data_cnt;

// Logic of next_count and start_send
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        data_cnt <= '0;
        data     <= '0;
    end
    else if (s_rst) begin
        data_cnt <= '0;
        data     <= '0;
    end
    else begin
        if      (next_count)     data_cnt <= data_cnt + 1;
        else if (valid && ready) data     <= data_cnt;
    end

// Logic of valid signal
always_ff @(posedge clk_100 or posedge a_rst)
    if      (a_rst) valid = 0;
    else if (s_rst) valid = 0;
    else            valid = (start_send) ? 1 : 0;

endmodule
