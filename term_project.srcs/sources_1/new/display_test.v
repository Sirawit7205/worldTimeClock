`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 05:09:54 PM
// Design Name: 
// Module Name: display_test
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


module display_test(
    input clock,
    output reg [7:0] data,
    output reg enable,
    output reg select,
    output backlight
    );
    
    reg flag;
    reg [63:0] constdata = {8'h38,8'h0E,8'h06,8'h50,8'h41,8'h4E,8'h54,8'h45};
    integer length = 8, j = 0;
    reg [27:0] i;
    
    assign backlight = 1;
    
    always@(posedge clock)
    begin
        if(i <= 2000000)
        begin
            i = i + 1;
            enable = 1;
            data = ((constdata >> (8*(length - j - 1))) & {8{1'b1}});
        end
        
        else if(i > 2000000 & i < 4000000)
        begin
            i = i + 1;
            enable = 0;
        end
        
        else if(i == 4000000)
        begin
            i = 0;
            j = j + 1;
            
            if(j > 7) j = 3;
            
            if(j < 3) select = 0;
            else select = 1;
        end
    end
endmodule
