`timescale 1ns / 1ps

//  prescaler module
//  -> clock divider to 1Hz (counter trigger)
//  -> clock divider to 5Hz (button debounce, menu state machine, alarm state machine)
//  -> clock divider to 200Hz (Display communication)

module prescaler(
    input clock,
    output out1hz, out5hz, out200hz    
    );
    
    reg [27:0] count1, count5, count200;
    reg flag1, flag5, flag200;
    
    always@(posedge clock)
    begin
        //divide 1Hz
        if(count1 == 100_000_000)
            count1 = 0; 
        else 
            count1 = count1 + 1;
            
        //divide 5Hz
        if(count5 == 20_000_000)
            count5 = 0;
        else
            count5 = count5 + 1;
        
        //divide 200Hz
        if(count200 == 500_000)
             count200 = 0;
        else 
            count200 = count200 + 1;
    end
    
    always@(count1 or count5 or count200)
    begin
        //output stage 1Hz
        if(count1 == 100_000_000) flag1 = 1;
        else flag1 = 0;
        
        //output stage 5Hz
        if(count5 == 20_000_000) flag5 = 1;
        else flag5 = 0;
        
        //output stage 200Hz
        if(count200 == 500_000) flag200 = 1;
        else flag200 = 0;
    end
    
    //assign to output
    assign out1hz = flag1;
    assign out5hz = flag5;
    assign out200hz = flag200;
    
endmodule
