`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 02:06:34 AM
// Design Name: 
// Module Name: sim_state_machine
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


module sim_state_machine();

// Inputs
reg clkin;
reg Go;
reg stop;
reg FourSecs;
reg TwoSecs;
reg Match;
reg lastLED;

// Outputs
wire ShowNum;
wire ResetTimer;
wire RunGame;
wire Scored;
wire Won;
wire FlashBoth;
wire FlashAlt;
wire [6:0] StateBit;

state_machine uut (
    .clk(clkin),
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
    .FlashAlt(FlashAlt),
    .StateBit(StateBit)
);

parameter PERIOD = 10;
parameter real DUTY_CYCLE = 0.5;
parameter OFFSET = 2;

initial    // Clock process for clkin
begin
    #OFFSET
      clkin = 1'b1;
    forever
    begin
        #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
    end
end


initial begin
    // Initialize Inputs
    Go = 0;
    stop = 0;
    FourSecs = 0;
    TwoSecs = 0;
    Match = 0;
    lastLED = 0;

    // Wait
    #2000;

    // Test 1: Start the game
    Go = 1; #PERIOD; Go = 0;

    // Wait for display target state
    #(PERIOD * 10);
    TwoSecs = 1; #PERIOD; TwoSecs = 0; // Simulate 2 seconds elapsed

    // Countdown state begins
    #(PERIOD * 10);
    stop = 1; #PERIOD; stop = 0; // Stop the countdown

    // Check for a match (assume no match)
    #(PERIOD * 10);
    FourSecs = 1; #PERIOD; FourSecs = 0; // Simulate 4 seconds elapsed for flashing

    // Test 2: Start the game again and simulate a match
    #(PERIOD * 20); // Wait a bit before starting again
    Go = 1; #PERIOD; Go = 0;

    // Simulate match scenario
    #(PERIOD * 10);
    TwoSecs = 1; #PERIOD; TwoSecs = 0; // 2 seconds elapsed for countdown
    #(PERIOD * 5);
    stop = 1; #PERIOD; stop = 0;
    Match = 1; #PERIOD; Match = 0; // Stop the countdown with a match
    #(PERIOD * 5);
    FourSecs = 1; #PERIOD; FourSecs = 0; // Simulate 4 seconds elapsed for flashing
    
    // Test 3: Start the game again and simulate a win
    #(PERIOD * 20); // Wait a bit before starting again
    lastLED = 1;
    Go = 1; #PERIOD; Go = 0;
    
    // Simulate match scenario
    #(PERIOD * 10);
    TwoSecs = 1; #PERIOD; TwoSecs = 0; // 2 seconds elapsed for countdown
    #(PERIOD * 5);
    stop = 1;  Match = 1; #PERIOD; stop = 0;
    #PERIOD; Match = 0; // Stop the countdown with a match
    #(PERIOD * 5);
    FourSecs = 1; #PERIOD; FourSecs = 0; // Simulate 4 seconds elapsed for flashing
    
    #500;
end

endmodule
