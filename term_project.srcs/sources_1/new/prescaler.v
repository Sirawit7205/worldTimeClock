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
    output out1hz, out5hz, out200hz    
    );
    
    reg [27:0] count1, count5, count200;
    reg flag1, flag5, flag200;
    
    always@(posedge clock)
    begin
        if(count1 == 100_000_000)
            count1 = 0; 
        else 
            count1 = count1 + 1;
            
        if(count5 == 20_000_000)
            count5 = 0;
        else
            count5 = count5 + 1;
        
        if(count200 == 500_000)
             count200 = 0;
        else 
            count200 = count200 + 1;
    end
    
    always@(count1 or count200)
    begin
        if(count1 == 100_000_000) flag1 = 1;
        else flag1 = 0;
        
        if(count5 == 20_000_000) flag5 = 1;
        else flag5 = 0;
        
        if(count200 == 500_000) flag200 = 1;
        else flag200 = 0;
    end
    
    assign out1hz = flag1;
    assign out5hz = flag5;
    assign out200hz = flag200;
    
endmodule
