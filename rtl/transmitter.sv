`include "config_pkg.sv"
import config_pkg::*;

module transmitter(
    input clk_100,
    input s_rst,
    input a_rst,

    input                    sck_in,
    input                    valid,
    input [P_DATA_WIDTH-1:0] data_in,
    output logic             ready,

    output logic SCK_HP,
    output logic SCK_LP,
    output logic SCK_HN,
    output logic SCK_LN,
    output logic CS,
    output logic MOSI
    );

logic [$clog2(P_DATA_WIDTH):0] bit_cnt;
logic [P_DATA_WIDTH-1:0]       shift_reg;

// Состояния конечного автомата
typedef enum logic [1:0] {
    IDLE, DATA_START, DATA_ASSIGN, SHIFT
} statetype;

statetype state, next_state;

// Логика переключения конечного автомата
always @(posedge clk_100 or posedge a_rst)
    if      (a_rst) state <= IDLE;
    else if (s_rst) state <= IDLE;
    else            state <= next_state;

always_comb
    case(state)
        IDLE        : if (ready && valid) next_state <= DATA_START;
                      else                next_state <= IDLE;
        
        DATA_START  :                     next_state <= DATA_ASSIGN;

        DATA_ASSIGN : if (~CS)            next_state <= SHIFT;
                      else                next_state <= DATA_ASSIGN;

        SHIFT       : if (CS)             next_state <= IDLE;
                      else                next_state <= SHIFT;
    endcase

// Основная логика передачи
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        ready     <=  1;
        shift_reg <= '0;
        bit_cnt   <= '0;
        MOSI      <= '0;
        CS        <=  1; // CS в неактивном состоянии
    end
    else if (s_rst) begin
        ready     <=  1;
        shift_reg <= '0;
        bit_cnt   <= '0;
        MOSI      <= '0;
        CS        <=  1; // CS в неактивном состоянии
    end
    else begin
        case(next_state)
            DATA_ASSIGN : begin
                CS        <= 0;         // CS в активном состоянии
                shift_reg <= data_in;
                ready     <= 0;
            end

            SHIFT : begin
                if (sck_in && !ready) begin
                    if (bit_cnt < P_DATA_WIDTH) begin
                        shift_reg  <= {shift_reg[P_DATA_WIDTH-2:0], 1'b0};
                        MOSI       <= shift_reg[P_DATA_WIDTH-1];
                        bit_cnt    <= bit_cnt + 1;
                    end
                    else begin
                        bit_cnt <= '0;
                        ready   <=  1;
                        CS      <=  1;      // CS в неактивном состоянии
                    end
                end
            end
        endcase
    end


// Logic of SCK_LP and SCK_HP
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        SCK_LP = 0;   // Mode 0: CPOL=0, CPHA=0
        SCK_HP = 1;   // Mode 2: CPOL=1, CPHA=0
    end
    else if (s_rst) begin
        SCK_LP <=  sck_in;
        SCK_HP <= !sck_in;
    end
    else begin
        SCK_LP <=  sck_in;
        SCK_HP <= !sck_in;
    end


// Logic of SCK_LN and SCK_HN
always_ff @(negedge clk_100 or posedge a_rst)
    if (a_rst) begin
        SCK_LN = 0;   // Mode 1: CPOL=0, CPHA=1
        SCK_HN = 1;   // Mode 3: CPOL=1, CPHA=1
    end
    else if (s_rst) begin
        SCK_LN <= !sck_in;
        SCK_HN <=  sck_in;
    end
    else begin
        SCK_LN <= !sck_in;
        SCK_HN <=  sck_in;
    end


endmodule


// always_ff @(posedge clk_100 or posedge a_rst)
//     if (a_rst) begin
//         ready     <=  1;
//         shift_reg <= '1;
//         bit_cnt   <= '0;
//         MOSI      <= '0;
//         CS        <=  1; // CS в неактивном состоянии
//     end
//     else if (s_rst) begin
//         ready     <=  1;
//         shift_reg <= '1;
//         bit_cnt   <= '0;
//         MOSI      <= '0;
//         CS        <=  1; // CS в неактивном состоянии
//     end
//     else begin
//         if (valid && ready) begin
//             CS        <= 0;         // CS в активном состоянии
//             shift_reg <= data_in;
//             ready     <= 0;
//         end
//         else if (sck_in && !ready) begin
//             if (bit_cnt < P_DATA_WIDTH) begin
//                 MOSI    <= {shift_reg[P_DATA_WIDTH-1], 1'b0};
//                 bit_cnt <= bit_cnt + 1;
//             end
//             else begin
//                 bit_cnt <= '0;
//                 ready   <=  1;
//                 CS      <=  1;      // CS в неактивном состоянии
//             end
//         end
//     end



// SCK_LP = sck_in ? 1 : 0;   // Mode 0: CPOL=0, CPHA=0
// SCK_LN = sck_in ? 0 : 1;   // Mode 1: CPOL=0, CPHA=1
// SCK_HP = sck_in ? 1 : 0;   // Mode 2: CPOL=1, CPHA=0
// SCK_HN = sck_in ? 0 : 1;   // Mode 3: CPOL=1, CPHA=1

    // else begin
    //     if (ready && valid) begin
    //         shift_reg <= data;
    //         shift_en  <= 1;
    //         bit_cnt   <= P_DATA_WIDTH - 1;
    //         ready     <= 0;
    //         MOSI      <= data[P_DATA_WIDTH-1];
    //         CS        <= 0; // CS в активном состоянии
    //     end
    //     else if (shift_en) begin
    //         if (div_cnt == (P_CLK_DIV/2 - 1)) begin

    //             div_cnt <= 0;
    //             sck     <= !sck;

    //             if (sck == 1'b1) begin
    //                 if (bit_cnt > 0) begin
    //                     MOSI    <= {shift_reg[P_DATA_WIDTH-2:0], 1'b0};
    //                     bit_cnt <= bit_cnt - 1;
    //                 end
    //                 else begin
    //                     shift_en <= 0;
    //                     ready    <= 1;
    //                     CS       <= (P_CS_POLAR ? 0 : 1);   // CS в неактивном состоянии
    //                 end
    //             end
    //         end

    //         else div_cnt <= div_cnt + 1;
    //     end
    // end


// typedef enum logic [1:0] {
//     IDLE, SHIFT
// } statetype;

// statetype state, next_state;

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
