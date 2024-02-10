`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 03:39:35 AM
// Design Name: 
// Module Name: sim_shifter
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


module sim_shifter();

// Inputs
reg clkin;
reg [15:0] in;
reg LD;
reg shift;
reg off;

// Outputs
wire [15:0] led;
wire lastLED;

// Instantiate the Unit Under Test (UUT)
LED_shifter uut (
    .clk(clkin), 
    .in(in), 
    .LD(LD), 
    .shift(shift), 
    .off(off), 
    .led(led), 
    .lastLED(lastLED)
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
    in = 0;
    LD = 0;
    shift = 0;
    off = 0;

    // Wait for global reset
    #100;
    
        // Load cheat
//    LD = 1;
//    in = 16'b1111111111111111;
//    #10; // Apply for at least one clock cycle
//    LD = 0;
    
    // Shift the loaded value
    #20; // Wait some time before starting to shift
    shift = 1;
    #160; // Shift for several cycles
    shift = 0;
    
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
