`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 03:31:19 PM
// Design Name: 
// Module Name: top_level
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


module top_level(
    input clkin, btnL, btnR, btnU, btnC,
    input [15:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    
    wire clk, digsel, qsec, halfsec;
    wire Go, Lstop, Rstop, FourSecs, TwoSecs, Match, LlastLED, RlastLED, LnoLEDs, RnoLEDs, ShowNum, ResetTimer, RunGame, Lup, Ldown, Rup, Rdown, Lwon, Rwon, TieLoss, FlashBoth, FlashAlt, StateBit;
    FDRE #(.INIT(1'b0)) syncGo (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(Go));
    FDRE #(.INIT(1'b0)) syncLstop (.C(clk), .R(1'b0), .CE(1'b1), .D(btnL), .Q(Lstop));
    wire fakeRstop;
    FDRE #(.INIT(1'b0)) syncRstop (.C(clk), .R(1'b0), .CE(1'b1), .D(btnR), .Q(Rstop));
    
    qsec_clks slowit (.clkin(clkin), .greset(btnU), .clk(clk), .digsel(digsel), .qsec(qsec));
    
    halfsecMaker halfsec_Maker (.clk(clk), .shift(qsec), .halfsec(halfsec));
    
    wire flash;
    FDRE #(.INIT(1'b0)) flashFDRE (.C(clk), .R(1'b0), .CE(qsec), .D(qsec ^flash), .Q(flash));
    
    state_machine StateMachine (
        .clk(clk),
        .Go(Go),
        .Lstop(Lstop),
        .Rstop((sw[15] & (Rstop  | Lstop)) | (~sw[15] & Rstop)),
        .FourSecs(FourSecs),
        .TwoSecs(TwoSecs),
        .Match(Match),
        .LlastLED(LlastLED),
        .RlastLED(RlastLED),
        .LnoLEDs(LnoLEDs),
        .RnoLEDs(RnoLEDs),
        .ShowNum(ShowNum),
        .ResetTimer(ResetTimer),
        .RunGame(RunGame),
        .Lup(Lup),
        .Ldown(Ldown),
        .Rup(Rup),
        .Rdown(Rdown),
        .Lwon(Lwon),
        .Rwon(Rwon),
        .TieLoss(TieLoss),
        .FlashBoth(FlashAlt),
        .FlashAlt(FlashBoth)
    );
    
    Lab5_6bit_shifter leftLEDShifter (
        .clk(clk),
        .shift_up(Ldown),
        .shift_down(Lup),
        .off(Lwon & flash),
        .led({led[10],led[11],led[12],led[13],led[14],led[15]}), // invert LEDs for left
        .lastLED(LlastLED),
        .noLEDs(LnoLEDs)
    );
    
    Lab5_6bit_shifter rightLEDShifter (
        .clk(clk),
        .shift_up(Rdown),
        .shift_down(Rup),
        .off(Rwon & flash),
        .led(led[5:0]),
        .lastLED(RlastLED),
        .noLEDs(RnoLEDs)
    );
    
    wire [4:0] GCOut;
    Fcount Game_Counter (
        .clk(clk),
        .UD(1'b0), // always counting down
        .CE(RunGame & ((sw[14] & halfsec) | (~sw[14] & qsec))), // when sw[14] is on, use halfsec. if not, use qsec
        .LD(Go & ~RunGame & ~ShowNum),
        .Din(5'b11111),
        .Q(GCOut)
    );
    
    wire [4:0] TCOut;
    countUD5L Time_Counter (
        .clk(clk),
        .UD(1'b1), // always counting up
        .CE(~RunGame & qsec),
        .R(ResetTimer),
        .Q(TCOut)
    );
    
    assign TwoSecs = ~TCOut[4] & TCOut[3] & ~TCOut[2] & ~TCOut[1] & ~TCOut[0];
    assign FourSecs = TCOut[4] & ~TCOut[3] & ~TCOut[2] & ~TCOut[1] & ~TCOut[0];
    
    wire [4:0] randomNum;
    LFSR GameLSFR (
        .clk(clk),
        .run(~ShowNum),
        .Q(randomNum)
    );
    
    matchChecker match_Checker (.A(GCOut), .B(randomNum), .Match(Match));
   
    wire [3:0] ring_output;
    ring_counter u_ring_counter(
        .clk(clk),
        .Advance(digsel),
        .Q(ring_output)
    );
    
    wire [3:0] selected_digit;
    selector u_selector(
        .N({{3{1'b0}},randomNum, {3{1'b0}}, GCOut}),
        .sel(ring_output),
        .H(selected_digit)
    );
    
    hex7seg u_hex7seg(
        .n(selected_digit),
        .seg(seg)
    );
    
    assign an[0] = (~FlashBoth & ~FlashAlt & ~ring_output[0]) | (FlashBoth & ~FlashAlt & (flash & ~ring_output[0])) | (FlashBoth & ~FlashAlt & (~flash & 1'b1)) | (~FlashBoth & FlashAlt & (flash & ~ring_output[0])) | (~FlashBoth & FlashAlt & (~flash & 1'b1));
    assign an[1] = (~FlashBoth & ~FlashAlt & ~ring_output[1]) | (FlashBoth & ~FlashAlt & (flash & ~ring_output[1])) | (FlashBoth & ~FlashAlt & (~flash & 1'b1)) | (~FlashBoth & FlashAlt & (flash & ~ring_output[1])) | (~FlashBoth & FlashAlt & (~flash & 1'b1));
    assign an[2] = (~ShowNum) | (ShowNum & ~FlashBoth & ~FlashAlt & ~ring_output[2]) | (ShowNum & FlashBoth & ~FlashAlt & (flash & ~ring_output[2])) | (ShowNum & FlashBoth & ~FlashAlt & (~flash & 1'b1)) | (ShowNum & ~FlashBoth & FlashAlt & (flash & 1'b1)) | (ShowNum & ~FlashBoth & FlashAlt & (~flash & ~ring_output[2]));
    assign an[3] = (~ShowNum) | (ShowNum & ~FlashBoth & ~FlashAlt & ~ring_output[3]) | (ShowNum & FlashBoth & ~FlashAlt & (flash & ~ring_output[3])) | (ShowNum & FlashBoth & ~FlashAlt & (~flash & 1'b1)) | (ShowNum & ~FlashBoth & FlashAlt & (flash & 1'b1)) | (ShowNum & ~FlashBoth & FlashAlt & (~flash & ~ring_output[3]));
    assign dp    = (TieLoss & (flash & 1'b0)) | (~TieLoss & 1'b1);
    
endmodule
