`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2018 03:39:02 PM
// Design Name: 
// Module Name: timezone
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


module timezone(
    input [4:0] hour,
    input [4:0] selecttime,
    output [4:0] presenthour
    );
    reg [4:0]temp;
        always@(selecttime)
            temp = presenthour + selecttime;
    assign presenthour = temp;
endmodule
