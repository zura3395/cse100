`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/07/2024 03:25:25 AM
// Design Name: 
// Module Name: train_track_delta
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


module train_track_delta(

    input clk,
    input RunGame,
    input GameOver,
    input frametime,
    input [9:0] Hpixel,
    input [9:0] Vpixel,
    input [9:0] Hleft,
    input [9:0] spawn_offset,
    
    output lit_train1,
    output lit_train2,
    output [7:0] score
    );
    
    wire [9:0] top1, bottom1, top2, bottom2;
    wire [5:0] random_length1, random_length2;
    wire [6:0] random_delay1, random_delay2;
    
    countUD15L bottom_counter1 (
        .clk(clk),
        .UD(1'b1),
        .CE(RunGame & frametime),
        .LD((bottom2 == (10'd400 + spawn_offset + random_delay1)) & (top1 >= 479)),
        .Din(15'd0),
        .Q(bottom1)
    );
    
    countUD15L top_counter1 (
        .clk(clk),
        .UD(1'b1),
        .CE(RunGame & frametime & (bottom1 >= 10'd60 + random_length1)),
        .LD((bottom2 == (10'd400 + spawn_offset + random_delay1)) & (top1 >= 479)),
        .Din(15'd0),
        .Q(top1)
    );
    
    countUD15L bottom_counter2 (
        .clk(clk),
        .UD(1'b1),
        .CE(RunGame & frametime & ((bottom1 >= (10'd400 + spawn_offset)) | (bottom2 > 0))),
        .LD((bottom1 == (10'd400 + spawn_offset + random_delay2)) & (top2 >= 479)),
        .Din(15'd0),
        .Q(bottom2)
    );
    
    countUD15L top_counter2 (
        .clk(clk),
        .UD(1'b1),
        .CE(RunGame & frametime & (bottom2 >= 10'd60 + random_length2)),
        .LD((bottom1 == (10'd400 + spawn_offset + random_delay2)) & (top2 >= 479)),
        .Din(15'd0),
        .Q(top2)
    );
    
    wire [7:0] random_num1, random_num2;
    LFSRgamma num_generator1(
        .clk(clk),
        .run((~RunGame & ~GameOver) | (top1 == 10'd479)),
        .Q(random_num1)
    );
    
    LFSRalpha num_generator2(
        .clk(clk),
        .run((~RunGame & ~GameOver) | (top2 == 10'd479)),
        .Q(random_num2)
    );
    
    assign random_length1   = random_num1;
    assign random_length2   = random_num2;
    assign random_delay1    = random_num1;
    assign random_delay2    = random_num2;
    
    wire score_up;
    assign score_up = (top1 == 10'd375) | (top2 == 10'd375);
    countUD15L score_counter (
        .clk(clk),
        .UD(1'b1),
        .CE(frametime & score_up),
        .Q(score)
    );
    
    assign lit_train1 = (Hpixel >= Hleft) && (Hpixel <= (Hleft + 10'd59)) && (Vpixel >= top1) && (Vpixel <= bottom1);
    assign lit_train2 = (Hpixel >= Hleft) && (Hpixel <= (Hleft + 10'd59)) && (Vpixel >= top2) && (Vpixel <= bottom2);
endmodule
