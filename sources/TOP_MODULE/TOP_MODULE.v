`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/22/2024 05:32:14 PM
// Design Name: 
// Module Name: TOP_MODULE
// Project Name: Combine STOP_WATCH, WATCH / DHT11 / HC-SR04
// Target Devices: BASYS-3
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


module TOP_MODULE(
    input clk, reset,
    input mode_select,

    input btn_run_stop, btn_clear, btn_mode,    //  STOPWATCH SIGNALS

    input echo,                                 // HC-SR04 SIGNALS
    output trigger,

    inout data_io,                              //  DHT11 SIGNALS
    output [7:0] led,                           

    output [3:0] fnd_com,                       //  FND SIGNALS
    output [7:0] fnd_font
    );

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
   
    /*  USER INPUT */

    wire [1:0] w_mode;
    wire debounced_mode_select, debounced_run_stop, debounced_clear, debounced_mode;


    /*  Decimal Data from Sensors */

    wire [$clog2(11600) - 1:0] w_distance, w_humidity, w_temperature, w_stopwatch;


////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////  MODULE INSTANTIATIONS   ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    /*  Core Module Instantiations */


    WATCH_STOP_WATCH_CONTROLLER U_STOPWATCH(
        .clk(clk),
        .reset(reset),
        .btn_run_stop(debounced_run_stop),
        .btn_clear(debounced_clear),
        .btn_mode(debounced_mode),
        .w_seg_data(w_stopwatch)
    );


    HC_SR04_CONTROLLER U_ULTRASONIC(
    .clk(clk), .reset(reset), .echo(echo),
    .trigger(trigger),
    .distance(w_distance)
    );


    DHT11_CONTROLLER U_DHT11(
        .clk(clk),
        .reset(reset),
        .data_io(data_io),
        .humidity(w_humidity),
        .temperature(w_temperature),
        .led(led)
    );



    /*  Button Debounce, Mode Select */

    mode_selector U_MODE_SELECTOR(
        .clk(clk),
        .reset(reset),
        .btn(debounced_mode_select),
        .mode(w_mode)
    );

    debounce U_DEBOUNCE_MODE_SELECT(
        .clk(clk),
        .reset(reset),
        .i_btn(mode_select),
        .o_btn(debounced_mode_select)
    );

    debounce U_DEBOUNCE_STOP_WATCH_RUN_STOP(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_run_stop),
        .o_btn(debounced_run_stop)
    );

    debounce U_DEBOUNCE_STOP_WATCH_CLEAR(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_clear),
        .o_btn(debounced_clear)
    );

    debounce U_DEBOUNCE_STOP_WATCH_MODE(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_mode),
        .o_btn(debounced_mode)
    );

    /*  FND Controller */


    fnd_controller U_FND_CONTROL(
        .clk(clk),
        .reset(reset),
        .seg_data_ULTRASONIC(w_distance),
        .seg_data_DHT11_temperature(w_temperature),
        .seg_data_DHT11_humidity(w_humidity),
        .seg_data_STOPWATCH(w_stopwatch),
        .fnd_com(fnd_com),
        .fnd_font(fnd_font),
        .mode(w_mode)
    );


endmodule
