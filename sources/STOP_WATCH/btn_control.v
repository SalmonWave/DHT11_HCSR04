`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/11/2024 01:50:25 PM
// Design Name: 
// Module Name: FLAG CONTROLLED BY BUTTON FOR STOP WATCH, CLOCK
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

module stop_watch_button_control(
    input  clk,
    reset,
    btn_run_stop,
    btn_clear,
    btn_mode,
    output run_stop_flag,
    clear_flag,
    mode_flag
);

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  PARAMETERS   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    localparam CLOCK_HM = 3'b000;
    localparam CLOCK_SMS = 3'b001;
    localparam RUN = 3'b011;
    localparam STOP = 3'b010;
    localparam CLEAR = 3'b100;


////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


    reg [2:0] state, next_state;
    reg r_mode, r_run_stop, r_clear;


////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////  MODULE Logic   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////


    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= CLOCK_HM;
        end else begin
            state <= next_state;
        end

    end


    always @(*) begin
        case (state)

            CLOCK_HM:
            if (btn_run_stop) begin
                next_state = CLOCK_SMS;
            end else if (btn_mode) begin
                next_state = STOP;
            end else begin
                next_state = state;
            end

            CLOCK_SMS:
            if (btn_run_stop) begin
                next_state = CLOCK_HM;
            end else begin
                next_state = state;
            end

            RUN:
            if (btn_run_stop) begin
                next_state = STOP;
            end else begin
                next_state = state;
            end


            STOP:
            if(btn_mode) begin
                next_state = CLOCK_HM;
            end
            else if (btn_clear) begin
                next_state = CLEAR;
            end else if (btn_run_stop) begin
                next_state = RUN;
            end else begin
                next_state = state;
            end


            CLEAR: next_state = STOP;


            default: next_state = state;
        endcase
    end

    always @(*) begin


        case (state)

            CLOCK_HM: begin
                r_mode = 0;
                r_run_stop = 0;
                r_clear = 0;
            end

            CLOCK_SMS: begin
                r_mode = 0;
                r_run_stop = 1;
                r_clear = 0;
            end

            RUN: begin
                r_mode = 1;
                r_run_stop = 1;
                r_clear = 0;
            end
            STOP: begin
                r_mode = 1;
                r_run_stop = 0;
                r_clear = 0;
            end
            CLEAR: begin
                r_mode = 1;
                r_run_stop = 0;
                r_clear = 1;
            end
            default: begin
                r_mode = 0;
                r_run_stop = 0;
                r_clear = 0;
            end
        endcase
    end

    assign mode_flag = r_mode;
    assign run_stop_flag = r_run_stop;
    assign clear_flag = r_clear;

endmodule

