`timescale 1ns / 1ps

//  timezone_adjust module
//  ->adjust time output from hour counter to the time of target timezone
//  ->calculate based on reference timezone (the timezone selected during the time set process)

module timezone_adjust(
    input [5:0] hour, selectedTime,
    input is24HrMode, isPM, loadRefZone,
    output [5:0] adjustedTime,
    output adjustedAMPM, load_finished
    );
    
    reg [5:0] refZone = 0, temp;
    reg ampm, load_fn = 0;
    
    //load reference timezone
    always@(posedge loadRefZone or negedge loadRefZone)
    begin
        //load
        if(loadRefZone == 1)
        begin
            refZone = selectedTime * -1;    //if added to the reference timezone will equal to 0
            load_fn <= 1;                   //feedback to menu to stop loading
        end
        
        //reset
        else
            load_fn <= 0;                   //reset feedback flag
    end
    
    //calculate adjusted time after timezone conversion
    always@(*)
    begin
        temp = hour + refZone + selectedTime;       //hour from counter + reference + currently selected
        
        //calculate in 24 hours mode
        if(is24HrMode)
        begin
            if(temp >= 54) temp = temp - 40;        //underflow
            else if(temp >= 24) temp = temp - 24;   //overflow
        end
        
        //calculate in 12 hours mode
        else
        begin
            if(temp >= 54)          //underflow
            begin
                temp = temp - 52;
                ampm = ~isPM;
            end
            
            else if(temp >= 12)     //overflow
            begin
                temp = temp - 12;
                ampm = ~isPM;
            end
            
            else                    //assign AM/PM in normal condition
                ampm = isPM;
        end 
    end
    
    //assign to output
    assign adjustedTime = temp;
    assign adjustedAMPM = ampm;
    assign load_finished = load_fn;
    
endmodule
