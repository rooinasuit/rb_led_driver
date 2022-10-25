`timescale 1ns / 1ps

module SlowCLK(
     input             CLK,
     input             CLR,
     output            CE_O
    );
    
    reg [17:0] SCK;
    
    always @ (posedge CLK) begin
        if (CLR)
            SCK <= 18'd0;
        else if (SCK > 18'd200000)
            SCK <= 18'd0;            
        else 
            SCK <= SCK + 1;        
    end
    
    assign CE_O = (SCK == 18'd200000); // preskaler nadaje CEO o f = 500Hz przy CLK = 100MHz
endmodule
