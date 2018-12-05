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
    output [5:0] out,
    output reg [15:0] led
    );
    
    reg [5:0] temp;
    
    always@(select)
        begin
            led = select; 
            case(select)
             16'b1000_0000_0000_0000 : //-10
                temp = 6'b110110;
             16'b0100_0000_0000_0000 : //-9
                temp = 6'b110111;
             16'b0010_0000_0000_0000 : //-8
                temp = 6'b111000; 
             16'b0001_0000_0000_0000 : //-7
                temp = 6'b111001;
             16'b0000_1000_0000_0000 : //-6
                temp = 6'b111010;
             16'b0000_0100_0000_0000 : //-5
                temp = 6'b111011;
             16'b0000_0010_0000_0000 : //-4
                temp = 6'b111100;
             16'b0000_0001_0000_0000 : //-3
                temp = 6'b111101;
             16'b0000_0000_1000_0000 : //0
                temp = 6'b000000;
             16'b0000_0000_0100_0000 : //1
                temp = 6'b000001;
             16'b0000_0000_0010_0000 : //2
                temp = 6'b000010;
             16'b0000_0000_0001_0000 : //3
                temp = 6'b000011;
             16'b0000_0000_0000_1000 : //7
                temp = 6'b000111;
             16'b0000_0000_0000_0100 : //8
                temp = 6'b001000;
             16'b0000_0000_0000_0010 : //9
                temp = 6'b001001;
             16'b0000_0000_0000_0001 : //10
                temp = 6'b001010;
                default: temp = 6'b111111;
            endcase
        end
        
    assign out = temp;
       
endmodule
