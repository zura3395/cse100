`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/16/2024 11:43:47 AM
// Design Name: 
// Module Name: TopLevel
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


module TopLevel(
    input [15:0] sw,
    input btnU,
    input btnR,
    input clkin,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    
    wire [7:0] sum;
    wire [6:0] lower_seg, upper_seg;
    wire ovfl;
    
    // Step 4
    assign led = sw;
    AddSub8 theAdder (.A(sw[7:0]), .B(sw[15:8]), .sub(btnU), .S(sum), .ovfl(ovfl));
    
    hex7seg lower (.n(sum[3:0]), .seg(lower_seg)); // Step 5
    hex7seg upper (.n(sum[7:4]), .seg(upper_seg)); // step 5
    
    // Step 6
    wire dig_sel;
    
    mux2to1_8bit mux_dig_sel (
        .s(dig_sel),
        .i0(lower_seg),
        .i1(upper_seg),
        .y(seg)
    );
    
    // Step 7
    assign an[0] = dig_sel;  // Active low, display on when dig_sel is 1
    assign an[1] = ~dig_sel;   // Active low, display on when dig_sel is 0
    
    
    
    // Step 8
    assign an[2] = 1;      // Other displays off
    assign an[3] = 1;
    
    // Step 9 and 10
    lab2_digsel my_digsel (.clkin(clkin), .greset(btnR), .digsel(dig_sel)); // For display frequency
    
    assign dp = ~ovfl; // Active low, on when overflow occurs
    
endmodule
