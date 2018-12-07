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
    input [5:0] preset,
    input presetampm,
    input load,
    input is24HrMode,
    input clock,
    output [5:0] out,
    output isPM,
    output load_finished
    );
    
    reg [5:0] current = 0, current12 = 0, current24 = 0;
    reg currentampm = 0, load_fn = 0;
    
    //counting block
    always@(posedge clock or posedge load)
    begin   
		if(load)
		begin
			if(is24HrMode)
			begin
				current24 = preset;
				if(preset > 11)
				begin
					current12 = preset - 12;
					currentampm = 1;
				end
				else
				begin
					current12 = preset;
					currentampm = 0;
				end
			end
			else
			begin
				current12 = preset;
				currentampm = presetampm;
				if(presetampm == 1)
					current24 = preset + 12;
				else
					current24 = preset;
			end

			load_fn = 1; 
		end
		
		else
		begin
			load_fn = 0;
			
			if(current24 == 23) current24 = 0;
			else current24 = current24 + 1;
			
			if(current12 == 11)
			begin
				current12 = 0;
				currentampm <= ~currentampm;
			end
			else current12 = current12 +1;
		end
    end
    
    //assign to outputs
    assign out = is24HrMode ? current24 : current12;
    assign isPM = currentampm;
    assign load_finished = load_fn;
    
endmodule
