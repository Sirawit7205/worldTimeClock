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
    input mode,
    input clock,
    output [4:0] out,
    output ampm
    );
    
    reg [4:0] current;
    reg currentampm;
    
    //counting block
    always@(posedge clock)
    begin
        current = current + 1;
        
        if(mode)    //using 12 hour mode
        begin
            if(current == 12) current = 0;
            currentampm = ~currentampm;     //toogle AM/PM
        end         //using 24 hour mode
        else begin
            if(current == 24) current = 0;
        end
    end
    
    //load initial data block
    always@(load)
    begin
        current = preset;
    end
    
    //assign to outputs
    assign out = current;
    assign ampm = currentampm;
    
endmodule
