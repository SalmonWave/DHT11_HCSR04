`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: T.Y JANG
// 
// Create Date: 12/22/2024 05:39:26 PM
// Design Name: 
// Module Name: hc_sr04_controller
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


module HC_SR04_CONTROLLER(
    input clk,
    input reset,
    input echo,
    output reg trigger,
    output [$clog2(11600) - 1:0] distance
);

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  PARAMETERS   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    localparam IDLE = 2'b00;
    localparam TRIGGER = 2'b01;
    localparam CAPTURE = 2'b10;

////////////////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////  WIRE & REG   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    reg [1:0] state, next_state;

    reg [$clog2(11600) - 1:0] w_us_tick_counter;
    wire w_100ms_tick, w_us_tick;

    reg                       prev_echo;  // for echo edge detection
    reg                       capture_flag;
    reg [$clog2(11600) - 1:0] r_distance_tick;


    assign distance = r_distance_tick < (58 * 200) ? r_distance_tick / 58 : 0;      // 58us per cm

////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////  MODULE INSTANTIATIONS   ///////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    /*  TICK CLOCK GENERATOR */
    
    tick_clock #(
        .CLOCK_FREQ (100_000_000),
        .TARGET_FREQ(10)
    ) ms_100_tick_generator (
        .clk  (clk),
        .reset(reset),
        .tick (w_100ms_tick)
    );

    tick_clock #(
        .CLOCK_FREQ (100_000_000),
        .TARGET_FREQ(1_000_000)
    ) us_tick_generator (
        .clk  (clk),
        .reset(reset),
        .tick (w_us_tick)
    );


////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////////////  MODULE Logic   ////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////

    /*          State Register Update          */
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            state <= IDLE;
            prev_echo <= 0;
        end else begin
            state <= next_state;
            prev_echo <= echo;
        end

    end


    /*          State Transition Logic          */
    always @(*) begin
        
        next_state = state;

        case (state)
            IDLE: begin
                next_state = TRIGGER;
            end

            TRIGGER: begin
                if (w_us_tick_counter == 10) begin
                    next_state = CAPTURE;
                end else begin
                    next_state = TRIGGER;
                end
            end

            CAPTURE: begin
                if ((!prev_echo && echo)) begin
                    next_state = CAPTURE;
                end else if (capture_flag && (prev_echo && !echo)) begin
                    next_state = IDLE;
                end else if (w_100ms_tick) begin
                    next_state = IDLE;
                end else begin
                    next_state = CAPTURE;
                end
            end

            default: next_state = IDLE;
        endcase
    end




    /*          Trigger Signal Logic          */
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            trigger <= 0;
        end else begin
            if (state == TRIGGER && w_us_tick_counter < 10) begin
                trigger <= 1; // Trigger pulse active for 10 us ticks
            end else begin
                trigger <= 0; 
            end
        end
    end





    /*         Edge Detection and Distance value update          */
    always @(posedge clk, posedge reset) begin
        if (reset) begin
            capture_flag <= 0;
            r_distance_tick <= 0;
        end else begin
            case (state)
                IDLE: begin
                    capture_flag <= 0;
                end

                TRIGGER: begin
                    capture_flag <= 0;  
                end

                CAPTURE: begin
                    if ((!prev_echo && echo)) begin   // rising echo edge
                        capture_flag <= 1;  
                    end else if (capture_flag && (prev_echo && !echo)) begin    // falling echo edge
                        r_distance_tick <= w_us_tick_counter;  
                        capture_flag <= 0;  
                    end else if (w_100ms_tick) begin    // timeout
                        capture_flag <= 0;  
                    end
                end
            endcase
        end
    end





    /*          1us Tick Counter          */
    always @(posedge w_us_tick, posedge reset) begin 
        if (reset) begin
            w_us_tick_counter <= 0;
        end else begin

            case (state)
                IDLE: begin
                    w_us_tick_counter <= 0;
                end

                TRIGGER: begin
                    if (w_us_tick_counter < 10) begin
                        w_us_tick_counter <= w_us_tick_counter + 1;
                    end else begin
                        w_us_tick_counter <= 0;
                    end
                end

                CAPTURE: begin
                    if (capture_flag) begin
                        w_us_tick_counter <= w_us_tick_counter + 1;
                    end else begin
                        w_us_tick_counter <= 0;
                    end
                end

            endcase
        end
    end





    
endmodule