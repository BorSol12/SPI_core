`include "config_pkg.sv"
import config_pkg::*;

module transmitter(
    input clk_100,
    input s_rst,
    input a_rst,

    input                    valid,
    input [P_DATA_WIDTH-1:0] data,
    output logic             ready,

    output logic SCK_HP,
    output logic SCK_LP,
    output logic SCK_HN,
    output logic SCK_LN,
    output logic CS,
    output logic [P_DATA_WIDTH-1:0] MOSI
    );

logic                            sck;
logic                            shift_en;
logic [$clog2(P_DATA_WIDTH)-1:0] bit_cnt;
logic [$clog2(P_CLK_DIV)-1:0]    div_cnt;
logic [P_DATA_WIDTH-1:0]         shift_reg;

always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        shift_en  <=  0;
        ready     <=  1;
        shift_reg <= '0;
        sck       <= '0;
        bit_cnt   <= '0;
        div_cnt   <= '0;
        MOSI      <= '0;
        CS        <= (P_CS_POLAR ? 0 : 1); // CS в "неактивном" состоянии
    end
    else if (s_rst) begin
        shift_en  <=  0;
        ready     <=  1;
        shift_reg <= '0;
        sck       <= '0;
        bit_cnt   <= '0;
        div_cnt   <= '0;
        MOSI      <= '0;
        CS        <= (P_CS_POLAR ? 0 : 1); // CS в "неактивном" состоянии
    end
    else begin
        if (ready && valid) begin
            shift_reg <= data;
            shift_en  <= 1;
            bit_cnt   <= P_DATA_WIDTH - 1;
            ready     <= 0;
            MOSI      <= data[P_DATA_WIDTH-1];
            CS        <= (P_CS_POLAR ? 1 : 0); // CS в "неактивном" состоянии
        end
        else if (shift_en) begin
            if (div_cnt == (P_CLK_DIV/2 - 1)) begin

                div_cnt <= 0;
                sck     <= !sck;

                if (sck == 1'b1) begin
                    if (bit_cnt > 0) begin
                        MOSI    <= {MOSI[P_DATA_WIDTH-2:0], shift_reg};
                        bit_cnt <= bit_cnt - 1;
                    end
                    else begin
                        shift_en <= 0;
                        ready    <= 1;
                        CS       <= (P_CS_POLAR ? 0 : 1);   // деактивируем CS
                    end
                end
            end

            else div_cnt <= div_cnt + 1;
        end
    end


always_comb
    if (!shift_en) begin    // IDLE
        SCK_HP = 1;
        SCK_HN = 1;
        SCK_LP = 0;
        SCK_LN = 0;
    end
    else begin
        SCK_HP = sck ? 1 : 0;
        SCK_LP = sck ? 1 : 0;
        SCK_HN = sck ? 0 : 1;
        SCK_LN = sck ? 0 : 1;
    end

endmodule



// typedef enum logic [1:0] {
//     IDLE, SHIFT
// } statetype;

// statetype state, nextstate;

// always @(posedge clk_100 or posedge a_rst)
//     if (a_rst)      state <= IDLE;
//     else if (s_rst) state <= IDLE;
//     else            state <= next_state;

// always_comb
//     case(state)
//         IDLE : if (ready && valid)   next_state <= SHIFT;
        
//         SHIFT : 
//     endcase

// always @(posedge clk_100 or posedge a_rst)
//     if (a_rst) begin
//         shift_en  <= 0;
//         ready     <= 1;
//         shift_reg <= '0;
//     end
//     else if (s_rst) begin
//         shift_en <= 0;
//         ready    <= 1;
//         shift_reg <= '0;
//     end
//     else begin
//         case(next_state)
//         if (ready && valid) begin
//             shift_reg <= data;
//             ready     <= 0;
//     end
