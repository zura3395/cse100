`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 10:26:50 PM
// Design Name: 
// Module Name: ten_frame_counter
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


module ten_frame_counter(
    input clk,
    input frametime,

    output ten_frames
    );
    
    wire [4:0] q;
    countUD5L counter (
        .clk(clk),
        .UD(1'b1),
        .CE(frametime),
        .LD(q == 5'd10),
        .Din(5'd0),
        .Q(q)
    );
    
    assign ten_frames = (q == 5'd10);
endmodule
