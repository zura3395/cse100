`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/19/2024 12:09:13 AM
// Design Name: 
// Module Name: sim_halfsecMaker
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


module sim_halfsecMaker();

// Inputs
reg clkin;
reg qsec;

// Outputs
wire halfsec;

// Instantiate the Unit Under Test (UUT)
halfsecMaker uut (
    .clk(clkin),
    .shift(qsec),
    .halfsec(halfsec)
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
    qsec = 0;

    // Wait for global reset
    #100;
    
    // Test
    #10;
    qsec = 1;
    #10;
    qsec = 0;
    #10;
    qsec = 1;
    #10
    qsec = 0;
    #10
    qsec = 1;
    #10
    qsec= 0;
    
    
    // Finish simulation
    #100;
    $finish;
end

endmodule