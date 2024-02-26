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
    input Lstop,
    input Rstop,
    input FourSecs,
    input TwoSecs,
    input Match,
    input LlastLED,
    input RlastLED,
    input LnoLEDs,
    input RnoLEDs,
    output ShowNum,
    output ResetTimer,
    output RunGame,
    output Lup,
    output Ldown,
    output Rup,
    output Rdown,
    output Lwon,
    output Rwon,
    output TieLoss,
    output FlashBoth,
    output FlashAlt,
    output [11:0] StateBit
    );
    
    wire [11:0] d;
    wire [11:0] q;
    
    FDRE #(.INIT(1'b1)) ready (.C(clk), .R(1'b0), .CE(1'b1), .D(d[0]), .Q(q[0]));
    FDRE #(.INIT(1'b0)) FFgaming [10:0] (.C(clk), .R(1'b0), .CE(1'b1), .D(d[11:1]), .Q(q[11:1]));
    
    assign d[0]  = (q[0] & ~Go) | ((q[6] | q[7]) & FourSecs & ~LlastLED & ~RlastLED & ~LnoLEDs & ~RnoLEDs); // ready 0
    assign d[1]  = (q[0] & Go) | (q[1] & ~TwoSecs);                                                         // target 1
    assign d[2]  = (q[1] & TwoSecs) | (q[2] & ~Lstop & ~Rstop);                                             // game 2
    assign d[3]  = (q[2] & Lstop & Rstop);                                                                  // checkBoth 3
    assign d[4]  = (q[2] & Lstop & ~Rstop);                                                                 // Lcheck 4
    assign d[5]  = (q[2] & ~Lstop & Rstop);                                                                 // Rcheck 5
    assign d[6]  = ((q[3] | q[4] | q[5]) & Match) | (q[6] & ~FourSecs);                                     // success 6
    assign d[7]  = ((q[3] | q[4] | q[5]) & ~Match) | (q[7] & ~FourSecs);                                    // fail 7
    assign d[8]  = ((q[6] | q[7]) & FourSecs & LlastLED & RlastLED) | (q[8]);                               // TieVictory 8
    assign d[9]  = ((q[6] | q[7]) & FourSecs & ((LlastLED & ~RlastLED) | ~LnoLEDs & RnoLEDs)) | (q[9]);     // Lvictory 9
    assign d[10] = ((q[6] | q[7]) & FourSecs & ((~LlastLED & RlastLED) | LnoLEDs & ~RnoLEDs)) | (q[10]);    // Rvictory 10
    assign d[11] = ((q[6] | q[7]) & FourSecs & (LnoLEDs & RnoLEDs)) | (q[11]);                              // TieLoss 11
    
    assign ShowNum      = ~q[0];                    // always show as long as the game isn't in "ready"
    assign ResetTimer   = (q[0] & Go) | (q[3] & Match) | (q[3] & ~Match);
    assign RunGame      = q[2];
    assign Lup          = ((q[3] | q[4]) & Match);  // checkBoth 3 or Lcheck 4
    assign Rup          = ((q[3] | q[5]) & Match);  // checkBoth 3 or RCheck 5
    assign Ldown        = ((q[3] | q[4]) & ~Match); // checkBoth 3 or Lcheck 4
    assign Rdown        = ((q[3] | q[5]) & ~Match); // checkBoth 3 or Rcheck 5
    assign FlashBoth    = q[6];                     // success 6
    assign FlashAlt     = q[7];                     // fail 7
    assign Lwon         = (q[8] | q[9]);            // TieVictory 8 or Lvictory 9
    assign Rwon         = (q[8] | q[10]);           // TieVictory 8 or Rvictory 10
    assign TieLoss      = q[11];                    // TieLoss 11
    
    assign StateBit = q;
    
endmodule
