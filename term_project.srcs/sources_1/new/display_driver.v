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
    
    reg [23:0] initData = {8'h38,8'h0C,8'h06};
    reg [7:0] setCursorTop = {8'h80}, setCursorBot = {8'hC0};
    reg [4:0] initSize = 3, dataSize = 16, j = -1;
    reg [2:0] commandstage = 0;
    reg initflag = 0, stage = 0;
    
    //turn on the backlight
    assign backlight = 1;
    
    //init the display to 2 lines, 8 bit, 5x8 dot, turn display on with cursor,
    //then set cursor to home

    //state machine for writing data
    always@(posedge clock)
    begin
        if(initflag)
        begin
            case(commandstage)
                2'b00: if(stage == 1) commandstage <= 2'b01;    //cursor top -> write top
                2'b01: if(stage == 1 && j == dataSize - 1) commandstage <= 2'b10;    //write top -> cursor bot
                2'b10: if(stage == 1) commandstage <= 2'b11;    //cursor bot -> write bot
                2'b11: if(stage == 1 && j == dataSize - 1) commandstage <= 2'b00;    //write bot -> cursor top
            endcase
        end
    end
    
    //writing data
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
        if(initflag == 1)
        begin
            if(stage == 1) //ready to trigger changes
            begin
                stage = 0;
                enable = 0;
            end
            else            //set the data
            begin
                case(commandstage)
                    2'b00: begin
                        j = 0;
                        select = 0;
                        data = setCursorTop;
                    end
                    2'b01: begin
                        select = 1;
                        data = ((in_top >> (8*(dataSize - j - 1))) & {8{1'b1}});
                        j = j + 1; 
                    end
                    2'b10: begin
                        j = 0;
                        select = 0;
                        data = setCursorBot;
                    end
                    2'b11: begin
                        select = 1;
                        data = ((in_bot >> (8*(dataSize - j - 1))) & {8{1'b1}});
                        j = j + 1; 
                    end                    
                endcase
                
                stage = 1;
                enable = 1;
            end        
        end
    end
endmodule
