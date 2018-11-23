`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/22/2018 01:01:01 AM
// Design Name: 
// Module Name: display_driver
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


module display_driver(
    input clock,
    input [127:0] in_top, in_bot,
    output reg [7:0] data,
    output reg enable,
    output reg select,
    output backlight
    );
    
    reg [23:0] initData = {8'h38,8'h0E,8'h06};
    reg [3:0] initSize = 3, j = -1;
    reg initflag = 0, stage = 0;
    
    //turn on the backlight
    assign backlight = 1;
    
    //init the display to 2 lines, 8 bit, 5x8 dot, turn display on with cursor,
    //then set cursor to homes
    always@(posedge clock)
    begin
        if(initflag == 0)
        begin
            select = 0;
            
            if(j == initSize - 1) initflag = 1;
            else
            begin
                if(stage == 0)
                begin
                    j = j + 1;
                    data = ((initData >> (8*(initSize - j - 1))) & {8{1'b1}});
                    enable = 1;
                    stage = 1;
                end
                else
                begin
                    enable = 0;
                    stage = 0;
                end
            end
        end
    end

    
endmodule
