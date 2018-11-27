`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2018 01:59:03 AM
// Design Name: 
// Module Name: display_mux
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


module display_mux(
    input menuIntrup,                   //interrupts
    input [127:0] time_top, menu_top,   //from time module
    input [127:0] time_bot, menu_bot,
    output reg [127:0] out_top,         //output to display driver
    output reg [127:0] out_bot
    );
    
    always@(*)
    begin
        //sort by priority
        if(menuIntrup)
        begin
            out_top = menu_top;
            out_bot = menu_bot;
        end
        else
        begin
            out_top = time_top;
            out_bot = time_bot;
        end
    end
    
endmodule
