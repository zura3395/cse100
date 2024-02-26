`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2024 05:58:47 PM
// Design Name: 
// Module Name: Lab5_6bit_shifter
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


module Lab5_6bit_shifter(
    input clk,
    input shift_up,
    input shift_down,
    input off,
    output [5:0] led,
    output lastLED,
    output noLEDs
    );
    
    wire [5:0] d;
    wire [5:0] q;
    
    wire [5:0] shift_up_result;
    wire [5:0] shift_down_result;
    
    // Flip-flops for each bit
    FDRE #(.INIT(1'b1)) FF0 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b1)) FF1 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[1]), .Q(q[1]));
    FDRE #(.INIT(1'b1)) FF2 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[2]), .Q(q[2]));
    FDRE #(.INIT(1'b0)) FF3 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[3]), .Q(q[3]));
    FDRE #(.INIT(1'b0)) FF4 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[4]), .Q(q[4]));
    FDRE #(.INIT(1'b0)) FF5 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[5]), .Q(q[5]));
    
    assign d[5:0] = ({6{shift_up}} & shift_up_result[5:0]) | ({6{shift_down}} & shift_down_result[5:0]) | (~{6{shift_up}} & ~{6{shift_down}} & q[5:0]);
    assign shift_up_result = {q[4:0], 1'b1};
    
    assign shift_down_result = {1'b0, q[5:1]};
    
    // Outputs
    assign led = q & ~{6{off}};
    assign lastLED = q[5];
    assign noLEDs = ~|q;
    
endmodule
