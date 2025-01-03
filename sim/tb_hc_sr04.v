`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/22/2024 06:25:27 PM
// Design Name: 
// Module Name: tb_hc_sr04
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


module tb_hc_sr04(

    );

reg i_clk, i_reset;
wire o_trigger; 
wire [$clog2(11600) - 1:0]o_distance;
reg i_echo;

always
    #5 i_clk = ~i_clk;



HC_SR04_CONTROLLER DUT(
    .clk(i_clk), .reset(i_reset), .echo(i_echo),
    .trigger(o_trigger),
    .distance(o_distance) 
    );


initial begin
    i_clk = 0;
    i_reset = 1;
    i_echo = 0;

    #10 i_reset = 0;
    #1_000_00
    #100_000 i_echo = 1;
    #140_000 i_echo = 0;

end




endmodule
