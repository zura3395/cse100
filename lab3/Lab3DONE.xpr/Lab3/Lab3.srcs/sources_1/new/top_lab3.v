`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/26/2024 02:14:01 AM
// Design Name: 
// Module Name: top_lab3
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


module top_lab3(
    input clkin, btnR, btnU, btnC, btnL,
    input [15:0] sw,
    output [6:0] seg,
    output dp,
    output [3:0] an,
    output [15:0] led
    );
    
    labCnt_clks slowit (.clkin(clkin), .greset(btnR), .clk(clk), .digsel(digsel));
    
    wire [14:0] counter_output;
    wire [3:0] ring_output;
    wire [3:0] selected_digit;
    wire advanceCount;
    wire UTC_out, DTC_out;
    wire upD, LoD;
    wire CE, btnCE, clock_edge;
    wire alpha;

    countUD15L u_countUD15L(
        .clk(clk),
        .UD(upD),
        .CE(CE | clock_edge),
        .LD(LoD),
        .Din(sw[15:1]),
        .Q(counter_output),
        .UTC(UTC_out),
        .DTC(DTC_out)
    );
    

    edge_detector u_edge_detector(
        .clk(clk),
        .button(btnU),
        .edge_detect(CE)
    );

    ring_counter u_ring_counter(
        .clk(clk),
        .Advance(digsel),
        .Q(ring_output)
    );
    
    assign an = ~ring_output;

    selector u_selector(
        .N(counter_output),
        .sel(ring_output),
        .H(selected_digit)
    );

    hex7seg u_hex7seg(
        .n(selected_digit),
        .seg(seg)
    );
    
    FDRE #(.INIT(1'b0)) f1 (.C(clk), .R(1'b0), .CE(1'b1), .D(sw[0]), .Q(upD));
    FDRE #(.INIT(1'b0)) f2 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnL), .Q(LoD));
    FDRE #(.INIT(1'b0)) f3 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(btnCE));
    
    assign alpha = ~(&counter_output[14:2]);
    assign clock_edge = alpha & btnCE;
    
    // active low
    assign dp = 1'b1; // dp is not used, turn off
    assign led[14:1] = 1'b0; // All other LEDs off
    assign led[15] = UTC_out;
    assign led[0] = DTC_out;
    
endmodule
