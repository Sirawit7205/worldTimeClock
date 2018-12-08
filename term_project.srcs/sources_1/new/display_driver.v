`timescale 1ns / 1ps

//  display_driver module
//  ->automatically initialize the display on power up
//  ->receives data from mux, then sends the data via 8-bit parallel protocol to the display
//  ->HD44780 compatible

module display_driver(
    input clock, backlight_ctrl,
    input [127:0] in_top, in_bot,
    output reg [7:0] data,
    output reg enable, select,
    output backlight
    );
    
    //init the display to 2 lines, 8 bit, 5x8 dot, turn display on without cursor,
    //set cursor move direction to increment without display shift, then clear screen
    reg [31:0] initData = {8'h38,8'h0C,8'h06,8'h01};
    
    reg [7:0] setCursorTop = {8'h80}, setCursorBot = {8'hC0};
    reg [4:0] initSize = 4, dataSize = 16, j = -1;
    reg [2:0] commandstage = 0;
    reg initflag = 0, stage = 0;
    
    //turn on the backlight
    assign backlight = backlight_ctrl;

    //state machine for writing data
    always@(posedge clock)
    begin
        if(initflag)
        begin
            case(commandstage)
                2'b00: if(stage == 1) commandstage <= 2'b01;    //cursor top -> write top
                2'b01: if(stage == 1 && j == dataSize) commandstage <= 2'b10;    //write top -> cursor bot
                2'b10: if(stage == 1) commandstage <= 2'b11;    //cursor bot -> write bot
                2'b11: if(stage == 1 && j == dataSize) commandstage <= 2'b00;    //write bot -> cursor top
            endcase
        end
    end
    
    //output of the state machine
    always@(posedge clock)
    begin
    
        //init display on start up
        if(initflag == 0)
            begin
                select = 0;     //select instruction mode
                
                if(j == initSize - 1) initflag = 1;     //skip init if it had been completed
                else
                begin
                    if(stage == 0)
                    begin
                        j = j + 1;      //move to next byte
                        data = ((initData >> (8*(initSize - j - 1))) & {8{1'b1}});  //select the correct data byte via bit shifting and masking
                        enable = 1;     //tells the controller to standby
                        stage = 1;
                    end
                    
                    else
                    begin
                        enable = 0;     //tells the controller to execute the command
                        stage = 0;
                    end
                end
            end
        
        //writing data
        else
        begin
        
            if(stage == 1)
            begin
                stage = 0;
                enable = 0;     //tells the controller to execute the command
            end
            else                //set the data
            begin
                case(commandstage)
                    2'b00: begin
                        j = 0;
                        select = 0;             //select instruction mode
                        data = setCursorTop;    //set cursor to the start of first line
                    end
                    2'b01: begin
                        select = 1;             //select data mode
                        data = ((in_top >> (8*(dataSize - j - 1))) & {8{1'b1}});    //select the correct data byte via bit shifting and masking
                        j = j + 1;              //move to next byte
                    end
                    2'b10: begin
                        j = 0;
                        select = 0;             //select instruction mode
                        data = setCursorBot;    //set cursor to the start of first line
                    end
                    2'b11: begin
                        select = 1;             //select data mode
                        data = ((in_bot >> (8*(dataSize - j - 1))) & {8{1'b1}});    //select the correct data byte via bit shifting and masking
                        j = j + 1;              //move to next byte
                    end                    
                endcase
                
                stage = 1;
                enable = 1;     //tells the controller to execute the command
            end        
        end
    end
endmodule
