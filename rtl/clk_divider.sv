`include "config_pkg.sv"
import config_pkg::P_CLK_DIV;

module clk_divider(
    input clk_100,
    input s_rst,
    input a_rst,

    output logic sck_out
    );

logic [$clog2(P_CLK_DIV)-1:0] clk_cnt;

always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        sck_out <=  0;
        clk_cnt <= '0;
    end
    else if (s_rst) begin
        sck_out <=  0;
        clk_cnt <= '0;
    end
    else begin
        if (clk_cnt == P_CLK_DIV/2 - 1) begin
            sck_out <=  1;
            clk_cnt <= '0;
        end
        else begin
            sck_out <= 0;
            clk_cnt <= clk_cnt + 1;
        end
    end

endmodule
