`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: Ericson Lo
// 
// Create Date: 01/26/2024 01:47:37 AM
// Design Name: 
// Module Name: edge_detector
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


module edge_detector(
    input clk,
    input button,
    output edge_detect
    );
    
    wire previous_state, current_state;
    
    FDRE #(.INIT(1'b0)) prev (.C(clk), .R(1'b0), .CE(1'b1), .D(button), .Q(previous_state));
    FDRE #(.INIT(1'b0)) curr (.C(clk), .R(1'b0), .CE(1'b1), .D(previous_state), .Q(current_state));
    
    assign edge_detect = button & ~previous_state & ~current_state;

endmodule
