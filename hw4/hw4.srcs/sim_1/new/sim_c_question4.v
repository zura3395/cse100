`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/18/2024 05:54:56 PM
// Design Name: 
// Module Name: sim_c_question4
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


module sim_c_question4();

// Inputs
reg clkin;
reg x;

// Outputs
wire [2:0] Q;
wire z;

// Instantiate the Unit Under Test (UUT)
question4 uut (
    .clk(clkin),
    .x(x),
    .Q(Q),
    .z(z)
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
    x = 0;

    // Wait for global reset
    #100;

    #20; // Wait some time before starting
    x = 1;
    #160;
    x = 0;
    
    // Finish simulation
    #100;
    $finish;
end

endmodule
