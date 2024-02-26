`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/06/2024 11:44:05 AM
// Design Name: 
// Module Name: sim_LFSR
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


module sim_LFSR();

// Inputs
reg clkin;
reg run;

// Outputs
wire [7:0] Q;

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

// Instantiate the Unit Under Test (UUT)
LFSR uut (
    .clk(clkin),
    .run(run),
    .Q(Q)
);

initial begin
    run = 0;
    
    // Wait for global reset
    #100;

    #30
    run = 1; // Start the LFSR

    // Run for some time to observe behavior
    #500
    run = 0; // Stop the LFSR
    #10
    $finish; // End simulation
end

endmodule
