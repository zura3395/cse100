`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 07:55:22 PM
// Design Name: 
// Module Name: slug
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


module slug(
    input clk,
    input GameOver,
    input frametime,
    input [9:0] Hpixel,
    input [9:0] Vpixel,
    input Left,
    input Right,
    input flash,
    
    output lit_slug,
    output inLeft,
    output inMiddle,
    output inRight
    );
    
    wire coords;
    wire [9:0] leftSide, rightSide;
    wire [9:0] right_movement, left_movement;
    countUD15L right_counter(
        .clk(clk),
        .UD((~(~Left & Right) & 1'b0) | ((~Left & Right) & 1'b1)),
        .CE(~GameOver & frametime & (Left | Right) & (right_movement >= 10'd0) & (right_movement <= 10'd34) & (left_movement == 10'd0)),
        .LD((right_movement == 10'h3FF) | (right_movement == 10'd35)),
        .Din( (~{10{(right_movement == 10'd35)}} & 10'd0) | ({10{(right_movement == 10'd35)}} & 10'd34) ),
        .Q(right_movement)
    );
    
    countUD15L left_counter(
        .clk(clk),
        .UD((~(Left & ~Right) & 1'b0) | ((Left & ~Right) & 1'b1)),
        .CE(~GameOver & frametime & (Left | Right) & (right_movement >= 10'd0) & (right_movement <= 10'd34) & (right_movement == 10'd0)),
        .LD((left_movement == 10'h3FF) | (left_movement == 10'd35)),
        .Din( (~{10{(left_movement == 10'd35)}} & 10'd0) | ({10{(left_movement == 10'd35)}} & 10'd34) ),
        .Q(left_movement)
    );
    
    assign leftSide     = 10'd427 + (2*right_movement) - (2*left_movement);
    assign rightSide    = leftSide + 10'd15;
    assign coords       = (Hpixel >= leftSide) && (Hpixel <= rightSide) && (Vpixel >= 10'd359) && (Vpixel <= 10'd374);
    assign lit_slug     = (coords & ~flash);
    assign inLeft       = (left_movement == 10'd34);
    assign inMiddle     = (leftSide == 10'd427);
    assign inRight      = (right_movement == 10'd34);
    
endmodule

