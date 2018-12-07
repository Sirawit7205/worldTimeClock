`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/08/2018 02:17:02 AM
// Design Name: 
// Module Name: alarm_overlay
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


module alarm_overlay(
    input alarm_on,
    input [127:0] in,
    output reg [127:0] out
    );
    
    always@(*)
    begin
        if(alarm_on)
            out = {in[127:8], 8'h41};
        else
            out = in;
    end
endmodule
