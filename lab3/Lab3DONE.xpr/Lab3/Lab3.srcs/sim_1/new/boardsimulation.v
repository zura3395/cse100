`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/28/2024 02:07:35 PM
// Design Name: 
// Module Name: boardsimulation
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


module boardsimulation();

parameter PERIOD = 10;
parameter real DUTY_CYCLE = 0.5;
parameter OFFSET = 2;

// Inputs
reg clkin;
reg btnR;
reg btnU;
reg btnC;
reg btnL;
reg [15:0] sw;

// Outputs
wire [6:0] seg;
wire dp;
wire [3:0] an;
wire [15:0] led;

// Instantiate the Unit Under Test (UUT)
top_lab3 uut (
    .clkin(clkin), 
    .btnR(btnR), 
    .btnU(btnU), 
    .btnC(btnC), 
    .btnL(btnL), 
    .sw(sw), 
    .seg(seg), 
    .dp(dp), 
    .an(an), 
    .led(led)
);

initial    // Clock process for clkin
begin
    #OFFSET
    clkin = 1'b1;
    forever
    begin
        #(PERIOD - (PERIOD * DUTY_CYCLE)) clkin = ~clkin;
    end
end

// Test sequence
initial begin
    // Initialize Inputs
    btnR = 0;
    btnU = 0;
    btnC = 0;
    btnL = 0;
    sw = 0;

    // Wait for 1000ns for global reset to finish
    #1000;
    
    // Test btnU functionality
    btnU = 1; #300; // Held high for 300ns
    btnU = 0; #400;

    // Test btnC functionality
    btnC = 1; #500; // Held high for 500ns
    btnC = 0; #200; // Held low for 200ns
    btnC = 1; #300; // Held high again for 300ns
    btnC = 0; #400;

    // More tests can be added here

    // Finish the simulation
    #1000;
    $finish;
end

endmodule
