`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/17/2024 05:51:36 PM
// Design Name: 
// Module Name: Lab5_shifter_sim
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


module Lab5_shifter_sim();

// Inputs
reg clkin;
reg shift_up;
reg shift_down;
reg off;

// Outputs
wire [5:0] led;
wire lastLED;
wire noLEDs;

// Instantiate the Unit Under Test (UUT)
Lab5_6bit_shifter uut (
    .clk(clkin), 
    .shift_up(shift_up),
    .shift_down(shift_down),
    .off(off), 
    .led(led), 
    .lastLED(lastLED),
    .noLEDs(noLEDs)
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
    shift_up = 0;
    shift_down = 0;
    off = 0;

    // Wait for global reset
    #100;
    
    // Shift the loaded value
//    #20; // Wait some time before starting to shift
//    shift_up = 1;
//    #160; // Shift for several cycles
//    shift_up = 0;
    
    // Shift the loaded value
    #20; // Wait some time before starting to shift
    shift_down = 1;
    #160; // Shift for several cycles
    shift_down = 0;

    // Shift the loaded value
//    #20; // Wait some time before starting to shift
//    shift_down = 1;
//    #20; // Shift for several cycles
//    shift_down = 0;
//    #10
//    shift_up = 1;
//    #30
//    shift_up = 0;
    
    // Turn off LEDs
    #20; // Wait some time before turning off
    off = 1;
    #10; // Keep off for some time
    off = 0;
    
    // Turn off LEDs
    #10; // Wait some time before turning off
    off = 1;
    #10; // Keep off for some time
    off = 0;
    
    // Finish simulation
    #100;
    $finish;
end

endmodule