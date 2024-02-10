`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/08/2024 04:25:13 AM
// Design Name: 
// Module Name: epicsim
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


module epicsim();

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

parameter PERIOD = 10;
parameter real DUTY_CYCLE = 0.5;
parameter OFFSET = 2;

// Instantiate the Unit Under Test (UUT)
top_level uut (
    .clkin(clkin), 
    .btnR(btnR), 
    .btnU(btnU), 
    .btnC(btnC), 
    .btnL(btnL), 
    .sw(sw), 
    .seg(seg), 
    .an(an), 
    .dp(dp), 
    .led(led)
);

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
    btnR = 0;
    btnU = 0;
    btnC = 0;
    btnL = 0;
    sw = 16'b1111111111111111;

    #2000;

    #100
    btnC = 1;
    #20;
    btnC = 0; // go

    #1000; // wait for some time to simulate game play before stopping
    btnU = 1;
    #20;
    btnU = 0; // stop
    
    #10000;
    btnL = 1; #20; btnL = 0; // cheat
    
    #200;
    $finish; // End simulation
end

endmodule
