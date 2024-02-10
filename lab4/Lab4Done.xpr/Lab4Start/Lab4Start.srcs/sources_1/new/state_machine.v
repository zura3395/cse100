`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 01:21:57 AM
// Design Name: 
// Module Name: state_machine
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


module state_machine(
    input clk,
    input Go,
    input stop,
    input FourSecs,
    input TwoSecs,
    input Match,
    input lastLED,
    output ShowNum,
    output ResetTimer,
    output RunGame,
    output Scored,
    output Won,
    output FlashBoth,
    output FlashAlt,
    output [6:0] StateBit
    );
    
    wire [6:0] d;
    wire [6:0] q;
    
    FDRE #(.INIT(1'b1)) ready (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) target (.C(clk), .R(1'b0), .CE(1'b1), .D(d[1]), .Q(q[1]));
    FDRE #(.INIT(1'b0)) game (.C(clk), .R(1'b0), .CE(1'b1), .D(d[2]), .Q(q[2]));
    FDRE #(.INIT(1'b0)) check (.C(clk), .R(1'b0), .CE(1'b1), .D(d[3]), .Q(q[3]));
    FDRE #(.INIT(1'b0)) success (.C(clk), .R(1'b0), .CE(1'b1), .D(d[4]), .Q(q[4]));
    FDRE #(.INIT(1'b0)) fail (.C(clk), .R(1'b0), .CE(1'b1), .D(d[5]), .Q(q[5]));
    FDRE #(.INIT(1'b0)) victory (.C(clk), .R(1'b0), .CE(1'b1), .D(d[6]), .Q(q[6]));
    
    assign d[0] = (q[0] & ~Go) | (FourSecs & ~lastLED); // ready
    assign d[1] = (q[0] & Go) | (q[1] & ~TwoSecs); // target
    assign d[2] = (q[1] & TwoSecs) | (q[2] & ~stop); // game
    assign d[3] = (q[2] & stop); // check
    assign d[4] = (q[3] & Match) | (q[4] & ~FourSecs); // success
    assign d[5] = (q[3] & ~Match) | (q[5] & ~FourSecs); // fail
    assign d[6] = (q[4] & FourSecs & lastLED) | (q[6]); // victory
    
    assign ShowNum = q[1] | q[2] | q[3] | q[4] | q[5] | q[6];
    assign ResetTimer = (q[0] & Go) | (q[3] & Match) | (q[3] & ~Match);
    assign RunGame = q[2];
    assign Scored = q[3] & Match;
    assign Won = q[6];
    assign FlashBoth = q[4];
    assign FlashAlt = q[5];
    
    assign StateBit = q;
    
endmodule
