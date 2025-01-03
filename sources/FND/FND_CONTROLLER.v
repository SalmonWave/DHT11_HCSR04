`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/06/2024 02:19:21 PM
// Design Name: 
// Module Name: FND_MAIN_CONTROLLER
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



module fnd_controller (
    input clk,  // System clock input (100 MHz)
    input reset,  // Active high reset signal
    input [$clog2(11600) - 1:0] seg_data_ULTRASONIC,  // Input data to be displayed
    input [$clog2(11600) - 1:0] seg_data_DHT11_temperature,  // Input data to be displayed
    input [$clog2(11600) - 1:0] seg_data_DHT11_humidity,  // Input data to be displayed
    input [$clog2(11600) - 1:0] seg_data_STOPWATCH,  // Input data to be displayed
    input [1:0] mode,  // Mode selection input
    output [3:0] fnd_com,  // Common cathode signals for 7-segment displays
    output [7:0] fnd_font  // Segment font data for 7-segment displays
);

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


    wire [3:0] w_digit_1, w_digit_10, w_digit_100, w_digit_1000; // Decimal values for each digit
    wire [1:0] w_sel;  // Selector for current active digit
    wire [3:0] w_bcd_data;  // Selected BCD data for the active digit
    wire       w_tick_500Hz;  // Clock tick at 500 Hz (generated from 100 MHz)
    wire [$clog2(11600) - 1:0] seg_data;    // Selected input data based on mode


////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////  FND MODE SELECT MUX   ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////  

    reg [$clog2(11600) - 1:0] r_seg_data;

    
    always @(*) begin
        case(mode)
            2'b00: r_seg_data = seg_data_ULTRASONIC;
            2'b01: r_seg_data = seg_data_DHT11_temperature;
            2'b10: r_seg_data = seg_data_DHT11_humidity;
            2'b11: r_seg_data = seg_data_STOPWATCH;
            default: r_seg_data = 0; 
        endcase
        /*
        if(mode == 2'b00) begin
            r_seg_data = seg_data_ULTRASONIC;
        end else if(mode == 2'b01) begin
            r_seg_data = seg_data_DHT11_temperature;
        end else if(mode == 2'b10) begin
            r_seg_data = seg_data_DHT11_humidity;
        end else if (mode == 2'b11) begin
            r_seg_data = seg_data_STOPWATCH;
        end else begin
            r_seg_data = 0;
        end
        */
    end


////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////  MODULE INSTANTIATIONS   ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////    

    /* Generate a 500 Hz tick from the 100 MHz clock */
    tick_gen U_Tick_Gen (
        .clk(clk),
        .reset(reset),
        .tick_1Khz(w_tick_500Hz)
    );

    /* 2-bit counter for digit selection (cycling through 4 digits) */
    counter_4 U_Counter_4 (
        .clk  (w_tick_500Hz),
        .reset(reset),
        .o_sel(w_sel)
    );

    /* Decode the 2-bit digit selector into 4-bit signals to drive the 7-segment displays */
    decoder_2x4 U_Decoder_2x4 (
        .digits_sel(w_sel),
        .fnd_com(fnd_com)
    );

    /* Split input `seg_data` into individual BCD digits for each position */
    digit_splitter U_Digit_Splitter (
        .seg_data(r_seg_data),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000)
    );

    /* Select the BCD data of the currently active digit */
    mux_4x1 U_Mux_4x1 (
        .digit_sel(w_sel),
        .digit_1(w_digit_1),
        .digit_10(w_digit_10),
        .digit_100(w_digit_100),
        .digit_1000(w_digit_1000),
        .bcd_data(w_bcd_data)
    );

    /* Convert the selected BCD data to the corresponding 7-segment font */
    bcd_decoder U_Bcd_Decoder (
        .bcd_data(w_bcd_data),
        .mode(mode),
        .sel(w_sel),
        .fnd_font(fnd_font)
    );

endmodule

