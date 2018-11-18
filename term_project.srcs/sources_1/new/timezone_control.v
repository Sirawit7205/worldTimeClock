`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 02:48:22 AM
// Design Name: 
// Module Name: timezone_control
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


module timezone_control(
    input [15:0] select,
    input [3:0] ref,
    output [4:0] out,
    output reg [15:0] led
    );
    reg [4:0] temp;
    always@(select)
        begin
            led = select; 
            case(select)
             16'b0000_0000_0000_0001 : //-10
                temp = 5'b10110;
             16'b0000_0000_0000_0010 : //-9
                temp = 5'b10111;
             16'b0000_0000_0000_0100 : //-8
                temp = 5'b11000; 
             16'b0000_0000_0000_1000 : //-7
                temp = 5'b11001;
             16'b0000_0000_0001_0000 : //-6
                temp = 5'b11010;
             16'b0000_0000_0010_0000 : //-5
                temp = 5'b11011;
             16'b0000_0000_0100_0000 : //-4
                temp = 5'b11100;
             16'b0000_0000_1000_0000 : //-3
                temp = 5'b11101;
             16'b0000_0001_0000_0000 : //0
                temp = 5'b00000;
             16'b0000_0010_0000_0000 : //1
                temp = 5'b00001;
             16'b0000_0100_0000_0000 : //2
                temp = 5'b00010;
             16'b0000_1000_0000_0000 : //3
                temp = 5'b00011;
             16'b0001_0000_0000_0000 : //7
                temp = 5'b00111;
             16'b0010_0000_0000_0000 : //8
                temp = 5'b00011;
             16'b0100_0000_0000_0000 : //9
                temp = 5'b01001;
             16'b1000_0000_0000_0000 : //10
                temp = 5'b01010;
            endcase
        end
        
    assign out = temp;
       
endmodule
