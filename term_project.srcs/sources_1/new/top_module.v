`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 01:17:51 AM
// Design Name: 
// Module Name: top_module
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


module top_module(
    input clock,
    output [7:0] data,
    output enable, select, backlight
    );
    
    wire clock1hz, clock50hz;
    wire [127:0] mux_top, mux_bot;
    
    reg timeIntrup = 1;
    reg [127:0] time_top = {8'h20,8'h20,8'h31,8'h35,8'h3A,8'h34,8'h39,8'h3A,8'h32,8'h36,8'h20,8'h20,8'h20,8'h20,8'h20,8'h20};
    reg [127:0] time_bot = {8'h20,8'h20,8'h20,8'h20,8'h20,8'h20,8'h31,8'h35,8'h3A,8'h34,8'h39,8'h3A,8'h32,8'h36,8'h20,8'h20};
    
    prescaler(.clock(clock), .out1hz(clock1hz), .out50hz(clock50hz));
    display_mux(.timeIntrup(timeIntrup), .time_top(time_top), .time_bot(time_bot), .out_top(mux_top), .out_bot(mux_bot));
    display_driver(.clock(clock50hz), .in_top(mux_top), .in_bot(mux_bot), .data(data), .enable(enable), .select(select), .backlight(backlight));
endmodule
