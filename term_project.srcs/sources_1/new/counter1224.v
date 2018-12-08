`timescale 1ns / 1ps

//  counter1224 module
//  ->a counter module for hours counting
//  ->supports counting in 12/24 hours modes (synchronous counting)
//  ->use mux to select mode

module counter1224(
    input [5:0] preset,
    input presetampm, load, is24HrMode, clock,
    output [5:0] out,
    output isPM, load_finished
    );
    
    reg [5:0] current = 0, current12 = 0, current24 = 0;
    reg currentampm = 0, load_fn = 0;

    always@(posedge clock or posedge load)
    begin
    
        //load set time from menu   
		if(load)
		begin
		
            //load in 24 hours mode		      
            if(is24HrMode)
            begin
                
                //preset 24 hours
                current24 = preset;
                
                //preset 12 hours
                if(preset > 11)                 //PM
                begin
                    current12 = preset - 12;
                    currentampm = 1;
                end

                else                            //AM
                begin
                    current12 = preset;
                    currentampm = 0;
                end
            end
            
            //load in 12 hours mode
            else
            begin
                
                //preset 12 hours
                current12 = preset;
                currentampm = presetampm;
                
                //preset 24 hours
                if(presetampm == 1)             //PM
                    current24 = preset + 12;
                else                            //AM
                    current24 = preset;
            end
    
            load_fn = 1;        //feedback to menu to stop loading
		end
		
		//normal counting operation
		else
		begin
			load_fn = 0;         //reset feedback flag
			
			//24 hours counting
			if(current24 == 23) 
                current24 = 0;
			else 
		        current24 = current24 + 1;
			
			//12 hours counting
			if(current12 == 11)
			begin
				current12 = 0;
				currentampm <= ~currentampm;
			end
			else 
                current12 = current12 +1;
		end
    end
    
    //assign to output
    assign out = is24HrMode ? current24 : current12;    //select 12/24 hours mode
    assign isPM = currentampm;
    assign load_finished = load_fn;
    
endmodule
