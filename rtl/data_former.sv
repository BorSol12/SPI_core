
module data_former #(
    parameter P_DATA_WIDTH = 8
    )
    (
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

always_comb
    if      (a_rst) valid = 0;
    else if (s_rst) valid = 0;
    else            valid = (start_send) ? 1 : 0;

endmodule
