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
    input [4:0] hour,
    input [4:0] selectedTime,
    input is24HrMode,
    output [4:0] adjustedTime
    );
    
    reg [4:0]temp;
    
    always@(*)
    begin
        temp = hour + selectedTime;
        
        /*if(is24HrMode)    //TO BE FIXED LATER
        begin
            if(temp > 23) temp = temp - 24;
            else if(temp < 0) temp = temp + 24;
        end
        else
        begin
            if(temp > 11) temp = temp - 12;
            else if(temp < 0) temp = temp + 12;
        end*/    
    end
    
    assign adjustedTime = temp;
    
endmodule
