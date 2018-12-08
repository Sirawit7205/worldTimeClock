`timescale 1ns / 1ps

//  display_mux module
//  ->a multiplexer that selects what will be sent to the display
//  ->selects based on priority from: timezone overlay -> menu -> time

module display_mux(
    input menuIntrup, ovrIntrup,        //interrupts
    input [127:0] time_top, menu_top,   //from time module
    input [127:0] time_bot, menu_bot,   //from menu module
    input [127:0] ntzoverlay_top, ntzoverlay_bot,   //from timezone_overlay module 
    output reg [127:0] out_top,         //output to display driver
    output reg [127:0] out_bot
    );
    
    always@(*)
    begin
        //selects by priority
        if(ovrIntrup)           //timezone overlay
        begin
            out_top = ntzoverlay_top;
            out_bot = ntzoverlay_bot;
        end
        else if(menuIntrup)     //menu
        begin
            out_top = menu_top;
            out_bot = menu_bot;
        end
        else                    //time
        begin
            out_top = time_top;
            out_bot = time_bot;
        end
    end
    
endmodule
