`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2018 04:12:46 PM
// Design Name: 
// Module Name: timetocal
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


module timetocal(
    input [4:0] hour,
    input [5:0] minute,
    input [5:0] second,
    input clk,
    output [3:0] toconvect
    );
    integer temphour1,temphour2,tempminute1,tempminute2,tempsecond1,tempsecond2;
    reg select=0;
    reg [3:0] tempout;
    always@(hour,minute,second)
    begin
       temphour1 = hour%10;
       temphour2 = hour/10;
       tempminute1 = minute%10;
       tempminute2 = minute/10;
       tempsecond1 = second%10;
       tempsecond2 = second/10;
    end
    always @ (clk)
        begin
            if(select == 0)
              begin
                tempout = temphour1;
                select = select +1 ;
              end
            if(select == 1)
              begin
                tempout = temphour2;
                select = select +1 ;
              end  
           if(select == 2)
              begin
                tempout = tempminute1;
                select = select +1 ;
              end   
           if(select == 3)
               begin
                 tempout = tempminute2;
                 select = select +1 ;
               end
           if(select == 4)
               begin
                 tempout = tempsecond1;
                 select = select +1 ;
               end   
           if(select == 5)
               begin
                 tempout = tempsecond2;
                 select = select +1 ;
               end                       
         end
    assign toconvect = tempout;
endmodule
