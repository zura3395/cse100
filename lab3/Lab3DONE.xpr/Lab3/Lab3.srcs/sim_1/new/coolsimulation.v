`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 01/24/2024 06:18:23 PM
// Design Name: 
// Module Name: coolsimulation
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


module coolsimulation();

    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;

    // Inputs
    reg clkin;
    reg UD;
    reg CE;
    reg LD;
    reg [4:0] Din;

    // Outputs
    wire [4:0] Q;
    wire UTC;
    wire DTC;

    // Instantiate the Unit Under Test (UUT)
    countUD5L uut (
        .clk(clkin), 
        .UD(UD), 
        .CE(CE), 
        .LD(LD), 
        .Din(Din), 
        .Q(Q), 
        .UTC(UTC), 
        .DTC(DTC)
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

    initial begin
        // Initialize Inputs
        UD = 0;
        CE = 0;
        LD = 0;
        Din = 0;

        // Wait 100 ns for global reset to finish
        #100;
        
        // Add stimulus here

        // Load a value
        LD = 1'b1;
        Din = 5'b11111;
        #20;
        LD = 1'b0;
        
        #50

        // Count up to see if it goes from 11111 to 00000
        CE = 1'b1;
        UD = 1'b1; // Count up
        #50; // Wait for a few clock cycles
        
        // Load a value
        LD = 1'b1;
        Din = 5'b00000;
        #10;
        LD = 1'b0;

        // Count down to see if it goes from 00000 to 11111
        UD = 1'b0; // Count down
        #50; // Wait for a few clock cycles

        // Disable counting
        CE = 1'b0;
        #20;

        // Count again
        CE = 1'b1;
        UD = 1'b1;

        // Finish the simulation
        #100;
        $finish;
    end
      
endmodule
