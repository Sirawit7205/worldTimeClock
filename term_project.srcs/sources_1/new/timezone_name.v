`timescale 1ns / 1ps

//  timezone_name module
//  ->converts a timezone number representation to LCD display code

module timezone_name(
    input [5:0] timezone,
    output [127:0] lcd_out
    );
    
    reg [127:0] temp;
    
    always@(timezone)
    begin
        case(timezone)
            6'b110110: begin//-10 Hawaii
                temp = {8'h48 ,8'h61 ,8'h77 ,8'h61 ,8'h69 ,8'h69 ,8'h20 ,8'h20
                        ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b110111: begin//-9  Alaska
               temp = {8'h41 ,8'h6C ,8'h61 ,8'h73 ,8'h6B ,8'h61 ,8'h20 ,8'h20
                       ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b111000: begin//-8  Pacific time
               temp = {8'h50 ,8'h61 ,8'h63 ,8'h69 ,8'h66 ,8'h69 ,8'h63 ,8'h20
                       ,8'h74 ,8'h69 ,8'h6D ,8'h65 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b111001: begin//-7  Mountain time
               temp = {8'h4D ,8'h6F ,8'h75 ,8'h6E ,8'h74 ,8'h61 ,8'h69 ,8'h6E
                       ,8'h20 ,8'h74 ,8'h69 ,8'h6D ,8'h65 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b111010: begin//-6 Central time
               temp = {8'h43 ,8'h65 ,8'h6E ,8'h74 ,8'h72 ,8'h61 ,8'h6C ,8'h20
                       ,8'h74 ,8'h69 ,8'h6D ,8'h65 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b111011: begin//-5  Eastern time
               temp = {8'h45 ,8'h61 ,8'h73 ,8'h74 ,8'h65 ,8'h72 ,8'h6E ,8'h20
                       ,8'h74 ,8'h69 ,8'h6D ,8'h65 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            
            6'b111100: begin//-4  Atlantic time
              temp = {8'h41 ,8'h74 ,8'h6C ,8'h61 ,8'h6E ,8'h74 ,8'h69 ,8'h63
                      ,8'h20 ,8'h74 ,8'h69 ,8'h6D ,8'h65 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b111101: begin//-3  Buenos Aires
              temp = {8'h42 ,8'h75 ,8'h65 ,8'h6E ,8'h6F ,8'h73 ,8'h20 ,8'h41
                      ,8'h69 ,8'h72 ,8'h65 ,8'h73 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            //=====================   0++   ==========================================
            6'b000000: begin//+0   London
              temp = {8'h4C ,8'h6F ,8'h6E ,8'h64 ,8'h6F ,8'h6E ,8'h20 ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b000001: begin//+1   Paris
              temp = {8'h50 ,8'h61 ,8'h72 ,8'h69 ,8'h73 ,8'h20 ,8'h20 ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b000010: begin//+2   Cairo
              temp = {8'h43 ,8'h61 ,8'h69 ,8'h72 ,8'h6F ,8'h20 ,8'h20 ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b000011: begin//+3   Istanbul
              temp = {8'h49 ,8'h73 ,8'h74 ,8'h61 ,8'h6E ,8'h62 ,8'h75 ,8'h6C
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b000111: begin//+7   Bangkok
              temp = {8'h42 ,8'h61 ,8'h6E ,8'h67 ,8'h6B ,8'h6F ,8'h6B ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b001000: begin//+8   Beijing
              temp = {8'h42 ,8'h65 ,8'h69 ,8'h6A ,8'h69 ,8'h6E ,8'h67 ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b001001: begin//+9   Tokyo
              temp = {8'h54 ,8'h6F ,8'h6B ,8'h79 ,8'h6F ,8'h20 ,8'h20 ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end
            6'b001010: begin//+10  Sydney
              temp = {8'h53 ,8'h79 ,8'h64 ,8'h6E ,8'h65 ,8'h79 ,8'h20 ,8'h20
                      ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20 ,8'h20};
            end  
        endcase
    end
    
    //assign to output
    assign lcd_out = temp;
    
endmodule
