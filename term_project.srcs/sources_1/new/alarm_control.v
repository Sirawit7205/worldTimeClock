`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2018 12:17:29 AM
// Design Name: 
// Module Name: alarm_control
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


module alarm_control(
    input clock,
    input [4:0] ref_hour,
    input [5:0] ref_min,
    input [4:0] set_hour,
    input [5:0] set_min,
    input ref_ampm, set_ampm,
    input on, is24HrMode,
    input off_btn, snooze_btn,
    output play_sound,
    output light, backlight
    );
    
    reg [5:0] snooze_min = 0;
    reg [4:0] snooze_hour = 0;
    reg [2:0] stage = 0;
    reg alarm_trig = 0;
    
    play_alarm play(.clock(clock), .trig(alarm_trig), .play_sound(play_sound), .light(light), .backlight(backlight));
    
    //if the time changes
    always@(posedge clock)
    begin
        //check if the alarm is set
        if(on)
        begin
            case(stage)
                2'b00: begin
                    if(is24HrMode)
                        if(ref_hour == set_hour && ref_min == set_min) stage <= 2'b01;
                    else
                        if(ref_hour == set_hour && ref_min == set_min && ref_ampm == set_ampm) stage <= 2'b01;
                end
                2'b01: begin
                    if(snooze_btn) stage <= 2'b10;
                    else if(off_btn) stage <= 2'b00;
                end
                2'b10: stage <= 2'b11;
                2'b11: begin
                    if(ref_hour == set_hour + snooze_hour && ref_min == set_min + snooze_min) stage <= 2'b01;
                end
            endcase
        end
    end
    
    
    always@(posedge clock)
    begin
        if(on)
        begin
            case(stage)
                2'b00: begin
                    snooze_hour <= 0;
                    snooze_min <= 0;
                    alarm_trig <= 0;
                end
                2'b01: begin
                    alarm_trig <= 1;
                end
                2'b10: begin
                    //code for snoozing
                    if(ref_min + 5 < 60)
                    begin
                        snooze_min <= ref_min + 5;
                        snooze_hour <= 0;
                        alarm_trig <= 0;
                    end
                    
                    else
                    begin
                        snooze_min <= ref_min - 55;
                        snooze_hour <= 1;
                    end
                end
            endcase
        end
    end
endmodule

module play_alarm(
    input clock,
    input trig,
    output reg play_sound,
    output reg light, backlight
);
    reg stage = 0;
    
    always@(posedge clock)
    begin
        if(trig)
        begin
            if(stage == 0)
            begin
                stage <= 1;
                play_sound = 1;
                light = 1;
                backlight = 1;
            end
            
            else
            begin
                stage <= 0;
                play_sound = 0;
                light = 0;
                backlight = 0;
            end
        end

        else
        begin
            stage <= 0;
            play_sound = 0;
            light = 0;
            backlight = 1;   
        end
    end
endmodule
