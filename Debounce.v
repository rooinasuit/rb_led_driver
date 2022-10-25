`timescale 1ns / 1ps

module Debounce (
	input 			CLK,
	input 			CLR,
	input 			CE_IN, // CE z preskalera
	input           KEY_IN, // dana wejsciowa
	output 			KEY_OUT // moment bramki AND dla &P_OUT[2:0] z ~P_OUT[3] ('1' tylko przez chwile po wcisnieciu)
);
	
	reg [3:0] P_OUT; // pierwsze 3 pozycje normalnie, 4. pozycja odwrocona

   always @(posedge CLK)
	begin
		if(CLR)
			P_OUT <= 4'd0;
		else if (CE_IN)
				P_OUT <= {P_OUT[2:0],KEY_IN};
	end
				
	assign KEY_OUT = (&P_OUT[2:0]) & ~P_OUT[3] & CE_IN; // kiedy sygnal '1' wejdzie dopiero na pierwsze 3 pozycje rejestru, a wiec ~P_OUT[3] == 1
endmodule
