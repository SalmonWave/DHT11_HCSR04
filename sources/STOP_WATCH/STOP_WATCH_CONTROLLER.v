`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/11/2024 01:50:25 PM
// Design Name: 
// Module Name: STOP WATCH, WATCH CONTROLLER
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


module WATCH_STOP_WATCH_CONTROLLER(
    input clk,
    input reset,
    input btn_run_stop, btn_clear, btn_mode,

    output reg [$clog2(11600) - 1:0] w_seg_data
);

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    wire [$clog2(11600) - 1:0] w_seg_data_stop_watch;
    wire [$clog2(11600) - 1:0] w_seg_data_clock_hm;
    wire [$clog2(11600) - 1:0] w_seg_data_clock_sms;
    wire w_tick_100hz_STOP_WATCH;
    wire w_tick_1hz_CLOCK;
    wire w_tick_100hz_CLOCK_SMS;
    wire w_mode_BUTTON, w_run_stop_BUTTON, w_clear_BUTTON;


////////////////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////  Watch, Stop watch mode select MUX   //////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    always @(*) begin
        if(w_mode_BUTTON)begin
            w_seg_data = w_seg_data_stop_watch;
        
        end else if (!w_mode_BUTTON) begin
            if(w_run_stop_BUTTON) begin
            w_seg_data = w_seg_data_clock_sms;
            end else begin
            w_seg_data = w_seg_data_clock_hm;
            end
        end
    end

////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////  MODULE INSTANTIATIONS   ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    /*  BUTTON CONTROL */

    stop_watch_button_control U_BUTTON_CONTROL (
        .clk(clk),
        .reset(reset),
        .btn_run_stop(btn_run_stop),
        .btn_clear(btn_clear),
        .btn_mode(btn_mode),
        .run_stop_flag(w_run_stop_BUTTON),
        .clear_flag(w_clear_BUTTON),
        .mode_flag(w_mode_BUTTON)
    );

    /*  STOP WATCH LOGIC */

    tick_10ms_stop_watch U_Clk_Div_100hz_STOP_WATCH (
        .clk(clk),
        .reset(reset),
        .mode_flag(w_mode_BUTTON),
        .run_stop_flag(w_run_stop_BUTTON),
        .tick_100hz(w_tick_100hz_STOP_WATCH)
    );

    counter_6000_stop_watch U_Counter_6000_STOP_WATCH (
        .clk(clk),
        .i_tick(w_tick_100hz_STOP_WATCH),
        .clear_flag(w_clear_BUTTON),
        .mode_flag(w_mode_BUTTON),
        .reset(reset),
        .o_bcd(w_seg_data_stop_watch)
    );

    /*  CLOCK LOGIC (HOUR / MINUTE) */

    tick_1Hz_clock U_TICK_1S_CLOCK_HM (
        .clk(clk),
        .reset(reset),
        .tick_1hz(w_tick_1hz_CLOCK)
    );

    counter_minute_count_clock U_HM (
        .clk(clk),
        .i_tick(w_tick_1hz_CLOCK),
        .reset(reset),
        .o_bcd(w_seg_data_clock_hm)
    );

    /*  CLOCK LOGIC (SECOND / MILI SECOND) */


    tick_10ms_clock U_TICK_10MS_CLOCK_SMS (
        .clk(clk),
        .reset(reset),
        .tick_100hz(w_tick_100hz_CLOCK_SMS)
    );

    counter_6000_clock U_Counter_6000_CLOCK_SMS (
        .clk(clk),
        .i_tick(w_tick_100hz_CLOCK_SMS),
        .reset(reset),
        .o_bcd(w_seg_data_clock_sms)
    );



    
endmodule









