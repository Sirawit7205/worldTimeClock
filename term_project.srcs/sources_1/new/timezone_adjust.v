`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/23/2018 03:39:02 PM
// Design Name: 
// Module Name: timezone
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


module timezone_adjust(
    input [5:0] hour,
    input [5:0] selectedTime,
    input is24HrMode,
    input isPM,
    input loadRefZone,
    output [5:0] adjustedTime,
    output adjustedAMPM, load_finished
    );
    
    reg [5:0] refZone = 0, temp;
    reg ampm, load_fn = 0;
    
    always@(posedge loadRefZone or negedge loadRefZone)
    begin
        if(loadRefZone == 1)
        begin
            refZone = selectedTime * -1;
            load_fn <= 1;
        end
        else
            load_fn <= 0;
    end
    
    always@(*)
    begin
        temp = hour + refZone + selectedTime;
        
        if(is24HrMode)
        begin
            if(temp >= 54) temp = temp - 40;
            else if(temp >= 24) temp = temp - 24;
        end
        else
        begin
            if(temp >= 54)
            begin
                temp = temp - 52;
                ampm = ~isPM;
            end
            else if(temp >= 12)
            begin
                temp = temp - 12;
                ampm = ~isPM;
            end
            else
                ampm = isPM;
        end 
    end
    
    assign adjustedTime = temp;
    assign adjustedAMPM = ampm;
    assign load_finished = load_fn;
    
endmodule
