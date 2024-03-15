`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 02/22/2024 04:56:16 AM
// Design Name: 
// Module Name: lab6top_level
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


module lab6top_level(
    input clkin, btnC, btnU, btnL, btnR, btnD,
    input [15:0] sw,
    
    output [6:0] seg,
    output [3:0] an,
    output dp,
    output [15:0] led,
    
    output [3:0] vgaRed,
    output [3:0] vgaBlue,
    output [3:0] vgaGreen,
    output Hsync,
    output Vsync
    );
    
    // the clock
    wire clk, digsel;
    labVGA_clks not_so_slow (.clkin(clkin), .greset(btnD), .clk(clk), .digsel(digsel));
    
    // sync the inputs
    wire Go, Hover, Left, Right, RunGame, GameOver, Death;
    FDRE #(.INIT(1'b0) ) syncer0 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnC), .Q(Go));
    FDRE #(.INIT(1'b0) ) syncer1 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnU), .Q(Hover));
    FDRE #(.INIT(1'b0) ) syncer2 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnL), .Q(Left));
    FDRE #(.INIT(1'b0) ) syncer3 (.C(clk), .R(1'b0), .CE(1'b1), .D(btnR), .Q(Right));
    
    state_machine game (
        .clk(clk),
        .Go(Go),
        .Death(Death),
        .RunGame(RunGame),
        .GameOver(GameOver)
    );
    
    wire inLeft, inMiddle, inRight;
    
    wire [9:0] Hpixel, Vpixel;
    wire [3:0] red, blue, green;
    pixel_addresser pixels (
        .clk(clk),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .Hsync(Hsync),
        .Vsync(Vsync),
        .red(red),
        .blue(blue),
        .green(green)
    );
    
    wire frametime;
    assign frametime = (Hpixel == 10'd799) && (Vpixel == 10'd524);
    
    wire [14:0] the_time;
    countUD15L time_counter (
        .clk(clk),
        .UD(1'b1),
        .CE(RunGame & frametime & (the_time < 480)),
        .Q(the_time)
    );
    
    wire TwoSecs, SixSecsAfter;
    assign TwoSecs      = (the_time >= 120);
    assign SixSecsAfter = (the_time >= 480);
    
    wire qsec;
    lab6_qsec_clk nqrse (
        .clk(clk),
        .frametime(frametime),
        .qsec(qsec)
    );
    
    wire ten_frames;
    ten_frame_counter framer (
        .clk(clk),
        .frametime(frametime),
        .ten_frames(ten_frames)
    );
    
    wire slug_flash;
    FDRE #(.INIT(1'b0)) flashFDRE (.C(clk), .R(1'b0), .CE(ten_frames), .D(ten_frames ^ slug_flash), .Q(slug_flash));
    
    wire lit_border;
    border the_border (
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .lit_border(lit_border)
    );
    
    wire lit_bar, no_energy;
    energy_bar the_bar (
        .clk(clk),
        .GameOver(GameOver),
        .frametime(frametime),
        .Hover(Hover & inMiddle),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .lit_bar(lit_bar),
        .no_energy(no_energy)
    );
    
    wire GoLeft, GoRight;
    slug_states movement (
        .clk(clk),
        .Left(Left),
        .Right(Right),
        .inLeft(inLeft),
        .inMiddle(inMiddle),
        .inRight(inRight),
        .GoLeft(GoLeft),
        .GoRight(GoRight)
    );
    
    wire lit_slug;
    slug the_slug (
        .clk(clk),
        .GameOver(GameOver),
        .frametime(frametime),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .Left(GoLeft),
        .Right(GoRight),
        .flash((~no_energy & Hover & slug_flash & inMiddle) | (GameOver & slug_flash)),
        .lit_slug(lit_slug),
        .inLeft(inLeft),
        .inMiddle(inMiddle),
        .inRight(inRight)
    );
    
    wire lit_middle_train1, lit_middle_train2;
    wire [7:0] Lscore, Mscore, Rscore;
    train_track middle_trains (
        .clk(clk),
        .RunGame(RunGame & SixSecsAfter),
        .GameOver(GameOver),
        .frametime(frametime),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .Hleft(10'd405),
        .spawn_offset(10'd40), // middle track needs 440
        .lit_train1(lit_middle_train1),
        .lit_train2(lit_middle_train2),
        .score(Mscore)
    );
    
    wire lit_left_train1, lit_left_train2, score_up_left;
    train_track_sigma left_trains (
        .clk(clk),
        .RunGame(RunGame),
        .GameOver(GameOver),
        .frametime(frametime),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .Hleft(10'd335),
        .spawn_offset(10'd0),
        .lit_train1(lit_left_train1),
        .lit_train2(lit_left_train2),
        .score(Lscore)
    );
    
    wire lit_right_train1, lit_right_train2, score_up_right;
    train_track_delta right_trains (
        .clk(clk),
        .RunGame(RunGame & TwoSecs),
        .GameOver(GameOver),
        .frametime(frametime),
        .Hpixel(Hpixel),
        .Vpixel(Vpixel),
        .Hleft(10'd475),
        .spawn_offset(10'd0),
        .lit_train1(lit_right_train1),
        .lit_train2(lit_right_train2),
        .score(Rscore)
    );
    
    wire Crash;
    assign Crash = (lit_middle_train1 | lit_middle_train2 | lit_left_train1 | lit_left_train2 | lit_right_train1 | lit_right_train2) & lit_slug;
    assign Death = Crash & ~sw[3] & (~Hover | no_energy);
    
    assign vgaRed = red & ({4{lit_border}} | {4{lit_slug}});
    assign vgaGreen = green & ({4{lit_border}} | (~{4{~GameOver & Hover & inMiddle}} & {4{lit_slug}}) | {4{lit_bar}});
    assign vgaBlue = blue & ({4{lit_border}} | {4{lit_middle_train1}} | {4{lit_middle_train2}} | {4{lit_left_train1}} | {4{lit_left_train2}} | {4{lit_right_train1}} | {4{lit_right_train2}} | (~{4{no_energy}} & {4{~GameOver & Hover & inMiddle}} & {4{lit_slug}}) );
    
    wire [7:0] total_score;
    assign total_score = Lscore + Mscore + Rscore;
    
    // 7 segment display outputs
    wire [3:0] ring_output;
    ring_counter u_ring_counter(
        .clk(clk),
        .Advance(digsel),
        .Q(ring_output)
    );
    
    assign an[1:0] = ~ring_output;
    assign an[3:2] = {2{1'b1}};
    
    wire [3:0] selected_digit;
    selector u_selector(
        .N(total_score),
        .sel(ring_output),
        .H(selected_digit)
    );
    
    hex7seg u_hex7seg(
        .n(selected_digit),
        .seg(seg)
    );
    
    assign dp = 1'b1;
    assign led[0] = GoRight;
    assign led[1] = Hover & inMiddle;
    assign led[2] = GoLeft;
    assign led[3] = sw[3];
    assign led[4] = 1'b0;
    assign led[5] = Hover;
    assign led[6] = no_energy;
    assign led[7] = RunGame;
    assign led[8] = GameOver;
    assign led[9] = 1'b0;
    assign led[10] = inRight;
    assign led[11] = inMiddle;
    assign led[12] = inLeft;
    assign led[13] = 1'b0;
    assign led[14] = Crash;
    assign led[15] = Death;
    
endmodule
