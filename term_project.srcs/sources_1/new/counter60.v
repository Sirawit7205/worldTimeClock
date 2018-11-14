`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 02:28:55 AM
// Design Name: 
// Module Name: counter60
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


module counter60(
    input [5:0] preset,
    input load,
    input clock,
    output [5:0] out,
    output trigger
    );
    
    reg [5:0] current;
    reg ctrig;
    
    //counting block
    always@(clock)
    begin
        current = current + 1;
        
        if(current == 60)
        begin
            current = 0;
            ctrig = 1;      //trigger the next counter in chain
        end 
        else ctrig = 0;     //reset trigger
    end
    
    //load initial data block
    always@(load)
    begin
        current = preset;
    end
    
    //assign to output
    assign out = current;
    assign trigger = ctrig;
    
endmodule
