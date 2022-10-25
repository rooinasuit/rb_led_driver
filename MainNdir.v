`timescale 1ns / 1ps

module MainNdir(
    input 			CLK,
	input 			CLR,
	input           CE_IN,        // CE z preskalera
	input           DIR,          // sygnal zmiany kierunku zliczania z debouncera
	output reg      DIR_CNT = 0,  // licznik kierunku zliczania ('1' to dekrementacja, '0' to inkrementacja)
	output reg [3:0] MAIN_CNT = 0 // glowny licznik do porownywania duty cycle z kolorami RGB 
    );
    
    always @ (posedge CLK) begin
        if (CLR)
            DIR_CNT <= 1'd0;
        else if (DIR & CE_IN)
            DIR_CNT <= ~DIR_CNT;
    end
    
    always @ (posedge CLK) begin
        if (CLR)
            MAIN_CNT <= 4'd0;
        else if (CE_IN)
            MAIN_CNT <= MAIN_CNT + 1;
        else if (MAIN_CNT > 4'b1001)
            MAIN_CNT <= 4'd0;
    end

endmodule
