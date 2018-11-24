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
    output out1hz, out50hz    
    );
    
    reg [27:0] count1, count50;
    reg flag1, flag50;
    
    always@(posedge clock)
    begin
        if(count1 == 100_000_000)
            count1 = 0; 
        else 
            count1 = count1 + 1;
        
        if(count50 == 2_000_000)
             count50 = 0;
        else 
            count50 = count50 + 1;
    end
    
    always@(count1 or count50)
    begin
        if(count1 == 100_000_000) flag1 = 1;
        else flag1 = 0;
        
        if(count50 == 2_000_000) flag50 = 1;
        else flag50 = 0;
    end
    
    assign out1hz = flag1;
    assign out50hz = flag50;
    
endmodule
