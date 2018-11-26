`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/15/2018 01:30:04 AM
// Design Name: 
// Module Name: main_clock_counter
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


module counter1224(
    input [4:0] preset,
    input load,
    input is24HrMode,
    input clock,
    output [4:0] out,
    output isAM
    );
    
    reg [4:0] current = 0;
    reg currentampm = 0;
    
    //counting block
    always@(posedge clock or posedge load)
    begin
        if(load)
            current <= preset;
        else
        begin
            if(is24HrMode)      //using 24 hour mode
            begin
                if(current == 23) current = 0;
                else current = current + 1;
            end                 //using 12 hour mode
            else begin
                if(current == 11)
                begin 
                    current = 0;
                    currentampm <= ~currentampm;     //toogle AM/PM
                end
                else current = current + 1;
            end   
        end
    end
    
    //assign to outputs
    assign out = current;
    assign isAM = currentampm;
    
endmodule
