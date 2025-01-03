`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/11/2024 01:50:25 PM
// Design Name: 
// Module Name: COUNTER FOR STOP WATCH
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

module counter_6000_stop_watch (
    input                       clk,
    input                       i_tick,
    input                       reset,
    input                       clear_flag,
    input                       mode_flag,
    output [$clog2(11600) - 1:0] o_bcd
);

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
    
    reg [$clog2(6_000)-1:0] count, count_next;


////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////  MODULE Logic   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////
    
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            count <= 0;
        end else begin
            count <= count_next;
        end
    end

    
    always @(*) begin

        count_next = count;


        if (clear_flag && mode_flag) begin
            count_next = 0;
        end else if (i_tick == 1'b1) begin
            if (count == 6_000) begin
                count_next = 0;
            end else begin
                count_next = count + 1;
            end
        end

    end

    
    assign o_bcd = count;

endmodule




module tick_10ms_stop_watch (
    input clk,
    input reset,
    input run_stop_flag,
    input mode_flag,
    output reg tick_100hz
);

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    reg [$clog2(1_000_000)-1:0] r_counter;

////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////  MODULE Logic   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    always @(posedge clk, posedge reset) begin
        if (reset) begin
            r_counter  <= 0;
            tick_100hz <= 0;
        end else if (run_stop_flag && mode_flag) begin
            if (r_counter == 1_000_000) begin
                r_counter  <= 0;
                tick_100hz <= 1'b1;
            end else begin
                r_counter  <= r_counter + 1;
                tick_100hz <= 1'b0;
            end
        end else if (run_stop_flag && mode_flag) begin
            r_counter <= r_counter;
        end
    end

endmodule
