`timescale 1ns / 1ps

module ColorSel(
    input 			CLK,
	input 			CLR,
	input           CE_IN, // CE z preskalera
	input    		SEL,   // dana wejsciowa
	output reg [1:0] H1    // rejestr HOT-ONE selekcji koloru do zmiany duty cycle
    );
    
    always @ (posedge CLK) begin // układ selekcji koloru do zmiany duty cycle
		if(CLR)
			H1 <= 2'd0;
		else if (SEL & CE_IN)
		    H1 <= H1 + 1;
		else if (SEL & CE_IN & H1 > 2'd3)
		    H1 <= 2'd0;
    end
endmodule
