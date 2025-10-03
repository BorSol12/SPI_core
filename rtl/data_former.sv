
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

// module data_former #(
//   parameter int P_DATA_WIDTH = 8
// )(
//   input  logic clk_100,
//   input  logic s_rst,
//   input  logic a_rst,
//   input  logic next_count,
//   input  logic start_send,

//   input  logic ready,
//   output logic valid,
//   output logic [P_DATA_WIDTH-1:0] data
// );

//   logic [P_DATA_WIDTH-1:0] data_cnt;
//   logic start_send_latched;

//   // counter and capture
//   always_ff @(posedge clk_100 or posedge a_rst) begin
//     if (a_rst) begin
//       data_cnt <= '0;
//       valid <= 1'b0;
//       data <= '0;
//       start_send_latched <= 1'b0;
//     end else begin
//       if (s_rst) begin
//         data_cnt <= '0;
//         valid <= 1'b0;
//         data <= '0;
//         start_send_latched <= 1'b0;
//       end else begin
//         // increment counter on next_count rising pulse
//         if (next_count) begin
//           data_cnt <= data_cnt + 1;
//         end

//         // start_send - we latch it for a cycle so we can produce valid
//         if (start_send) begin
//           start_send_latched <= 1'b1;
//         end

//         // when latched, we produce valid and data; keep valid until accepted (ready)
//         if (start_send_latched && !valid) begin
//           // offer current counter value
//           data <= data_cnt;
//           valid <= 1'b1;
//         end else if (valid && ready) begin
//           // handshake accepted
//           valid <= 1'b0;
//           start_send_latched <= 1'b0;
//         end
//       end
//     end
//   end

// endmodule