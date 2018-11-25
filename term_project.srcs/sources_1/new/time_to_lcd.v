`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2018 04:12:46 PM
// Design Name: 
// Module Name: timetocal
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


module time_to_lcd(
    input [4:0] hour,
    input [5:0] minute,
    input [5:0] second,
    input is24HrMode,
    input isAM,
    output reg [127:0] out
    );
    wire [3:0] tempHourL, tempHourR, tempMinuteL, tempMinuteR ,tempSecondL ,tempSecondR;
    wire [7:0] hourL, hourR, minuteL, minuteR, secondL, secondR;
    
    //extract each digit
    assign tempHourL = hour / 10;
    assign tempHourR = hour % 10;
    assign tempMinuteL = minute / 10;
    assign tempMinuteR = minute % 10;
    assign tempSecondL = second / 10;
    assign tempSecondR = second % 10;
    
    //convert to charcode
    number_to_charcode inst1(.in(tempHourL), .out(hourL));
    number_to_charcode inst2(.in(tempHourR), .out(hourR));
    number_to_charcode inst3(.in(tempMinuteL), .out(minuteL));
    number_to_charcode inst4(.in(tempMinuteR), .out(minuteR));
    number_to_charcode inst5(.in(tempSecondL), .out(secondL));
    number_to_charcode inst6(.in(tempSecondR), .out(secondR));
    
    always@(*)
    begin
        if(is24HrMode)
            out = {8'h20, 8'h20, 8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h3A, secondL, secondR, 8'h20, 8'h20, 8'h20, 8'h20};
        else
            if(isAM)
                out = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h3A, secondL, secondR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20};
            else
                out = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h3A, secondL, secondR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20};
    end
endmodule
