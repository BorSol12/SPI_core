
module button_handler(
    input button_0,
    input button_1,

    input clk_100,
    input s_rst,
    input a_rst,

    output logic next_count,
    output logic start_send
  );

logic       button_0_prev;
logic       button_1_prev;

logic [2:0] button_0_sync;
logic [2:0] button_1_sync;


// Synchronization chain for button_0
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst)
        button_0_sync <= '0;
    else if (s_rst)
        button_0_sync <= '0;
    else
        button_0_sync <= {button_0_sync[1:0], button_0};


// Synchronization chain for button_1
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst)
        button_1_sync <= '0;
    else if (s_rst)
        button_1_sync <= '0;
    else
        button_1_sync <= {button_1_sync[1:0], button_1};


// Logic of previous button 0 and button 1 value
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        button_0_prev <= '0;
        button_1_prev <= '0;
    end
    else if (s_rst) begin
        button_0_prev <= '0;
        button_1_prev <= '0;
    end
    else begin
        button_0_prev <= (button_0_sync[2]);
        button_1_prev <= (button_1_sync[2]);
    end


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
        next_count <= (button_0_sync[2] & ~button_0_prev);
        start_send <= (button_1_sync[2] & ~button_1_prev);
    end

endmodule
