`timescale 1ns / 1ps

//  alarm_overlay module
//  ->overlays a letter "A" at the top right corner of the display when the alarm is set

module alarm_overlay(
    input alarm_on,
    input [127:0] in,
    output reg [127:0] out
    );
    
    always@(*)
    begin
        if(alarm_on)        //alarm is on
            out = {in[127:8], 8'h41};   //replace the last letter on the top line with "A"
        else                //alarm is off
            out = in;       //pass through
    end
endmodule
