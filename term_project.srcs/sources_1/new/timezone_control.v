`timescale 1ns / 1ps

//  timezone_control module
//  ->receives input indicating timezone from slide switches
//  ->convert the input to number representation (from -10 to +10)
//  ->output 111111 when invalid state is detected

module timezone_control(
    input [15:0] select,
    output [5:0] out,
    output reg [15:0] led
    );
    
    reg [5:0] temp;
    
    always@(select)
        begin
            
            //also display switch selections to the corresponding LEDs
            led = select; 
            
            //convert to number
            case(select)
                16'b1000_0000_0000_0000 : //-10
                    temp = 6'b110110;
                16'b0100_0000_0000_0000 : //-9
                    temp = 6'b110111;
                16'b0010_0000_0000_0000 : //-8
                    temp = 6'b111000; 
                16'b0001_0000_0000_0000 : //-7
                    temp = 6'b111001;
                16'b0000_1000_0000_0000 : //-6
                    temp = 6'b111010;
                16'b0000_0100_0000_0000 : //-5
                    temp = 6'b111011;
                16'b0000_0010_0000_0000 : //-4
                    temp = 6'b111100;
                16'b0000_0001_0000_0000 : //-3
                    temp = 6'b111101;
                16'b0000_0000_1000_0000 : //0
                    temp = 6'b000000;
                16'b0000_0000_0100_0000 : //1
                    temp = 6'b000001;
                16'b0000_0000_0010_0000 : //2
                    temp = 6'b000010;
                16'b0000_0000_0001_0000 : //3
                    temp = 6'b000011;
                16'b0000_0000_0000_1000 : //7
                    temp = 6'b000111;
                16'b0000_0000_0000_0100 : //8
                    temp = 6'b001000;
                16'b0000_0000_0000_0010 : //9
                    temp = 6'b001001;
                16'b0000_0000_0000_0001 : //10
                    temp = 6'b001010;
                
                default: temp = 6'b111111; //invalid state
            endcase
        end
    
    //assign to output
    assign out = temp;
       
endmodule
