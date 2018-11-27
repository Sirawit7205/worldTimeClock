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
    output reg [127:0] menu_top,
    output reg [127:0] menu_bot,
    output reg menuIntrup,
    output reg rec
    );
    
    reg [3:0] state = 0;
    
    always@(posedge clock)
    begin
        case(state)
            4'b0000: if(menuBtn) state <= 4'b0001;      //idle -> set time
            4'b0001: if(menuBtn) state <= 4'b0010;      //set time -> 12/24
                     else if(offBtn) state <= 4'b0101;  //set time -> ST submenu
            4'b0010: if(menuBtn) state <= 4'b0011;      //12/24 -> set alarm
                     else if(offBtn) state <= 4'b0110;  //12/24 -> toggle am/pm
            4'b0011: if(menuBtn) state <= 4'b1000;      //set alarm -> record alarm
                     else if(offBtn) state <= 4'b0111;  //set alarm -> SA submenu
            4'b0100: if(menuBtn) state <= 4'b0000;      //record alarm -> idle
                     else if(offBtn) state <= 4'b1000;  //record alarm -> RA submenu
            default: state <= 4'b0000;
        endcase
    end
    
    always@(*)
    begin
        if(state != 4'b0000) menuIntrup = 1;
        else menuIntrup = 0;
        
        case(state)
            4'b0001: begin
                menu_top = {8'h4D, 8'h45, 8'h4E, 8'h55, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                menu_bot = {8'h53, 8'h45, 8'h54, 8'h20, 8'h54, 8'h49, 8'h4D, 8'h45, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            4'b0010: menu_bot = {8'h31, 8'h32, 8'h2F, 8'h32, 8'h34, 8'h20, 8'h48, 8'h4F, 8'h55, 8'h52, 8'h20, 8'h4D, 8'h4F, 8'h44, 8'h45, 8'h20};
            4'b0011: menu_bot = {8'h53, 8'h45, 8'h54, 8'h20, 8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            4'b0100: menu_bot = {8'h52, 8'h45, 8'h43, 8'h4F, 8'h52, 8'h44, 8'h20, 8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20};
        endcase
    end
    
endmodule
