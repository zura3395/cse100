`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 02:52:51 AM
// Design Name: 
// Module Name: LED_shifter
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


module LED_shifter(
    input clk,
    input [15:0] in,
    input LD,
    input shift,
    input off,
    output [15:0] led,
    output lastLED
    );
    
    wire [15:0] d;
    wire [15:0] q;
    
    FDRE #(.INIT(1'b0)) FF0 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) FF1 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[1]), .Q(q[1]));
    FDRE #(.INIT(1'b0)) FF2 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[2]), .Q(q[2]));
    FDRE #(.INIT(1'b0)) FF3 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[3]), .Q(q[3]));
    FDRE #(.INIT(1'b0)) FF4 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[4]), .Q(q[4]));
    FDRE #(.INIT(1'b0)) FF5 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[5]), .Q(q[5]));
    FDRE #(.INIT(1'b0)) FF6 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[6]), .Q(q[6]));
    FDRE #(.INIT(1'b0)) FF7 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[7]), .Q(q[7]));
    FDRE #(.INIT(1'b0)) FF8 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[8]), .Q(q[8]));
    FDRE #(.INIT(1'b0)) FF9 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[9]), .Q(q[9]));
    FDRE #(.INIT(1'b0)) FF10 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[10]), .Q(q[10]));
    FDRE #(.INIT(1'b0)) FF11 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[11]), .Q(q[11]));
    FDRE #(.INIT(1'b0)) FF12 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[12]), .Q(q[12]));
    FDRE #(.INIT(1'b0)) FF13 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[13]), .Q(q[13]));
    FDRE #(.INIT(1'b0)) FF14 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[14]), .Q(q[14]));
    FDRE #(.INIT(1'b0)) FF15 (.C(clk), .R(1'b0), .CE(1'b1), .D(d[15]), .Q(q[15]));
    
    assign d[0] = (LD & in[0]) | (~LD & shift & 1'b1) | (~LD & ~shift & q[0]);
    assign d[15:1] = ({15{LD}} & in[15:1]) | (~{15{LD}} & {15{shift}} & q[14:0]) | (~{15{LD}} & ~{15{shift}} & q[15:1]);
//    assign d[1] = (LD & in[1]) | (~LD & shift & q[0]) | (~LD & ~shift & q[1]);
//    assign d[2] = (LD & in[2]) | (~LD & shift & q[1]) | (~LD & ~shift & q[2]);
//    assign d[3] = (LD & in[3]) | (~LD & shift & q[2]) | (~LD & ~shift & q[3]);
//    assign d[4] = (LD & in[4]) | (~LD & shift & q[3]) | (~LD & ~shift & q[4]);
//    assign d[5] = (LD & in[5]) | (~LD & shift & q[4]) | (~LD & ~shift & q[5]);
//    assign d[6] = (LD & in[6]) | (~LD & shift & q[5]) | (~LD & ~shift & q[6]);
//    assign d[7] = (LD & in[7]) | (~LD & shift & q[6]) | (~LD & ~shift & q[7]);
//    assign d[8] = (LD & in[8]) | (~LD & shift & q[7]) | (~LD & ~shift & q[8]);
//    assign d[9] = (LD & in[9]) | (~LD & shift & q[8]) | (~LD & ~shift & q[9]);
//    assign d[10] = (LD & in[10]) | (~LD & shift & q[9]) | (~LD & ~shift & q[10]);
//    assign d[11] = (LD & in[11]) | (~LD & shift & q[10]) | (~LD & ~shift & q[11]);
//    assign d[12] = (LD & in[12]) | (~LD & shift & q[11]) | (~LD & ~shift & q[12]);
//    assign d[13] = (LD & in[13]) | (~LD & shift & q[12]) | (~LD & ~shift & q[13]);
//    assign d[14] = (LD & in[14]) | (~LD & shift & q[13]) | (~LD & ~shift & q[14]);
//    assign d[15] = (LD & in[15]) | (~LD & shift & q[14]) | (~LD & ~shift & q[15]);
    
    assign led = q & ~{16{off}};
    
    assign lastLED = q[15];
    

endmodule

