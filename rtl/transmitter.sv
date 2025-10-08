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
logic                          sck_in_d;

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

        DATA_ASSIGN :                     next_state <= SHIFT;

        SHIFT       : if (ready)          next_state <= IDLE;
                      else                next_state <= SHIFT;
    endcase

// разрешающий сигнал для сдвига
always_ff @(posedge clk_100 or posedge a_rst)
    if      (a_rst) sck_in_d <= 0;
    else if (s_rst) sck_in_d <= 0;
    else            sck_in_d <= sck_in;

assign sck_en = sck_in & ~sck_in_d;


// Основная логика передачи
always_ff @(posedge clk_100 or posedge a_rst)
    if (a_rst) begin
        ready     <=  1;
        shift_reg <= '0;
        bit_cnt   <= '0;
        MOSI      <= 'z;
        CS        <=  1; // CS в неактивном состоянии
    end
    else if (s_rst) begin
        ready     <=  1;
        shift_reg <= '0;
        bit_cnt   <= '0;
        MOSI      <= 'z;
        CS        <=  1; // CS в неактивном состоянии
    end
    else begin
        case(state)
            DATA_ASSIGN : begin
                shift_reg <= data_in;
                ready     <= 0;
            end

            SHIFT : begin
                if (sck_en) begin
                    if (bit_cnt < P_DATA_WIDTH) begin
                        CS         <= 0;     // CS в активном состоянии
                        shift_reg  <= {shift_reg[P_DATA_WIDTH-2:0], 1'b0};
                        MOSI       <= shift_reg[P_DATA_WIDTH-1];
                        bit_cnt    <= bit_cnt + 1;
                    end
                    else begin
                        MOSI    <= 'z;
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
        SCK_LP = 0;   // CPOL=0, CPHA=1
        SCK_HN = 1;   // CPOL=1, CPHA=1
    end
    else if (s_rst) begin
        SCK_LP <=  sck_in;
        SCK_HN <= !sck_in;
    end
    else begin
        SCK_LP <=  sck_in;
        SCK_HN <= !sck_in;
    end


// Logic of SCK_LN and SCK_HN
always_ff @(negedge clk_100 or posedge a_rst)
    if (a_rst) begin
        SCK_HP = 0;   // CPOL=1, CPHA=0
        SCK_LN = 1;   // CPOL=0, CPHA=0
    end
    else if (s_rst) begin
        SCK_HP <= !sck_in;
        SCK_LN <=  sck_in;
    end
    else begin
        SCK_HP <= !sck_in;
        SCK_LN <=  sck_in;
    end


endmodule
