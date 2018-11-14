`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 01:19:58 AM
// Design Name: 
// Module Name: prescaler
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


module prescaler(
    input clock,
    output out1hz    
    );
    
    reg [27:0] count;
    reg buff;
    
    always@(posedge clock)
    begin
        if(count == 100_000_000) count = 0; 
        else count = count + 1;
    end
    
    always@(count)
    begin
        if(count == 100_000_000) buff = 1;
        else buff = 0;
    end
    
    assign out1hz = buff;
    
endmodule
