`timescale 1ns / 1ps

//  menu module
//  ->controls the menu of the clock

module menu(
    input clock, load_finished,
    input menuBtn, minBtn, plusBtn, offBtn,
    output reg [127:0] menu_top, menu_bot,
    output [5:0] presetHour, presetMin, alarmHour, alarmMin,
    output presetampm, alarmampm, alarm_on,
    output reg menuIntrup, rec, load,
    output is24HrMode
    );
    
    wire [3:0] tempHourL, tempHourR, tempMinuteL, tempMinuteR;
    wire [3:0] tempAlmHourL, tempAlmHourR, tempAlmMinL, tempAlmMinR;
    wire [7:0] hourL, hourR, minuteL, minuteR;
    wire [7:0] hourAlmL, hourAlmR, minAlmL, minAlmR;
    reg [3:0] state = 0;
    reg [5:0] hour = 0, min = 0, almHour = 0, almMin = 0, adjAlmHour = 0;
    reg hrMode = 1, ampm = 0, almAMPM = 0, adjAlmAMPM = 0, alarm = 0;
    
    //extract each digit
    assign tempHourL = hour / 10;
    assign tempHourR = hour % 10;
    assign tempMinuteL = min / 10;
    assign tempMinuteR = min % 10;
    
    assign tempAlmHourL = adjAlmHour / 10;
    assign tempAlmHourR = adjAlmHour % 10;
    assign tempAlmMinL = almMin / 10;
    assign tempAlmMinR = almMin % 10;
    
    //convert current set time to charcode
    number_to_charcode inst1(.in(tempHourL), .out(hourL));
    number_to_charcode inst2(.in(tempHourR), .out(hourR));
    number_to_charcode inst3(.in(tempMinuteL), .out(minuteL));
    number_to_charcode inst4(.in(tempMinuteR), .out(minuteR));
    
    number_to_charcode inst5(.in(tempAlmHourL), .out(hourAlmL));
    number_to_charcode inst6(.in(tempAlmHourR), .out(hourAlmR));
    number_to_charcode inst7(.in(tempAlmMinL), .out(minAlmL));
    number_to_charcode inst8(.in(tempAlmMinR), .out(minAlmR));
    
    //change state
    always@(posedge clock)
    begin
        case(state)
            4'b0000: if(menuBtn) state <= 4'b0001;      //idle -> set time
            4'b0001: if(menuBtn) state <= 4'b0010;      //set time -> 12/24
                     else if(offBtn) state <= 4'b0101;  //set time -> ST submenu 1
            4'b0010: if(menuBtn) state <= 4'b1110;      //12/24 -> set alarm
                     else if(offBtn) state <= 4'b1000;  //12/24 -> toggle am/pm
            4'b0011: if(menuBtn) state <= 4'b0100;      //set alarm -> record alarm
                     else if(offBtn) state <= 4'b1001;  //set alarm -> SA submenu 1
            4'b0100: if(menuBtn) state <= 4'b0000;      //record alarm -> idle
                     else if(offBtn) state <= 4'b1011;  //record alarm -> RA submenu
            4'b0101: if(offBtn) state <= 4'b0110;       //ST submenu 1 -> ST submenu 2
            4'b0110: if(offBtn) state <= 4'b0111;       //ST submenu 2 -> ST load
            4'b0111: if(load_finished) state <= 4'b1101;//ST load -> rec/load end
            4'b1000: state <= 4'b0000;                  //toggle am/pm -> idle
            4'b1001: if(offBtn) state <= 4'b1010;       //SA submenu 1 -> SA submenu 2
            4'b1010: if(offBtn) state <= 4'b0000;       //SA submenu 2 -> idle
            4'b1011: if(menuBtn) state <= 4'b0000;      //RA submenu -> idle
                     else if(plusBtn) state <= 4'b1100; //RA submenu -> start record
            4'b1100: if(plusBtn) state <= 4'b1101;      //start record -> rec/load end
            4'b1101: state <= 4'b0000;                  //rec/load end -> idle
            4'b1110: if(menuBtn) state <= 4'b0011;      //alarm on/off -> set alarm
                     else if(offBtn) state <= 4'b1111;  //alarm on/off -> toggle alarm
            4'b1111: state <= 4'b0000;                  //toggle alarm -> idle
            default: state <= 4'b0000;
        endcase
    end
    
    always@(posedge clock)
    begin
        if(state != 4'b0000) menuIntrup = 1;        //set interrupt to mux
        else menuIntrup = 0;                        //reset on idle
        
        case(state)
            4'b0000: begin      //idle
                hour <= 0;      //reset all temp data
                min <= 0;
                ampm <= 0;
            end
            4'b0001: begin      //set time
                menu_top = {8'h4D, 8'h45, 8'h4E, 8'h55, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                menu_bot = {8'h53, 8'h45, 8'h54, 8'h20, 8'h54, 8'h49, 8'h4D, 8'h45, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            
            4'b0010: menu_bot = {8'h31, 8'h32, 8'h2F, 8'h32, 8'h34, 8'h20, 8'h48, 8'h4F, 8'h55, 8'h52, 8'h20, 8'h4D, 8'h4F, 8'h44, 8'h45, 8'h20};   //12/24
            
            4'b0011: menu_bot = {8'h53, 8'h45, 8'h54, 8'h20, 8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, 8'h20, 8'h54, 8'h49, 8'h4D, 8'h45, 8'h20, 8'h20};   //set alarm
            
            4'b0100: menu_bot = {8'h52, 8'h45, 8'h43, 8'h4F, 8'h52, 8'h44, 8'h20, 8'h41, 8'h4C, 8'h41, 8'h52, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20};   //record alarm
            
            4'b0101: begin      //ST submenu 1
                menu_top = {8'h53, 8'h45, 8'h54, 8'h20, 8'h48, 8'h4F, 8'h55, 8'h52, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                
                if(minBtn) hour = hour - 1;         //add/sub from current time via buttons
                else if(plusBtn) hour = hour + 1;
                
                //24 hour mode
                if(hrMode)
                begin
                    if(hour == 63) hour = 23;
                    else if(hour == 24) hour = 0;
                    
                    menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                end
                
                //12 hour mode
                else
                begin
                    if(hour == 63)
                    begin
                        hour = 11;
                        ampm = ~ampm;
                    end
                    else if(hour == 12)
                    begin
                        hour = 0; 
                        ampm = ~ampm;
                    end
                    
                    if(ampm == 0)
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                    else
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                end
            end
            
            4'b0110: begin      //ST submenu 2
                menu_top = {8'h53, 8'h45, 8'h54, 8'h20, 8'h4D, 8'h49, 8'h4E, 8'h55, 8'h54, 8'h45, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                
                if(minBtn) min = min - 1;           //add/sub from current time via buttons
                else if(plusBtn) min = min + 1;
                
                if(min == 63) min = 59;             //handle overflow/underflow
                else if(min == 60) min = 0;
                
                if(hrMode)
                    menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                else
                    if(ampm == 0)
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                    else
                        menu_bot = {8'h20, 8'h20, hourL, hourR, 8'h3A, minuteL, minuteR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            
            4'b0111: begin      //ST load
                load = 1;       //set load flag (to counters and timezone_adjust)
            end
            
            4'b1000: begin      //toggle AM/PM
                hrMode = ~hrMode;
            end
            
            4'b1001: begin      //SA submenu 1
                menu_top = {8'h53, 8'h45, 8'h54, 8'h20, 8'h48, 8'h4F, 8'h55, 8'h52, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                
                if(minBtn) almHour = almHour - 1;           //add/sub from current time via buttons
                else if(plusBtn) almHour = almHour + 1;
                
                //24 hour mode
                if(hrMode)
                begin
                    almAMPM = 0;
                
                    if(almHour == 63) almHour = 23;
                    else if(almHour == 24) almHour = 0;
                    
                    menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                end
                //12 hour mode
                else
                begin
                    if(almHour == 63)
                    begin
                        almHour = 11;
                        almAMPM = ~almAMPM;
                    end
                    else if(almHour == 12)
                    begin
                        almHour = 0; 
                        almAMPM = ~almAMPM;
                    end
                    
                    if(adjAlmAMPM == 0)
                        menu_bot = {8'h20, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                    else
                        menu_bot = {8'h20, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                end
            end
            
            4'b1010: begin      //SA submenu 2
                menu_top = {8'h53, 8'h45, 8'h54, 8'h20, 8'h4D, 8'h49, 8'h4E, 8'h55, 8'h54, 8'h45, 8'h3A, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                
                if(minBtn) almMin = almMin - 1;             //add/sub from current time via buttons
                else if(plusBtn) almMin = almMin + 1;
                
                if(almMin == 63) almMin = 59;               //handle overflow/underflow
                else if(almMin == 60) almMin = 0;
                
                if(hrMode)
                    menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                else
                    if(adjAlmAMPM == 0)
                        menu_bot = {8'h20, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h41, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                    else
                        menu_bot = {8'h20, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h50, 8'h4D, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            
            4'b1011: begin      //RA submenu
                menu_top = {8'h50, 8'h52, 8'h45, 8'h53, 8'h53, 8'h20, 8'h2B, 8'h20, 8'h54, 8'h4F, 8'h20, 8'h52, 8'h45, 8'h43, 8'h20, 8'h20};
                menu_bot = {8'h4D, 8'h45, 8'h4E, 8'h55, 8'h20, 8'h54, 8'h4F, 8'h20, 8'h43, 8'h41, 8'h4E, 8'h43, 8'h45, 8'h4C, 8'h20, 8'h20};            
            end
            
            4'b1100: begin      //start record
                menu_top = {8'h50, 8'h52, 8'h45, 8'h53, 8'h53, 8'h20, 8'h2B, 8'h20, 8'h54, 8'h4F, 8'h20, 8'h53, 8'h41, 8'h56, 8'h45, 8'h20};
                menu_bot = {8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
                rec = 1;        //set rec flag for ISD1820 to start recording
            end
            
            4'b1101: begin      //rec/load end
                rec = 0;        //reset rec flag to stop recording
                load = 0;       //reset load flag
            end
            
            4'b1110: begin      //alarm on/off
                if(alarm)
                    if(hrMode == 0)
                        if(adjAlmAMPM == 0)
                            menu_bot = {8'h41, 8'h4C, 8'h4D, 8'h20, 8'h4F, 8'h4E, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h41, 8'h4D, 8'h20};
                        else
                            menu_bot = {8'h41, 8'h4C, 8'h4D, 8'h20, 8'h4F, 8'h4E, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h50, 8'h4D, 8'h20};
                     else
                        menu_bot = {8'h41, 8'h4C, 8'h4D, 8'h20, 8'h4F, 8'h4E, 8'h20, hourAlmL, hourAlmR, 8'h3A, minAlmL, minAlmR, 8'h20, 8'h20, 8'h20, 8'h20};       
                else
                    menu_bot = {8'h41, 8'h4C, 8'h4D, 8'h20, 8'h4F, 8'h46, 8'h46, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20, 8'h20};
            end
            
            4'b1111: begin      //toggle alarm
                alarm <= ~alarm;
            end
            
        endcase
    end
    
    //toggle alarm time display between 12/24 hours mode
    always@(*)
    begin
        //24 hours mode
        if(hrMode)
        begin
            if(almAMPM == 1)
                adjAlmHour = almHour + 12;
            else
                adjAlmHour = almHour;
        end
        
        //12 hours mode
        else   
        begin
            if(almHour > 11)
            begin
                adjAlmHour = almHour - 12;
                adjAlmAMPM = 1;
            end
            else
            begin
                adjAlmHour = almHour;
                adjAlmAMPM = almAMPM;
            end
        end
    end
    
    //assign to output
    assign is24HrMode = hrMode;
    assign presetHour = hour;
    assign presetMin = min;
    assign presetampm = ampm;
    assign alarmHour = adjAlmHour;
    assign alarmMin = almMin;
    assign alarmampm = adjAlmAMPM;
    assign alarm_on = alarm;
    
endmodule
