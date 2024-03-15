`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/06/2024 11:27:59 PM
// Design Name: 
// Module Name: sim_slug_states
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


module sim_slug_states();

// Inputs
reg clkin;
reg Left;
reg Right;
reg inLeft;
reg inMiddle;
reg inRight;

// outputs
wire GoLeft, GoRight;

slug_states uut (
    .clk(clkin),
    .Left(Left),
    .Right(Right),
    .inLeft(inLeft),
    .inMiddle(inMiddle),
    .inRight(inRight),
    .GoLeft(GoLeft),
    .GoRight(GoRight)
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
    Left = 0;
    Right = 0;
    inLeft = 0;
    inMiddle = 0;
    inRight = 0;
    
    // Wait
    #200;

    Right = 1; #200; Right = 0;
    #(PERIOD * 10); // Wait
    inRight = 1;
    
    #(PERIOD * 10); // Wait
    
    Left = 1; #PERIOD; inRight = 0; #200; Left = 0;
    #(PERIOD * 10); // Wait
    inMiddle = 1; #PERIOD;
    
    #(PERIOD * 10); // Wait
    
    Left = 1; #PERIOD; inMiddle = 0; #200; Left = 0;
    #(PERIOD * 10); // Wait
    inLeft = 1;
    
    #(PERIOD * 10); // Wait
    
    Right = 1; #PERIOD; inLeft = 0; #200; Right = 0;
    #(PERIOD * 10); // Wait
    inMiddle = 1; #PERIOD;
    
    #200;
end

endmodule

