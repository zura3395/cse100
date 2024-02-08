`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:  Martine
// 
// Create Date: 9/27/2022 09:26:52 PM
// Design Name: 
// Module Name: test_add
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


module test_add( ); // no inputs/outputs, this is a wrapper


// registers to hold values for the inputs to your top level
    reg [15:0] sw;
    reg btnU, btnR, clkin;
// wires to see the values of the outputs of your top level
    wire [6:0] seg;
    wire [3:0] an;
    wire dp;
    wire [15:0] led;
    
// create one instance of your top level
// and attach it to the registers and wires created above
    top_lab2 UUT (
     .sw(sw),
     .btnU(btnU),
     .btnR(btnR), 
     .clkin(clkin),
     .seg(seg),
     .an(an),
     .led(led),
     .dp(dp)
    );
    
    
// create an oscillating signal to impersonate the clock provided on the BASYS 3 board
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
	
// here is where the values for the registers are provided
// time must be advanced after every change
   initial
   begin
	 // add your test vectors here
	 // to set the signal foo (declared as a register above) to a value use
	 // foo = constant;
         // example:   foo = 1'b0;
	 // always advance time by multiples of 100ns
	 //start by setting initial values
         sw = 16'h0507;
	 btnR=1'b0;
	 btnU=1'b0;
         // and advance time by 2000 to begin
	 #2000;
         // Then new values can be provided and time advance by 100
	 #100;
	 btnU=1'b0;
	 #100;
	 btnU=1'b1;
	 sw = 16'h0280;
	 #100;
	 btnU=1'b0;
         #100;

// you will need to add more tests ....
          
    end

endmodule
