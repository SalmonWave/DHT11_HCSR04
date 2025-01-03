`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/12/2024 04:49:56 PM
// Design Name: 
// Module Name: MODE SELECT FOR FND DISPLAY
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

module mode_selector(
    input clk, reset, btn,
    output reg [1:0] mode
);

    reg btn_prev;   
    wire btn_edge;  

    // Edge detection (rising edge)
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            btn_prev <= 0;  
        end else begin
            btn_prev <= btn;  
        end
    end
    assign btn_edge = (btn && ~btn_prev);  // Detect rising edge

    // Mode counter
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            mode <= 2'b00;  
        end else if (btn_edge) begin
            mode <= mode + 1;  // Increment mode on button press
        end
    end

endmodule