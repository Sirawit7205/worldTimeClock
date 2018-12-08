`timescale 1ns / 1ps

//  timezone_overlay module
//  ->overlays a message to the screen if no timezone is selected

module timezone_overlay(
    input [5:0] timezone,
    output ovrIntrup,
    output [127:0] top, bot
    );
    
    reg intrup;
    
    always@(timezone)
    begin
        if(timezone == 6'b111111)   //if invalid state is detected by timezone_control
            intrup = 1;
        else                        //reset interrupt
            intrup = 0;
    end
    
    //assign to output
    assign ovrIntrup = intrup;
    assign top = {8'h53, 8'h45, 8'h4C, 8'h45, 8'h43, 8'h54, 8'h20, 8'h54, 8'h49, 8'h4D, 8'h45, 8'h5A, 8'h4F, 8'h4E, 8'h45, 8'h20};
    assign bot = {8'h20, 8'h57, 8'h49, 8'h54, 8'h48, 8'h20, 8'h53, 8'h57, 8'h49, 8'h54, 8'h43, 8'h48, 8'h45, 8'h53, 8'h20, 8'h20};
    
endmodule
