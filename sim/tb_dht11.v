`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/23/2024 06:37:18 PM
// Design Name: 
// Module Name: tb_dht11
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


`timescale 1ns / 1ps

module tb_dht11();

    reg i_clk;
    reg i_reset;
    reg i_wr;
    reg i_data_in;
    reg [5:0] i;

    wire [$clog2(11600) - 1:0] o_humidity;
    wire [$clog2(11600) - 1:0] o_temperature;


    tri i_data_io;
    assign i_data_io = (i_wr) ? 1'bZ : i_data_in;



    parameter [7:0] humidity_i = 8'h30;
    parameter [7:0] humidity_f = 8'h00;
    parameter [7:0] temperature_i = 8'h17;
    parameter [7:0] temperature_f = 8'h00;
    parameter [7:0] checksum = 8'h47;
    parameter [39:0] data = { humidity_i, humidity_f, temperature_i, temperature_f, checksum }; 


    DHT11_CONTROLLER_TEST_BENCH DUT(
        .clk(i_clk),
        .reset(i_reset),
        .data_io(i_data_io),
        .humidity(o_humidity),
        .temperature(o_temperature)
    );


    always #5 i_clk = ~i_clk;


        initial begin
            i_clk = 0;
            i_reset = 1;
            i_wr = 1;
           #10 i_reset = 0;
           #17_900_000 

            #30000 i_wr = 0 ;i_data_in = 0;
            #80000 i_data_in = 1;
            #80000 i_data_in = 0;
           
           for (i = 0; i < 40; i = i + 1) begin
                if (data[39-i]) begin  // send data 1
                    #50000 i_data_in = 1;  
                    #70000 i_data_in = 0;  
                end else begin        // send data 0
                    #50000 i_data_in = 1;  
                    #30000 i_data_in = 0;  
                end
            end

        #10000;     

        end





endmodule