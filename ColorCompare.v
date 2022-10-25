`timescale 1ns / 1ps

module ColorCompare
(
    input 			CLK,
	input 			CLR,
	input           INCR,              // sygnal zliczania z debouncera
	input           DIR_CNT,           // sygnal z licznika kierunku zliczania
	input     [3:0] MAIN_CNT,          // glowny licznik do porownywania duty cycle z kolorami RGB  
	input     [1:0] H1,                // rejestr HOT-ONE selekcji koloru do zmiany duty cycle 
	output reg [3:0] COL_CNT = 4'd0,   // sygnal z licznika duty cycle wybranego koloru
	output          LED_OUT            // sygnal z komparatora wybranego koloru wprost na LED'a
);
    
    always @ (posedge CLK) begin // układ inkrementacji/dekrementacji duty cycle wybranego koloru
        if (CLR)
            COL_CNT <= 4'd0;
        else if (H1 & INCR & ~DIR_CNT)
            COL_CNT <= COL_CNT + 1;
        else if (H1 & INCR & DIR_CNT)
            COL_CNT <= COL_CNT - 1;
        else if (COL_CNT == 10 & H1 & ~DIR_CNT) COL_CNT <= 4'd0;
        else if (COL_CNT == 0 & H1 & DIR_CNT) COL_CNT <= 4'd10;
    end
    
    assign LED_OUT = (MAIN_CNT < COL_CNT) ? 1:0; // wystawia '0' na okres duty cycle (wsp. anoda)
endmodule
