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
    
    wire clock1hz, clock5hz, clock200hz, trigSec, trigMin, isAM, adjustedAMPM;
    wire menuIntrup, menu, snz, minus, plus, off, is24HrMode, presetampm, load;
    wire [5:0] hour, preset_hour, preset_min, timezone_hour, adjusted_hour;
    wire [5:0] minute, second;
    wire [127:0] time_top, time_bot, menu_top, menu_bot, mux_top, mux_bot;
    
    prescaler(.clock(clock), .out1hz(clock1hz), .out5hz(clock5hz), .out200hz(clock200hz));
    button_debounce(.clock(clock5hz), .menuBtn(menuBtn), .snzBtn(snzBtn), .minBtn(minBtn), .plusBtn(plusBtn), .offBtn(offBtn), .menu(menu), .snz(snz), .min(minus), .plus(plus), .off(off));
    counter60 sec(.clock(clock1hz), .out(second), .trigger(trigSec));
    counter60 min(.preset(preset_min), .load(load), .clock(trigSec), .out(minute), .trigger(trigMin));
    counter1224 (.preset(preset_hour), .presetampm(presetampm), .load(load), .clock(trigMin), .is24HrMode(is24HrMode), .out(hour), .isAM(isAM));
    timezone_control(.select(zoneSw), .out(timezone_hour), .led(led));
    timezone_adjust(.hour(hour), .selectedTime(timezone_hour), .is24HrMode(is24HrMode), .isAM(isAM), .adjustedTime(adjusted_hour), .adjustedAMPM(adjustedAMPM));
    timezone_name(.timezone(timezone_hour), .lcd_out(time_top));
    time_to_lcd(.hour(adjusted_hour), .minute(minute), .second(second), .is24HrMode(is24HrMode), .isAM(adjustedAMPM), .out(time_bot));
    display_mux(.menuIntrup(menuIntrup), .time_top(time_top), .menu_top(menu_top), .time_bot(time_bot), .menu_bot(menu_bot), .out_top(mux_top), .out_bot(mux_bot));
    display_driver(.clock(clock200hz), .in_top(mux_top), .in_bot(mux_bot), .data(data), .enable(enable), .select(select), .backlight(backlight));
    menu(.clock(clock5hz), .menuBtn(menu), .snzBtn(snz), .minBtn(minus), .plusBtn(plus), .offBtn(off), .menu_top(menu_top), .menu_bot(menu_bot), .menuIntrup(menuIntrup), .rec(rec), .is24HrMode(is24HrMode),
         .presetHour(preset_hour), .presetMin(preset_min), .presetampm(presetampm), .load(load));
endmodule
