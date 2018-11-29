`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2018 04:18:50 PM
// Design Name: 
// Module Name: menu
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


module menu(
    input clock, 
    input menuBtn, snzBtn, minBtn, plusBtn, offBtn,
    output reg [127:0] menu_top, menu_bot,
    output [5:0] presetHour, presetMin,
    output presetampm,
    output reg menuIntrup, rec, load,
    output is24HrMode
    );
    
    reg [3:0] state = 0;
    wire [3:0] tempHourL, tempHourR, tempMinuteL, tempMinuteR;
    wire [7:0] hourL, hourR, minuteL, minuteR;
    reg [5:0] hour = 0, min = 0, alarmHour = 0, alarmMin = 0;
    reg hrMode = 1, ampm = 0;
    
    //extract each digit
    assign tempHourL = hour / 10;
    assign tempHourR = hour % 10;
    assign tempMinuteL = min / 10;
    assign tempMinuteR = min % 10;
    
    //convert current set time to charcode
    number_to_charcode inst1(.in(tempHourL), .out(hourL));
    number_to_charcode inst2(.in(tempHourR), .out(hourR));
    number_to_charcode inst3(.in(tempMinuteL), .out(minuteL));
    number_to_charcode inst4(.in(tempMinuteR), .out(minuteR));
    
    always@(posedge clock)
    begin
        case(state)
            4'b0000: if(menuBtn) state <= 4'b0001;      //idle -> set time
            4'b0001: if(menuBtn) state <= 4'b0010;      //set time -> 12/24
                     else if(offBtn) state <= 4'b0101;  //set time -> ST submenu 1
            4'b0010: if(menuBtn) state <= 4'b0011;      //12/24 -> set alarm
                     else if(offBtn) state <= 4'b1000;  //12/24 -> toggle am/pm
            4'b0011: if(menuBtn) state <= 4'b0100;      //set alarm -> record alarm
                     else if(offBtn) state <= 4'b1001;  //set alarm -> SA submenu 1
            4'b0100: if(menuBtn) state <= 4'b0000;      //record alarm -> idle
                     else if(offBtn) state <= 4'b1011;  //record alarm -> RA submenu
            4'b0101: if(offBtn) state <= 4'b0110;       //ST submenu 1 -> ST submenu 2
            4'b0110: if(offBtn) state <= 4'b0111;       //ST submenu 2 -> ST load
            4'b0111: state <= 4'b0000;                  //ST load -> idle
            4'b1000: state <= 4'b0000;                  //toggle am/pm -> idle
            4'b1001: if(offBtn) state <= 4'b1010;       //SA submenu 1 -> SA submenu 2
            4'b1010: if(offBtn) state <= 4'b0000;       //SA submenu 2 -> idle
            4'b1011: if(menuBtn) state <= 4'b0000;      //RA submenu -> idle
                     else if(plusBtn) state <= 4'b1100; //RA submenu -> start record
            4'b1100: if(plusBtn == 0) state <= 4'b1101; //start record -> end record
                     else state <= 4'b1100;             //start record -> start record
            4'b1101: state <= 4'b0000;                  //end record -> idle
            default: state <= 4'b0000;
        endcase
    end
    
    always@(posedge clock)
    begin
        if(state != 4'b0000) menuIntrup = 1;
        else menuIntrup = 0;
        
        case(state)
            //all text only states
            4'b0000: begin
                hour <= 0;
                min <= 0;
                ampm <= 0;
                load <= 0;
            end
            4'b0001: begin
                menu_top = {8'h4D, 8'h45, 8'h4E, 8'h55, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                menu_bot = {8'h53, 8'h45, 8'h54, 8'h20, 8'h54, 8'h49, 8'h4D, 8'h45, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            4'b0010: menu_bot = {8'h31, 8'h32, 8'h2F, 8'h32, 8'h34, 8'h20, 8'h48, 8'h4F, 8'h55, 8'h52, 8'h20, 8'h4D, 8'h4F, 8'h44, 8'h45, 8'h20};
            4'b0011: menu_bot = {8'h53, 8'h45, 8'h54, 8'h20, 8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            4'b0100: menu_bot = {8'h52, 8'h45, 8'h43, 8'h4F, 8'h52, 8'h44, 8'h20, 8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20};
            
            //other states
            4'b0101: begin
                menu_top = {8'h53, 8'h45, 8'h54, 8'h20, 8'h48, 8'h4F, 8'h55, 8'h52, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                
                if(minBtn) hour = hour - 1;
                else if(plusBtn) hour = hour + 1;
                
                //24 hour mode
                if(hrMode)
                begin
                    if(hour == 63) hour = 23;
                    else if(hour == 24) hour = 0;
                    
                    menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                end
                //12 hour mode
                else
                begin
                    if(hour == 63)
                    begin
                        hour = 11;
                        ampm = ~ampm;
                    end
                    else if(hour == 12)
                    begin
                        hour = 0; 
                        ampm = ~ampm;
                    end
                    
                    if(ampm == 0)
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                    else
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                end
            end
            4'b0110: begin
                menu_top = {8'h53, 8'h45, 8'h54, 8'h20, 8'h4D, 8'h49, 8'h4E, 8'h55, 8'h54, 8'h45, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                
                if(minBtn) min = min - 1;
                else if(plusBtn) min = min + 1;
                
                if(min == 63) min = 59;
                else if(min == 60) min = 0;
                
                if(hrMode)
                    menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                else
                    if(ampm == 0)
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                    else
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            4'b0111: begin
                load <= 1;
            end
            4'b1000: begin
                hrMode <= ~hrMode;
            end
            4'b1001: begin
            
            end
            4'b1010: begin
            
            end
            4'b1011: begin
                menu_top = {8'h48, 8'h4F, 8'h4C, 8'h44, 8'h20, 8'h2B, 8'h20, 8'h54, 8'h4F, 8'h20, 8'h52, 8'h45, 8'h43, 8'h20, 8'h20, 8'h20};
                menu_bot = {8'h52, 8'h45, 8'h4C, 8'h45, 8'h41, 8'h53, 8'h45, 8'h20, 8'h54, 8'h4F, 8'h20, 8'h53, 8'h41, 8'h56, 8'h45, 8'h20};            
            end
            4'b1100: begin
                rec = 1;
            end
            4'b1101: begin
                rec = 0;
            end
        endcase
    end
    
    assign is24HrMode = hrMode;
    assign presetHour = hour;
    assign presetMin = min;
    assign presetampm = ampm;
    
endmodule
