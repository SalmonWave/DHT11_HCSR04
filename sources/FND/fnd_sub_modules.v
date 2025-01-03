`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/06/2024 02:19:21 PM
// Design Name: 
// Module Name: fnd_controller_sub_modules
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////



/* Tick generator module: generates a 500 Hz signal from a 100 MHz clock */
module tick_gen (
    input      clk,       // 100 MHz clock input
    input      reset,     // Reset signal
    output reg tick_1Khz  // 500 Hz tick output
);

    reg [$clog2(500_000)-1:0] r_tick_counter;  // Counter to divide clock

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_tick_counter <= 0;
        end else begin
            if (r_tick_counter == 500_000) begin
                r_tick_counter <= 0;
                tick_1Khz <= 1'b1;
            end else begin
                r_tick_counter <= r_tick_counter + 1;
                tick_1Khz <= 1'b0;
            end
        end
    end

endmodule

/* Counter module: generates a 2-bit output to select one of four digits */
module counter_4 (
    input        clk,    // 500 Hz clock input
    input        reset,  // Reset signal
    output [1:0] o_sel   // 2-bit selector for the active digit
);

    reg [1:0] r_counter;

    assign o_sel = r_counter;

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter <= 2'b00;
        end else begin
            r_counter <= r_counter + 1;
        end
    end

endmodule

/* Digit splitter: splits `seg_data` into individual BCD digits */
module digit_splitter (
    input  [$clog2(11600) - 1:0] seg_data,  // Input number (0~11599)
    output [                3:0] digit_1,   // Units place digit
    digit_10,  // Tens place digit
    digit_100,  // Hundreds place digit
    digit_1000  // Thousands place digit
);

    assign digit_1 = seg_data % 10;
    assign digit_10 = (seg_data / 10) % 10;
    assign digit_100 = (seg_data / 100) % 10;
    assign digit_1000 = (seg_data / 1000) % 10;

endmodule

/* 4:1 multiplexer to select the BCD data of the active digit */
module mux_4x1 (
    input      [1:0] digit_sel,   // Selector for the active digit
    input      [3:0] digit_1,
    input      [3:0] digit_10,
    input      [3:0] digit_100,
    input      [3:0] digit_1000,
    output reg [3:0] bcd_data     // Selected BCD data
);

    always @(digit_sel, digit_1, digit_10, digit_100, digit_1000) begin
        case (digit_sel)
            2'b00: bcd_data = digit_1;
            2'b01: bcd_data = digit_10;
            2'b10: bcd_data = digit_100;
            2'b11: bcd_data = digit_1000;
        endcase
    end

endmodule

/* BCD to 7-segment decoder */
module bcd_decoder (
    input      [3:0] bcd_data,  // Input BCD digit
    input      [1:0] sel,       // Selector for digit placement
    input      [1:0] mode,      // Mode selection input
    output reg [7:0] fnd_font   // Corresponding 7-segment font
);

    localparam ULTRASONIC_DISPLAY = 2'b00;
    localparam DHT11_TEMPERATURE_DISPLAY = 2'b01;
    localparam DHT11_HUMIDITY_DISPLAY = 2'b10;
    localparam STOPWATCH_DISPLAY = 2'b11;

    always @(bcd_data, sel, mode) begin

    case(mode)

        ULTRASONIC_DISPLAY:
            case (sel)


                2'b00:
                case (bcd_data)
                    4'h0: fnd_font = 8'hc0;
                    4'h1: fnd_font = 8'hf9;
                    4'h2: fnd_font = 8'ha4;
                    4'h3: fnd_font = 8'hb0;
                    4'h4: fnd_font = 8'h99;
                    4'h5: fnd_font = 8'h92;
                    4'h6: fnd_font = 8'h82;
                    4'h7: fnd_font = 8'hf8;
                    4'h8: fnd_font = 8'h80;
                    4'h9: fnd_font = 8'h90;
                    4'ha: fnd_font = 8'h88;
                    4'hb: fnd_font = 8'h83;
                    4'hc: fnd_font = 8'hc6;
                    4'hd: fnd_font = 8'ha1;
                    4'he: fnd_font = 8'h86;
                    4'hf: fnd_font = 8'h8e;
                    default: fnd_font = 8'hc0;
                endcase


                2'b01:
                case (bcd_data)
                    4'h0: fnd_font = 8'hc0;
                    4'h1: fnd_font = 8'hf9;
                    4'h2: fnd_font = 8'ha4;
                    4'h3: fnd_font = 8'hb0;
                    4'h4: fnd_font = 8'h99;
                    4'h5: fnd_font = 8'h92;
                    4'h6: fnd_font = 8'h82;
                    4'h7: fnd_font = 8'hf8;
                    4'h8: fnd_font = 8'h80;
                    4'h9: fnd_font = 8'h90;
                    4'ha: fnd_font = 8'h88;
                    4'hb: fnd_font = 8'h83;
                    4'hc: fnd_font = 8'hc6;
                    4'hd: fnd_font = 8'ha1;
                    4'he: fnd_font = 8'h86;
                    4'hf: fnd_font = 8'h8e;
                    default: fnd_font = 8'hc0;
                endcase


                2'b10:
                case (bcd_data)
                    4'h0: fnd_font = 8'hc0;
                    4'h1: fnd_font = 8'hf9;
                    4'h2: fnd_font = 8'ha4;
                    4'h3: fnd_font = 8'hb0;
                    4'h4: fnd_font = 8'h99;
                    4'h5: fnd_font = 8'h92;
                    4'h6: fnd_font = 8'h82;
                    4'h7: fnd_font = 8'hf8;
                    4'h8: fnd_font = 8'h80;
                    4'h9: fnd_font = 8'h90;
                    4'ha: fnd_font = 8'h88;
                    4'hb: fnd_font = 8'h83;
                    4'hc: fnd_font = 8'hc6;
                    4'hd: fnd_font = 8'ha1;
                    4'he: fnd_font = 8'h86;
                    4'hf: fnd_font = 8'h8e;
                    default: fnd_font = 8'hc0;
                endcase


                2'b11:
                case (bcd_data)
                    4'h0: fnd_font = 8'hc0;
                    4'h1: fnd_font = 8'hf9;
                    4'h2: fnd_font = 8'ha4;
                    4'h3: fnd_font = 8'hb0;
                    4'h4: fnd_font = 8'h99;
                    4'h5: fnd_font = 8'h92;
                    4'h6: fnd_font = 8'h82;
                    4'h7: fnd_font = 8'hf8;
                    4'h8: fnd_font = 8'h80;
                    4'h9: fnd_font = 8'h90;
                    4'ha: fnd_font = 8'h88;
                    4'hb: fnd_font = 8'h83;
                    4'hc: fnd_font = 8'hc6;
                    4'hd: fnd_font = 8'ha1;
                    4'he: fnd_font = 8'h86;
                    4'hf: fnd_font = 8'h8e;
                    default: fnd_font = 8'hc0;
                endcase

            endcase
            
        DHT11_TEMPERATURE_DISPLAY:
        case (sel)


            2'b00:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase


            2'b01:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase


            2'b10:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0 - 8'h80;
                4'h1: fnd_font = 8'hf9 - 8'h80;
                4'h2: fnd_font = 8'ha4 - 8'h80;
                4'h3: fnd_font = 8'hb0 - 8'h80;
                4'h4: fnd_font = 8'h99 - 8'h80;
                4'h5: fnd_font = 8'h92 - 8'h80;
                4'h6: fnd_font = 8'h82 - 8'h80;
                4'h7: fnd_font = 8'hf8 - 8'h80;
                4'h8: fnd_font = 8'h80 - 8'h80;
                4'h9: fnd_font = 8'h90 - 8'h80;
                4'ha: fnd_font = 8'h88 - 8'h80;
                4'hb: fnd_font = 8'h83 - 8'h80;
                4'hc: fnd_font = 8'hc6 - 8'h80;
                4'hd: fnd_font = 8'ha1 - 8'h80;
                4'he: fnd_font = 8'h86 - 8'h80;
                4'hf: fnd_font = 8'h8e - 8'h80;
                default: fnd_font = 8'hc0 - 8'h80;
            endcase


            2'b11:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase

        endcase

        DHT11_HUMIDITY_DISPLAY:
          case (sel)


            2'b00:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase


            2'b01:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase


            2'b10:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase


            2'b11:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase

        endcase

        STOPWATCH_DISPLAY:
        case (sel)


            2'b00:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0 - 8'h80;
                4'h1: fnd_font = 8'hf9 - 8'h80;
                4'h2: fnd_font = 8'ha4 - 8'h80;
                4'h3: fnd_font = 8'hb0 - 8'h80;
                4'h4: fnd_font = 8'h99 - 8'h80;
                4'h5: fnd_font = 8'h92 - 8'h80;
                4'h6: fnd_font = 8'h82 - 8'h80;
                4'h7: fnd_font = 8'hf8 - 8'h80;
                4'h8: fnd_font = 8'h80 - 8'h80;
                4'h9: fnd_font = 8'h90 - 8'h80;
                4'ha: fnd_font = 8'h88 - 8'h80;
                4'hb: fnd_font = 8'h83 - 8'h80;
                4'hc: fnd_font = 8'hc6 - 8'h80;
                4'hd: fnd_font = 8'ha1 - 8'h80;
                4'he: fnd_font = 8'h86 - 8'h80;
                4'hf: fnd_font = 8'h8e - 8'h80;
                default: fnd_font = 8'hc0 - 8'h80;
            endcase


            2'b01:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase


            2'b10:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0 - 8'h80;
                4'h1: fnd_font = 8'hf9 - 8'h80;
                4'h2: fnd_font = 8'ha4 - 8'h80;
                4'h3: fnd_font = 8'hb0 - 8'h80;
                4'h4: fnd_font = 8'h99 - 8'h80;
                4'h5: fnd_font = 8'h92 - 8'h80;
                4'h6: fnd_font = 8'h82 - 8'h80;
                4'h7: fnd_font = 8'hf8 - 8'h80;
                4'h8: fnd_font = 8'h80 - 8'h80;
                4'h9: fnd_font = 8'h90 - 8'h80;
                4'ha: fnd_font = 8'h88 - 8'h80;
                4'hb: fnd_font = 8'h83 - 8'h80;
                4'hc: fnd_font = 8'hc6 - 8'h80;
                4'hd: fnd_font = 8'ha1 - 8'h80;
                4'he: fnd_font = 8'h86 - 8'h80;
                4'hf: fnd_font = 8'h8e - 8'h80;
                default: fnd_font = 8'hc0 - 8'h80;
            endcase


            2'b11:
            case (bcd_data)
                4'h0: fnd_font = 8'hc0;
                4'h1: fnd_font = 8'hf9;
                4'h2: fnd_font = 8'ha4;
                4'h3: fnd_font = 8'hb0;
                4'h4: fnd_font = 8'h99;
                4'h5: fnd_font = 8'h92;
                4'h6: fnd_font = 8'h82;
                4'h7: fnd_font = 8'hf8;
                4'h8: fnd_font = 8'h80;
                4'h9: fnd_font = 8'h90;
                4'ha: fnd_font = 8'h88;
                4'hb: fnd_font = 8'h83;
                4'hc: fnd_font = 8'hc6;
                4'hd: fnd_font = 8'ha1;
                4'he: fnd_font = 8'h86;
                4'hf: fnd_font = 8'h8e;
                default: fnd_font = 8'hc0;
            endcase

        endcase
    endcase
    end


endmodule



/* Decoder for digit selection lines */
module decoder_2x4 (
    input [1:0] digits_sel,  // 2-bit digit selector
    output reg [3:0] fnd_com  // Common cathode control lines
);

    always @(digits_sel) begin
        case (digits_sel)
            2'b00:   fnd_com = 4'b1110;  // Enable digit 0
            2'b01:   fnd_com = 4'b1101;  // Enable digit 1
            2'b10:   fnd_com = 4'b1011;  // Enable digit 2
            2'b11:   fnd_com = 4'b0111;  // Enable digit 3
            default: fnd_com = 4'b1111;  // All digits off
        endcase
    end

endmodule
