`timescale 1ns / 1ps

//  alarm_control module
//  ->compares alarm time to the current time, if matches, will trigger play module
//  ->the alarm can be snoozed, then it will activate again in 5 minutes

module alarm_control(
    input clock, on, is24HrMode,
    input [5:0] ref_hour, ref_min, set_hour, set_min,
    input ref_ampm, set_ampm,
    input off_btn, snooze_btn,
    output play_sound, light, backlight
    );
    
    reg [5:0] snooze_min = 0;
    reg [5:0] snooze_hour = 0;
    reg [2:0] stage = 0;
    reg alarm_trig = 0;
    
    //connects to play module
    play_alarm play(.clock(clock), .trig(alarm_trig), .play_sound(play_sound), .light(light), .backlight(backlight));
    
    //change state
    always@(posedge clock)
    begin
        //check if the alarm is set
        if(on)
        begin
            case(stage)
                3'b000: begin               //idle
                    
                    //check if current time matches set time
                    //24 hours mode
                    if(is24HrMode)
                    begin
                        if(ref_hour == set_hour && ref_min == set_min) stage <= 3'b001;
                    end
                    
                    //12 hours mode
                    else
                    begin
                        if(ref_hour == set_hour && ref_min == set_min && ref_ampm == set_ampm) stage <= 3'b001;
                    end
                end
                3'b001: begin               //alarm
                    if(snooze_btn) stage <= 3'b010;     //snooze
                    else if(off_btn) stage <= 3'b100;   //off
                end
                3'b010: stage <= 3'b011;    //set snooze time
                3'b011: begin               //snooze
                    if(ref_hour == snooze_hour && ref_min == snooze_min) stage <= 3'b001;
                end
                3'b100: begin               //returning to idle
                    if(ref_min != set_min) stage <= 3'b000;     //prevents re-triggering
                end
            endcase
        end
    end
    
    //output from state machine
    always@(posedge clock)
    begin
        //check if the alarm is set
        if(on)
        begin
            case(stage)
                3'b000: begin           //idle
                    snooze_hour <= 0;   //reset snooze time       
                    snooze_min <= 0;
                end
                3'b001: begin           //alarm
                    alarm_trig <= 1;    //set alarm flag
                end
                3'b010: begin           //set snooze time
                    if(ref_min + 5 < 60)            //snooze time doesn't overflow 
                    begin
                        snooze_min = ref_min + 5;
                        snooze_hour = ref_hour;
                    end
                    
                    else    //snooze time is overflowing to the next hour
                    begin
                        snooze_min = 0;
                        snooze_hour = ref_hour + 1;
                    end
                    
                    alarm_trig <= 0;    //reset alarm flag
                end
                3'b100:begin            //returning to idle
                    alarm_trig <= 0;    //reset alarm flag
                end
            endcase
        end
    end
endmodule

//  play_alarm module
//  ->when triggered, will send a pulse to alarm light, display backlight, and voice IC

module play_alarm(
    input clock, trig,
    output reg play_sound, light, backlight
);
    reg stage = 0;
    
    always@(posedge clock)
    begin
        //trigger is on
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
        
        //trigger is off
        else
        begin
            stage <= 0;
            play_sound = 0;
            light = 0;
            backlight = 1;   
        end
    end
endmodule
