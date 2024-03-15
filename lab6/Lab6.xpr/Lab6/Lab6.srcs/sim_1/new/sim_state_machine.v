`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/05/2024 05:15:34 AM
// Design Name: 
// Module Name: sim_state_machine
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


module sim_state_machine();

// Inputs
reg clkin;
reg Go;
reg Death;

// outputs
wire RunGame;
wire GameOver;

state_machine uut (
    .clk(clkin),
    .Go(Go),
    .Death(Death),
    .RunGame(RunGame),
    .GameOver(GameOver)
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
    Go = 0;
    Death = 0;

    // Wait
    #500;

    // Start the game
    Go = 1; #PERIOD; Go = 0;

    #(PERIOD * 20); // Wait
    
    // Death
    Death = 1; #PERIOD; Death = 0;
    
    #(PERIOD * 20); // Wait
    
    #200;
end

endmodule
