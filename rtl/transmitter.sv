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

// // transmitter
// //   - handshake: asserts ready when idle; accepts data when valid&&ready
// //   - on accept: raises CS (active according to P_CS_POLAR), generates SCK, shifts data MSB-first
// //   - P_CLK_DIV defines number of clk_100 cycles per SCK half period (must be >=2)
// //   - produces four SCK variants:
// //       SCK_HP: idle=1, active edges = rising (P)
// //       SCK_LP: idle=0, active edges = rising (P)
// //       SCK_HN: idle=1, active edges = falling (N)
// //       SCK_LN: idle=0, active edges = falling (N)
// // --------------------------------------------------
// module transmitter #(
//   parameter int P_DATA_WIDTH = 8,
//   parameter int P_CLK_DIV    = 8,
//   parameter bit P_CS_POLAR   = 0
// )(
//   input  logic clk_100,
//   input  logic s_rst,
//   input  logic a_rst,

//   output logic ready,
//   input  logic valid,
//   input  logic [P_DATA_WIDTH-1:0] data,

//   output logic SCK_HP,
//   output logic SCK_LP,
//   output logic SCK_HN,
//   output logic SCK_LN,
//   output logic CS,
//   output logic MOSI
// );

//   // local checks
//   initial begin
//     if (P_CLK_DIV < 2) $fatal(1, "P_CLK_DIV must be >= 2");
//   end

//   // divider: produces 'sck_tick' every P_CLK_DIV clock cycles which toggles sck_phase
//   localparam int DIV_WIDTH = $clog2(P_CLK_DIV);
//   logic [DIV_WIDTH-1:0] div_cnt;
//   logic sck_toggle; // toggles every P_CLK_DIV cycles -> generates SCK half period

//   // SCK internal
//   logic sck; // internal SCK (0/1 toggling). Active only when 'shift_active' is high
//   logic shift_active;
//   logic [$clog2(P_DATA_WIDTH+1)-1:0] bits_remaining;
//   logic [P_DATA_WIDTH-1:0] shift_reg;
//   logic sck_rising_edge; // assert for one clk when sck goes 0->1
//   logic sck_falling_edge;

//   // async reset + synchronous
//   always_ff @(posedge clk_100 or posedge a_rst) begin
//     if (a_rst) begin
//       div_cnt <= '0;
//       sck_toggle <= 1'b0;
//       sck <= 1'b0;
//       sck_rising_edge <= 1'b0;
//       sck_falling_edge <= 1'b0;
//       shift_active <= 1'b0;
//       bits_remaining <= '0;
//       shift_reg <= '0;
//       ready <= 1'b1;
//       MOSI <= 1'b0;
//       CS <= (P_CS_POLAR ? 1'b0 : 1'b1); // inactive state
//     end else begin
//       if (s_rst) begin
//         div_cnt <= '0;
//         sck_toggle <= 1'b0;
//         sck <= 1'b0;
//         sck_rising_edge <= 1'b0;
//         sck_falling_edge <= 1'b0;
//         shift_active <= 1'b0;
//         bits_remaining <= '0;
//         shift_reg <= '0;
//         ready <= 1'b1;
//         MOSI <= 1'b0;
//         CS <= (P_CS_POLAR ? 1'b0 : 1'b1);
//       end else begin
//         // default clear edge flags
//         sck_rising_edge <= 1'b0;
//         sck_falling_edge <= 1'b0;

//         // handshake: when idle ready=1. When valid & ready => accept and start shifting
//         if (ready && valid) begin
//           // Accept data
//           shift_reg <= data;
//           bits_remaining <= P_DATA_WIDTH;
//           shift_active <= 1'b1;
//           ready <= 1'b0;
//           // assert CS active
//           CS <= P_CS_POLAR ? 1'b1 : 1'b0;
//           // initialize SCK and divider so first edge happens after half period
//           div_cnt <= '0;
//           sck_toggle <= 1'b0;
//           sck <= 1'b0;
//           MOSI <= data[P_DATA_WIDTH-1]; // MSB first
//         end else if (shift_active) begin
//           // clock divider
//           if (div_cnt == P_CLK_DIV-1) begin
//             div_cnt <= '0;
//             sck_toggle <= ~sck_toggle;
//             logic prev_sck = sck;
//             sck <= ~sck; // toggle SCK

//             if (~prev_sck && sck) begin
//               // rising edge happened
//               sck_rising_edge <= 1'b1;
//             end else if (prev_sck && ~sck) begin
//               // falling edge happened
//               sck_falling_edge <= 1'b1;
//             end

//             // We will shift data on one of edges — here choose: shift on rising edge (per requirement "transmission by front/back")
//             // To support both, we will output MOSI stable before the active edge and shift after the active edge.
//             // We'll use rising-edge to move to next bit.
//             if (sck_rising_edge) begin
//               // after the rising edge, consume one bit (we already provided MOSI before the edge)
//               if (bits_remaining > 0) begin
//                 bits_remaining <= bits_remaining - 1;
//                 if (bits_remaining-1 > 0) begin
//                   // shift left: next bit to output is next MSB
//                   shift_reg <= {shift_reg[P_DATA_WIDTH-2:0], 1'b0};
//                   MOSI <= shift_reg[P_DATA_WIDTH-2]; // next bit
//                 end else begin
//                   // last bit will be shifted; keep MOSI stable
//                   MOSI <= 1'b0;
//                 end
//               end
//             end

//             // end of frame?
//             if (bits_remaining == 1 && sck_rising_edge) begin
//               // we just finished sending the last bit
//               shift_active <= 1'b0;
//               ready <= 1'b1;
//               // deassert CS (inactive)
//               CS <= P_CS_POLAR ? 1'b0 : 1'b1;
//             end

//           end else begin
//             div_cnt <= div_cnt + 1;
//           end

//         end else begin
//           // idle
//           div_cnt <= '0;
//           sck_toggle <= 1'b0;
//           sck <= 1'b0;
//           MOSI <= 1'b0;
//           ready <= 1'b1;
//           CS <= (P_CS_POLAR ? 1'b0 : 1'b1);
//         end
//       end
//     end
//   end

//   // Provide the four SCK outputs according to definitions:
//   // SCK_HP: idle H (1), transmission by rising edge (P) -> produce pulse high/low accordingly
//   // SCK_LP: idle L (0), transmission by rising edge (P)
//   // SCK_HN: idle H (1), transmission by falling edge (N)
//   // SCK_LN: idle L (0), transmission by falling edge (N)
//   //
//   // Implementation approach:
//   //  - when idle (shift_active==0), drive signals to idle levels.
//   //  - when active, use sck internal (0/1) but choose which edge considered 'active' for each net:
//   //    For *_P versions, the 'active' transition is rising edge: so we map sck as-is.
//   //    For *_N versions, map inverted sck (so falling edges in sck appear as rising in inverted).
//   //  Idle levels configured accordingly.

//   always_comb begin
//     if (!shift_active) begin
//       // idle
//       SCK_HP = 1'b1;
//       SCK_HN = 1'b1;
//       SCK_LP = 1'b0;
//       SCK_LN = 1'b0;
//     end else begin
//       // during active transfer, present sck waveform but choose polarity:
//       // For *_P: present sck as is
//       SCK_HP = sck ? 1'b1 : 1'b0; // idle when low-high? we keep raw sck; tests expect transitions
//       SCK_LP = sck ? 1'b1 : 1'b0;
//       // For *_N: inverted sck
//       SCK_HN = ~sck;
//       SCK_LN = ~sck;
//       // However also set idle baselines consistent with names: (the consumer can choose which they want)
//       // (We leave as direct mapping so both edge types are available)
//     end
//   end





//   // transmitter.sv
// // Упрощённый и более понятный вариант
// module transmitter #(
//   parameter int P_DATA_WIDTH = 8,
//   parameter int P_CLK_DIV    = 8,
//   parameter bit P_CS_POLAR   = 0
// )(
//   input  logic clk_100,
//   input  logic s_rst,
//   input  logic a_rst,

//   output logic ready,
//   input  logic valid,
//   input  logic [P_DATA_WIDTH-1:0] data,

//   output logic SCK_HP,
//   output logic SCK_HN,
//   output logic SCK_LP,
//   output logic SCK_LN,
//   output logic CS,
//   output logic MOSI
// );

//   // -----------------------------
//   // Внутренние сигналы
//   // -----------------------------
//   logic [P_DATA_WIDTH-1:0] shift_reg;
//   int bit_count;
//   logic shift_active;

//   // Делитель частоты
//   int div_cnt;
//   logic sck_int;    // базовый SPI-тактовый сигнал
//   logic sck_enable; // активен только во время передачи

//   // -----------------------------
//   // Управление (handshake)
//   // -----------------------------
//   always_ff @(posedge clk_100 or posedge a_rst) begin
//     if (a_rst) begin
//       ready        <= 1'b1;
//       shift_active <= 1'b0;
//       bit_count    <= 0;
//       shift_reg    <= '0;
//       div_cnt      <= 0;
//       sck_int      <= 0;
//       MOSI         <= 0;
//       CS           <= (P_CS_POLAR ? 1'b0 : 1'b1); // CS в "неактивном" состоянии
//     end else if (s_rst) begin
//       ready        <= 1'b1;
//       shift_active <= 1'b0;
//       bit_count    <= 0;
//       shift_reg    <= '0;
//       div_cnt      <= 0;
//       sck_int      <= 0;
//       MOSI         <= 0;
//       CS           <= (P_CS_POLAR ? 1'b0 : 1'b1);
//     end else begin
//       if (ready && valid) begin
//         // Принимаем данные
//         shift_reg    <= data;
//         bit_count    <= P_DATA_WIDTH;
//         shift_active <= 1'b1;
//         ready        <= 1'b0;
//         CS           <= (P_CS_POLAR ? 1'b1 : 1'b0); // активный CS
//         MOSI         <= data[P_DATA_WIDTH-1];       // первый бит (MSB)
//         sck_int      <= 0; // сбрасываем SCK
//         div_cnt      <= 0;
//       end else if (shift_active) begin
//         // Генерация SCK
//         if (div_cnt == (P_CLK_DIV/2 - 1)) begin
//           div_cnt <= 0;
//           sck_int <= ~sck_int;

//           // На фронтах SCK — сдвигаем данные
//           if (sck_int == 1'b1) begin
//             // В момент перехода 1→0 данные уже выданы, готовим следующий бит
//             if (bit_count > 1) begin
//               shift_reg <= {shift_reg[P_DATA_WIDTH-2:0], 1'b0};
//               MOSI      <= shift_reg[P_DATA_WIDTH-2];
//               bit_count <= bit_count - 1;
//             end else begin
//               // Последний бит ушёл
//               shift_active <= 1'b0;
//               ready        <= 1'b1;
//               CS           <= (P_CS_POLAR ? 1'b0 : 1'b1); // деактивируем CS
//             end
//           end
//         end else begin
//           div_cnt <= div_cnt + 1;
//         end
//       end
//     end
//   end

//   // -----------------------------
//   // Формирование четырёх версий SCK
//   // -----------------------------
//   always_comb begin
//     if (!shift_active) begin
//       // Молчание
//       SCK_HP = 1'b1;
//       SCK_HN = 1'b1;
//       SCK_LP = 1'b0;
//       SCK_LN = 1'b0;
//     end else begin
//       // Во время передачи — строим все четыре версии
//       // P (posedge active) версии = берём sck_int как есть
//       SCK_HP = sck_int ? 1'b1 : 1'b0; // idle=1 → значит инвертируем начальное состояние
//       SCK_LP = sck_int;

//       // N (negedge active) версии = инвертируем sck_int
//       SCK_HN = ~sck_int;
//       SCK_LN = ~sck_int;
//     end
//   end

// endmodule








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
