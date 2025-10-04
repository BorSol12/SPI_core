
module button_handler(
    input button_0,
    input button_1,

    input clk_100,
    input s_rst,
    input a_rst,

    output logic next_count,
    output logic start_send
  );

// Logic of next_count and start_send
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        next_count <= 0;
        start_send <= 0;
    end
    else if (s_rst) begin
        next_count <= 0;
        start_send <= 0;
    end
    else begin
        next_count <= button_0;
        start_send <= button_1;
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
