`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/25/2024 08:14:38 PM
// Design Name: 
// Module Name: energy_bar
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


module energy_bar(
    input clk,
    input GameOver,
    input frametime,
    input Hover,
    input [9:0] Hpixel,
    input [9:0] Vpixel,
    
    output lit_bar,
    output no_energy
    );
    
    wire [14:0] energy_consumed;
    countUD15L energy_counter (
        .clk(clk),
        .UD((~Hover & 1'b0) | (Hover & 1'b1)),
        .CE(frametime & ~GameOver),
        .LD((~Hover & (energy_consumed == 15'd0)) | (Hover & (energy_consumed == 15'd192))),
        .Din((~{15{Hover}} & 15'd0) | ({15{Hover}} & 15'd192)),
        .Q(energy_consumed)
    );
    
    assign lit_bar = (Hpixel >= 10'd27) && (Hpixel <= 10'd46) && (Vpixel >= (10'd39 + energy_consumed)) && (Vpixel <= (10'd230));
    assign no_energy = (energy_consumed == 15'd192);
    
endmodule
