`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 07:25:54 PM
// Design Name: 
// Module Name: question1
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


module fsm3(
     input clk, x,
    output z
    );
    
    wire [1:0] Q, D;
        
    FDRE #(.INIT(1'b0)) Q123FF[1:0] (.C({2{clk}}),.R(2'b0),.CE(2'b11), .D(D), .Q(Q) );
    
    assign D[1] = Q[1] ^ Q[0];
    assign D[0] = x & Q[1] | ~Q[1] & ~Q[0];
    assign z = ~x & Q[1] | Q[0];    
   
endmodule