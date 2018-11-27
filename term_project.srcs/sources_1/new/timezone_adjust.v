`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2018 03:39:02 PM
// Design Name: 
// Module Name: timezone
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


module timezone_adjust(
    input [5:0] hour,
    input [5:0] selectedTime,
    input is24HrMode,
    input isAM,
    output [5:0] adjustedTime,
    output adjustedAMPM
    );
    
    reg [5:0] temp;
    reg ampm;
    
    always@(*)
    begin
        temp = hour + selectedTime;
        
        if(is24HrMode)
        begin
            if(temp >= 54) temp = temp - 40;
            else if(temp >= 24) temp = temp - 24;
        end
        else
        begin
            if(temp >= 54)
            begin
                temp = temp - 52;
                ampm = ~isAM;
            end
            else if(temp >= 12)
            begin
                temp = temp - 12;
                ampm = ~isAM;
            end
        end 
    end
    
    assign adjustedTime = temp;
    assign adjustedAMPM = ampm;
endmodule
