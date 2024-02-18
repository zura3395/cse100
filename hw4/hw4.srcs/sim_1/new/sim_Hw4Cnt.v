`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 03:20:01 AM
// Design Name: 
// Module Name: sim_Hw4Cnt
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


module sim_Hw4Cnt();

// Inputs
reg clkin;
reg CE;

// Outputs
wire [2:0] B;
wire TC;

// Instantiate the Unit Under Test (UUT)
Hw4Cnt uut (
    .clk(clkin),
    .CE(CE),
    .B(B),
    .TC(TC)
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
    CE = 0;

    // Wait for global reset
    #100;

    #20; // Wait some time before starting
    CE = 1;
    #160;
    CE = 0;
    
    // Finish simulation
    #100;
    $finish;
end

endmodule
