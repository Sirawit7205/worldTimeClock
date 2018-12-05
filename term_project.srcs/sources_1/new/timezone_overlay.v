`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 12/06/2018 01:14:54 AM
// Design Name: 
// Module Name: timezone_overlay
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


module timezone_overlay(
    input [5:0] timezone,
    output ovrIntrup,
    output [127:0] top, bot
    );
    
    reg intrup;
    
    always@(timezone)
    begin
        if(timezone == 6'b111111)
            intrup = 1;
        else
            intrup = 0;
    end
    
    assign ovrIntrup = intrup;
    assign top = {8'h53, 8'h45, 8'h4C, 8'h45, 8'h43, 8'h54, 8'h20, 8'h54, 8'h49, 8'h4D, 8'h45, 8'h5A, 8'h4F, 8'h4E, 8'h45, 8'h20};
    assign bot = {8'h20, 8'h57, 8'h49, 8'h54, 8'h48, 8'h20, 8'h53, 8'h57, 8'h49, 8'h54, 8'h43, 8'h48, 8'h45, 8'h53, 8'h20, 8'h20};
    
endmodule
