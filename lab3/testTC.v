`timescale 1ns/1ps
// Verilog code to test UTC and DTC of your 15 bit counter
// Winter 2024



module testTC();
  reg clkin, btnR, btnC, btnU, btnL;
  reg [15:0] sw;
  wire [15:0] led;
  wire [6:0] seg;
  wire [3:0] an;
  wire dp, UTC, DTC;
  
  top_lab3 // replace with your top level module's name
   UUT (
      .clkin(clkin),
      .btnR(btnR),
      .btnU(btnU),
 //     .btnD(btnD),
      .btnL(btnL),
      .btnC(btnC),
      .sw(sw),
      .seg(seg),
      .dp(dp),
      .led(led),
      .an(an)
      );   

integer TX_ERROR = 0;
    assign UTC = led[15];
    assign DTC = led[0];	

// Run this simulation for 2ms. If correct, TX_ERROR should be 0 at the end.
// UTC should go high near 1335us and then low at 1336us. 
// There should be several more transitions on UTC and TDC after that until 1341us. 

    parameter PERIOD = 10;
    parameter real DUTY_CYCLE = 0.5;
    parameter OFFSET = 2;
	 

	initial    // Clock process for clkin
	begin
	  btnC = 1'bx;
	  btnR = 1'b0;
	  btnU = 1'bx;
//	  btnD = 1'bx;
	  btnL = 1'bx;
    
       #OFFSET
		clkin = 1'b1;
       forever
         begin
            #(PERIOD-(PERIOD*DUTY_CYCLE)) clkin = ~clkin;
         end
	  end
	
	initial
	begin
     #2000;
	 btnC=1'b0;
	 btnU=1'b0;
//	 btnD=1'b0;
	 btnL=1'b0;
	 btnR=1'b0;
	 sw = 16'h9035;
	 #200;
	 btnR = 1'b1;
	 #500 btnR = 1'b0;
	 #300 sw[0] = 1'b1; btnC=1'b1;
	 btnR = 1'b0;
	 #1330000 btnC=1'b0;
	 #200; sw[0] = 1'b1; btnU=1'b1;
	 #600; btnU=1'b0;
	 #200; sw[0] = 1'b1; btnU=1'b1;
	 #700; btnU=1'b0;
	 #200; sw[0] = 1'b1; btnU=1'b1;
	 #800; btnU=1'b0;
	 CHECK_UTC(1'b1); CHECK_DTC(1'b0);
	 #400;
	 CHECK_UTC(1'b1); CHECK_DTC(1'b0);
	 #200; 
	 sw[0] = 1'b1; btnU=1'b1;
	 #200; 
	 btnU=1'b0;
	 #100;
	 CHECK_UTC(1'b0); CHECK_DTC(1'b1);
	 #200; btnU=1'b0;
	 #200; sw[0] = 1'b1; btnU=1'b1;
	 #100 btnU=1'b0;
	 CHECK_UTC(1'b0);  CHECK_DTC(1'b0);
	 #300 sw[0] = 1'b0; btnU =1'b1;  //btnD=1'b1;
	 #200;
	 CHECK_UTC(1'b0);  CHECK_DTC(1'b1);
//	 #200; btnD=1'b0;
//     #200; btnD=1'b1;
     #200 btnU =1'b0; 
     #200 sw[0] = 1'b0;  btnU =1'b1;  
	 #200;
     #100;
	 CHECK_UTC(1'b1); CHECK_DTC(1'b0);
	 #200; btnU=1'b0;
     #200; btnU=1'b1;
     #100;
     CHECK_UTC(1'b0); CHECK_DTC(1'b0);
     #200; btnU=1'b0;
     #200; sw[0] = 1'b1; btnU=1'b1;
     #100;
     CHECK_UTC(1'b1); CHECK_DTC(1'b0);
     #200; btnU=1'b0;
     #200; sw[0] = 1'b1; btnU=1'b1;
     #100  btnU=1'b0;
     CHECK_UTC(1'b0); CHECK_DTC(1'b1);
     #100;
     #200; sw[0] = 1'b0; btnU=1'b1;
     #100  btnU=1'b0;;
     CHECK_UTC(1'b1); CHECK_DTC(1'b0);
     #200; sw[0] = 1'b0; btnU=1'b1;
     #100  btnU=1'b0;;
     CHECK_UTC(1'b0); CHECK_DTC(1'b0);
     #200; sw = 16'h0003; btnU=1'b1;
     btnL=1'b1;
     #100 btnL=1'b0;  btnU=1'b0;
     CHECK_UTC(1'b0); CHECK_DTC(1'b0);
     #200; sw = 16'h0; btnU=1'b1;
     #100  btnU=1'b0;
     CHECK_UTC(1'b0); CHECK_DTC(1'b1);
     #100 btnU=1'b0;
     #200; sw[0] = 1'b0; btnU=1'b1;
     btnL=1'b1;
     #100 btnL=1'b0;  btnU=1'b0;
     #100  btnU=1'b0;
     CHECK_UTC(1'b0); CHECK_DTC(1'b1);
	end
	
	task CHECK_UTC;
        input good_TC;

        #0 begin
            if (good_TC !== UTC) begin
                TX_ERROR = TX_ERROR + 1;
            end
        end
    endtask
    
	task CHECK_DTC;
        input good_TC;
    
       #0 begin
           if (good_TC !== DTC) begin
               TX_ERROR = TX_ERROR + 1;
           end
       end
    endtask
        
endmodule

