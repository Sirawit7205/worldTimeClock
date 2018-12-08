`timescale 1ns / 1ps

//  button_debounce module
//  -> debounce all 5 push buttons with D flip-flops

module button_debounce(
    input clock,
    input menuBtn, snzBtn, minBtn, plusBtn, offBtn,
    output menu, snz, min, plus, off
    );
    
    wire menuS1, snzS1, minS1, plusS1, offS1;
    wire menuS2, snzS2, minS2, plusS2, offS2;
    
    //D flip-flip stage 1
    dff inst1(.clock(clock), .trig(menuBtn), .out(menuS1));
    dff inst2(.clock(clock), .trig(snzBtn), .out(snzS1));
    dff inst3(.clock(clock), .trig(minBtn), .out(minS1));
    dff inst4(.clock(clock), .trig(plusBtn), .out(plusS1));
    dff inst5(.clock(clock), .trig(offBtn), .out(offS1));
    
    //D flip-flop stage 2
    dff inst6(.clock(clock), .trig(menuS1), .outbar(menuS2));
    dff inst7(.clock(clock), .trig(snzS1), .outbar(snzS2));
    dff inst8(.clock(clock), .trig(minS1), .outbar(minS2));
    dff inst9(.clock(clock), .trig(plusS1), .outbar(plusS2));
    dff inst10(.clock(clock), .trig(offS1), .outbar(offS2));
    
    //output stage
    assign menu = menuS1 & menuS2;
    assign snz = snzS1 & snzS2;
    assign min = minS1 & minS2;
    assign plus = plusS1 & plusS2;
    assign off = offS1 & offS2;
    
endmodule

//  dff module
//  ->generic D flip-flop

module dff(
    input clock, trig,
    output reg out, outbar
);
    always@(posedge clock)
    begin
        out <= trig;
        outbar <= ~trig;
    end
endmodule
