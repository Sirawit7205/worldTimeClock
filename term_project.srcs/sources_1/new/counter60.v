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
    output trigger, load_finished
    );
    
    reg [5:0] current = 0;
    reg ctrig = 0, load_fn = 0;
    
    //counting block
    always@(posedge clock or posedge load)
    begin
        if(load)
        begin
            current = preset;
            load_fn <= 1;
        end
        
        else
        begin
            load_fn <= 0;
        
            if(current == 59)
            begin
                current = 0;
                ctrig <= 1;      //trigger the next counter in chain
            end 
            else
            begin
                current = current + 1;
                ctrig <= 0;     //reset trigger
            end
        end
    end
    
    //assign to output
    assign out = current;
    assign trigger = ctrig;
    assign load_finished = load_fn;
    
endmodule
