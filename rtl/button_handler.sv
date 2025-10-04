
module button_handler(
    input button_0,
    input button_1,

    input clk_100,
    input s_rst,
    input a_rst,

    output logic next_count_o,
    output logic start_send_o
  );

logic next_count;
logic start_send;

// Logic of next_count_o and next_count_o
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        next_count_o <= 0;
        next_count_o <= 0;
    end
    else if (s_rst) begin
        next_count_o <= 0;
        next_count_o <= 0;
    end
    else begin
        next_count_o <= next_count;
        next_count_o <= start_send;
    end

sync_fd sync_fd_button_0(
    .clk_i(clk_100),
    .data_i(button_0),
    .data_sync_o(next_count),
    .data_sync_pe_o(button_0_sync_pe),
    .data_sync_ne_o(button_0_sync_ne)
    );

sync_fd sync_fd_button_1(
    .clk_i(clk_100),
    .data_i(button_1),
    .data_sync_o(start_send),
    .data_sync_pe_o(button_1_sync_pe),
    .data_sync_ne_o(button_1_sync_ne)
    );

endmodule
