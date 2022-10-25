`timescale 1ns / 1ps

module DisplayControl(
    input 			CLK,
	input 			CLR,
	input           CE_IN,
	input     [1:0] H1,
	input     [3:0] RED_DUTY,    
    input     [3:0] GREEN_DUTY,    
    input     [3:0] BLUE_DUTY,
	output reg [3:0] SEG,       // wybor aktywacji danej sekcji wyswietlacza
	output reg [7:0] DISP       // wyswietlanie informacji na danym wyswietlaczu
    );
    
    reg [1:0] ANODE_TGL = 2'd0; // licznik aktywacji 1 z 4 wyswietlaczy
    reg [3:0] H1_BCD;           // kod HOT_ONE przeksztalcony na BCD
    reg [3:0] COL_DUTY;         // duty cycle wybranego koloru gotowy do zdekodowania na wyswietlacz
    reg [3:0] TENS;             // warunek '1' lub '0' na miejscu dziesietnym duty cycle
    reg [3:0] PRE_DISP;
        
    always @ (posedge CLK) begin
        if (CLR)
            ANODE_TGL <= 2'd0;
        else if (CE_IN)
            ANODE_TGL <= ANODE_TGL + 1;
    end
    
    always @ (posedge CLK) begin
        if (CLR)
            TENS <= 4'd0;
        else if (CE_IN) begin
            if (COL_DUTY == 4'b1010)
                TENS <= 4'b0001;
            else TENS <= 4'b0000;
        end
    end
    
    always @ (posedge CLK) begin
        if (CLR)
            PRE_DISP <= 4'd0;
        else if(CE_IN)
            case (ANODE_TGL)
                2'b00 : begin
                    PRE_DISP <= H1_BCD; end
                2'b01 : begin
                    PRE_DISP <= 4'b1111; end
                2'b11 : begin
                    PRE_DISP <= TENS; end
                2'b10 : begin
                    PRE_DISP <= COL_DUTY; end
                default : PRE_DISP <= 4'b0000;
            endcase      
    end
    
    always @ (posedge CLK) begin
        if (CLR)
            SEG <= 4'd0111;
        else if (CE_IN)
            case (ANODE_TGL)
                2'b00 : SEG <= 4'b0111;   // sekcja 0
                2'b01 : SEG <= 4'b1011;   // sekcja 1
                2'b10 : SEG <= 4'b1101;   // sekcja 2
                2'b11 : SEG <= 4'b1110;   // sekcja 3
                default : SEG <= 4'b0111; // domyslnie sekcja 0
            endcase    
    end

    always @ (posedge CLK) begin
        if (CLR)
            H1_BCD <= 4'd0;
        else if (CE_IN)
            case (H1)
                2'b00 : H1_BCD <= 4'b0000; // 0, nic
                2'b01 : H1_BCD <= 4'b0001; // 1, RED
                2'b10 : H1_BCD <= 4'b0010; // 2, GREEN
                2'b11 : H1_BCD <= 4'b0011; // 3, BLUE
                default : H1_BCD <= 4'b0000; // 0, nic
            endcase
    end
    
    always @ (posedge CLK) begin
        if (CLR)
            COL_DUTY <= 4'd0;
        else if (CE_IN)
            case (H1_BCD)
                4'b0000 : begin
                    COL_DUTY <= 4'b0000; end
                4'b0001 : begin
                    COL_DUTY <= RED_DUTY; end
                4'b0010 : begin
                    COL_DUTY <= GREEN_DUTY; end
                4'b0011 : begin
                    COL_DUTY <= BLUE_DUTY; end
                default : COL_DUTY <= 4'b0000;
            endcase
    end
    
    always @ (posedge CLK) begin
        if (CLR)
            DISP <= 8'b00000011;
        else if (CE_IN)
            case (PRE_DISP)
                4'b0000 : DISP <= 8'b00000011; // 0
                4'b0001 : DISP <= 8'b10011111; // 1
                4'b0010 : DISP <= 8'b00100101; // 2
                4'b0011 : DISP <= 8'b00001101; // 3
                4'b0100 : DISP <= 8'b10011001; // 4
                4'b0101 : DISP <= 8'b01001001; // 5
                4'b0110 : DISP <= 8'b01000001; // 6
                4'b0111 : DISP <= 8'b00011111; // 7
                4'b1000 : DISP <= 8'b00000001; // 8
                4'b1001 : DISP <= 8'b00001001; // 9
                4'b1010 : DISP <= 8'b00000011; // 10, gdzie wyswietlane jest '0'
                4'b1111 : DISP <= 8'b11111101; // -
                default : DISP <= 8'b00000011; // 0          
            endcase
    end
     
endmodule
