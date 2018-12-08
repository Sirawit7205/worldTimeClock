`timescale 1ns / 1ps

//  counter60 module
//  ->a counter module for seconds and minutes counting

module counter60(
    input [5:0] preset,
    input load, clock,
    output [5:0] out,
    output trigger, load_finished
    );
    
    reg [5:0] current = 0;
    reg ctrig = 0, load_fn = 0;
    
    //counting block
    always@(posedge clock or posedge load)
    begin
        
        //load set time from menu
        if(load)
        begin
            current = preset;   //load
            load_fn = 1;        //feedback to menu to stop loading
        end
        
        //normal counting operation
        else
        begin
            load_fn = 0;        //reset feedback flag
            
            //if fully counted
            if(current == 59)
            begin
                current = 0;
                ctrig <= 1;      //trigger the next counter in chain
            end
            
            //normal count 
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
