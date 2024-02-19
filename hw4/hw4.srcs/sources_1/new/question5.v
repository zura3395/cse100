`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 06:44:34 PM
// Design Name: 
// Module Name: question5
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


module question5(
    input clk,
    input x,
    output [5:0] Q,
    output z
    );
    
    wire [5:0] d, q;
    
    FDRE #(.INIT(1'b1) ) ff0 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0) ) ff12345 [4:0] (.C(clk), .R(1'b0), .CE(1'b1), .D(d[5:1]), .Q(q[5:1]));
    
    assign d[0] = x & (q[0] | q[4]); // A
    assign d[1] = ~x & (q[0] | q[1] | q[2] | q[5]); // B
    assign d[2] = x & (q[1] | q[5]); // C
    assign d[3] = x & (q[2]); // D
    assign d[4] = x & (q[3]); // E
    assign d[5] = ~x & (q[3] | q[4]); // F
    
    assign z = q[5];
    assign Q = q;
    
endmodule