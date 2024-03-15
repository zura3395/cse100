`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 09:56:46 AM
// Design Name: 
// Module Name: pixel_addresser
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


module pixel_addresser(
    input clk,
    
    output [9:0] Hpixel, Vpixel,
    output Hsync, Vsync,
    
    output [3:0] red, green, blue
    );
    
    wire [14:0] Hout, Vout;
    
    // count to 799 then reset by loading 0's
    countUD15L Hcounter (.clk(clk), .UD(1'b1), .CE(1'b1), .LD(Hout == 10'd799), .Din(15'd0), .Q(Hout));
    // iterate vertical by 1 when horizontal reaches 799, reset at 524
    countUD15L Vcounter (.clk(clk), .UD(1'b1), .CE(Hout == 10'd799), .LD((Vout == 10'd524) & (Hout == 10'd799)), .Din(15'd0), .Q(Vout));
    
    wire HsyncInternal, VsyncInternal;
    assign HsyncInternal = (Hout < 10'd655) || (Hout > 10'd750); // Low in 655-750
    assign VsyncInternal = (Vout < 10'd489) || (Vout > 10'd490); // Low in 489-490
    
    wire Hactive, Vactive, active;

    assign Hactive = (Hout < 10'd640); // Active in 0-639
    assign Vactive = (Vout < 10'd480); // ACtive in 0-479
    assign active  = (Hactive && Vactive);
    
    assign Hpixel = Hout;
    assign Vpixel = Vout; 
    
    wire [3:0] Rinternal, Ginternal, Binternal;
    
    assign Rinternal = 4'b1111 & {4{active}};
    assign Binternal = 4'b1111 & {4{active}};
    assign Ginternal = 4'b1111 & {4{active}};
    
    FDRE #(.INIT(1'b1) ) Hsyncer (.C(clk), .R(1'b0), .CE(1'b1), .D(HsyncInternal), .Q(Hsync));
    FDRE #(.INIT(1'b1) ) Vsyncer (.C(clk), .R(1'b0), .CE(1'b1), .D(VsyncInternal), .Q(Vsync));
    FDRE #(.INIT(1'b0) ) Rsyncer[3:0] (.C(clk), .R(1'b0), .CE(1'b1), .D(Rinternal), .Q(red));
    FDRE #(.INIT(1'b0) ) Gsyncer[3:0] (.C(clk), .R(1'b0), .CE(1'b1), .D(Ginternal), .Q(green));
    FDRE #(.INIT(1'b0) ) Bsyncer[3:0] (.C(clk), .R(1'b0), .CE(1'b1), .D(Binternal), .Q(blue));
    
endmodule
