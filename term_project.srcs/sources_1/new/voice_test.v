`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/17/2018 01:03:18 AM
// Design Name: 
// Module Name: Voice_test
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


module voice_test(
    input swRec,
    input swStop,
    input clock,
    input flag,
    output rec,
    output reg play
    );
    
    reg [27:0] i;
    reg count;
    
    always@(posedge clock)
    begin
        if(i == 100_000_000) i = 0;
        else i = i + 1;
    end
    
    always@(i)
    begin
        if(i == 100_000_000) count = 1;
        else count = 0;
    end
    
    always@(count)
    begin
        if(flag)
        begin
            if(i < 50_000_000) play = 1;
            else play = 0;
        end
        else play = 0;
    end
    
    assign rec = swRec;
endmodule
