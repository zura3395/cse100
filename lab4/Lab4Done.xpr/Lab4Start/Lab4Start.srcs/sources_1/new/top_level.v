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
    input clkin, btnR, btnU, btnC, btnL,
    input [15:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    
    wire clk, digsel, qsec;
    wire FourSecs, TwoSecs, Match, lastLED, ShowNum, ResetTimer, RunGame, Scored, Won, FlashBoth, FlashAlt;
    
    wire Go, stop, load;
    FDRE #(.INIT(1'b0)) syncGo (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(Go));
    FDRE #(.INIT(1'b0)) syncStop (.C(clk), .R(1'b0), .CE(1'b1), .D(btnU), .Q(stop));
    FDRE #(.INIT(1'b0)) syncLoad (.C(clk), .R(1'b0), .CE(1'b1), .D(btnL), .Q(load));
    
    qsec_clks slowit (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel), .qsec(qsec));
    
    wire flash;
    FDRE #(.INIT(1'b0)) flashFDRE (.C(clk), .R(1'b0), .CE(qsec), .D(qsec ^flash), .Q(flash));
    
    state_machine StateMachine (
        .clk(clk),
        .Go(Go),
        .stop(stop),
        .FourSecs(FourSecs),
        .TwoSecs(TwoSecs),
        .Match(Match),
        .lastLED(lastLED),
        .ShowNum(ShowNum),
        .ResetTimer(ResetTimer),
        .RunGame(RunGame),
        .Scored(Scored),
        .Won(Won),
        .FlashBoth(FlashBoth),
        .FlashAlt(FlashAlt)
    );
    
    LED_shifter LEDShifter (
        .clk(clk),
        .in(sw),
        .LD(load),
        .shift(Scored),
        .off(Won & flash),
        .led(led),
        .lastLED(lastLED)
    );
    
    wire [4:0] GCOut;
    
    Fcount Game_Counter (
        .clk(clk),
        .UD(1'b0), // always counting down
        .CE(RunGame & qsec),
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
    
    wire [4:0] xor_result;
    assign xor_result[0] = GCOut[0] ^ randomNum[0];
    assign xor_result[1] = GCOut[1] ^ randomNum[1];
    assign xor_result[2] = GCOut[2] ^ randomNum[2];
    assign xor_result[3] = GCOut[3] ^ randomNum[3];
    assign xor_result[4] = GCOut[4] ^ randomNum[4];
    wire or_result;
    assign or_result = xor_result[0] | xor_result[1] | xor_result[2] | xor_result[3] | xor_result[4];
    assign Match = ~RunGame & ~or_result;
   
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
    assign dp = 1'b1; // dp is not used, turn off
    
endmodule
