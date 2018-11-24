`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/24/2018 03:58:11 PM
// Design Name: 
// Module Name: decodertime
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


module decodertime(
    input [3:0] in,
    output reg [7:0]out
    );
    always@(in)
        case(in)
            0: out = 8'h30;
            1: out = 8'h31;
            2: out = 8'h32;
            3: out = 8'h33;
            4: out = 8'h34;
            5: out = 8'h35;
            6: out = 8'h36;
            7: out = 8'h37;
            8: out = 8'h38;
            9: out = 8'h39;
         endcase   
endmodule
