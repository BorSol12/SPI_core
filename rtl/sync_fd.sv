
module sync_fd(
    input clk_i,
    input data_i,

    output logic data_sync_o,
    output logic data_sync_pe_o,
    output logic data_sync_ne_o
    );

reg [2:0] data_reg;

always @(posedge clk_100) begin
    data_reg[0] <= data_i;
    data_reg[1] <= data_reg[0];
    data_reg[2] <= data_reg[1];
end

assign data_sync_o    =  data_reg[2]; 
assign data_sync_pe_o =  data_reg[2] & ~data_reg[1];
assign data_sync_ne_o = ~data_reg[2] &  data_reg[1];

endmodule
