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
    input [15:0] zoneSw,
    input menuBtn, snzBtn, minBtn, plusBtn, offBtn,
    input clock,
    output [15:0] led,
    output [7:0] data,
    output enable, select, rec, play, light, backlight
    );
    
    wire clock1hz, clock50hz, trigSec, trigMin, isAM;
    wire [4:0] hour, timezone_hour, adjusted_hour;
    wire [5:0] minute, second;
    wire [127:0] time_bot, mux_top, mux_bot;
    
    reg timeIntrup = 1, is24HrMode = 1;
    reg [127:0] time_top = {8'h54, 8'h45, 8'h53, 8'h54, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
    
    prescaler(.clock(clock), .out1hz(clock1hz), .out50hz(clock50hz));
    counter60 sec(.clock(clock1hz), .out(second), .trigger(trigSec));
    counter60 min(.clock(trigSec), .out(minute), .trigger(trigMin));
    counter1224 (.clock(trigMin), .is24HrMode(is24HrMode), .out(hour), .isAM(isAM));
    timezone_control(.select(zoneSw), .out(timezone_hour), .led(led));
    timezone_adjust(.hour(hour), .selectedTime(timezone_hour), .is24HrMode(is24HrMode), .adjustedTime(adjusted_hour));
    time_to_lcd(.hour(hour), .minute(minute), .second(second), .is24HrMode(is24HrMode), .isAM(isAM), .out(time_bot));
    display_mux(.timeIntrup(timeIntrup), .time_top(time_top), .time_bot(time_bot), .out_top(mux_top), .out_bot(mux_bot));
    display_driver(.clock(clock50hz), .in_top(mux_top), .in_bot(mux_bot), .data(data), .enable(enable), .select(select), .backlight(backlight));
endmodule
