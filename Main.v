`timescale 1ns / 1ps

module Main(
    input 			CLK,
	input 			CLR,
	input 			SEL_IN,
	input 			INCR_IN,
	input           DIR_IN,
	output wire [3:0] SEG,
	output wire [7:0] DISP,
	output wire RED_OUT,
	output wire GREEN_OUT,
	output wire BLUE_OUT
    );
    
    wire CE_O;
    
    wire SEL_OUT;
    wire INCR_OUT;
    wire DIR_OUT;
    
    wire DIR_CNT;
    wire [3:0] MAIN_CNT;
    
    wire [1:0] ONE_COLOR;
    
    wire [3:0] RED_CNT;
    wire [3:0] GREEN_CNT;
    wire [3:0] BLUE_CNT;
    
    SlowCLK Prescaler(
        .CLK (CLK),
        .CLR (CLR),
        .CE_O (CE_O)
    );
    
    MainNdir TwoCounters(
        .CLK (CLK),
        .CLR (CLR),
        .CE_IN (CE_O),
        .DIR (DIR_OUT),
        .DIR_CNT (DIR_CNT),
        .MAIN_CNT (MAIN_CNT)
    );
    
    Debounce Select(
        .CLK (CLK),
        .CLR (CLR),
        .CE_IN (CE_O),
        .KEY_IN (SEL_IN),
        .KEY_OUT (SEL_OUT)
    );

    Debounce Increment(
        .CLK (CLK),
        .CLR (CLR),
        .CE_IN (CE_O),
        .KEY_IN (INCR_IN),
        .KEY_OUT (INCR_OUT)
    );    
    
    Debounce Direction(
        .CLK (CLK),
        .CLR (CLR),
        .CE_IN (CE_O),
        .KEY_IN (DIR_IN),
        .KEY_OUT (DIR_OUT)
    );

    ColorSel ColorSelect(
        .CLK (CLK),
        .CLR (CLR),
        .CE_IN (CE_O),
        .SEL (SEL_OUT),
        .H1 (ONE_COLOR)
    );
    
    ColorCompare Red(
        .CLK (CLK),
        .CLR (CLR),
        .INCR (INCR_OUT),
        .DIR_CNT (DIR_CNT),
        .MAIN_CNT (MAIN_CNT),
        .H1 (ONE_COLOR == 2'd1),
        .COL_CNT (RED_CNT),
        .LED_OUT (RED_OUT)
    );
    
    ColorCompare Green(
        .CLK (CLK),
        .CLR (CLR),
        .INCR (INCR_OUT),
        .DIR_CNT (DIR_CNT),
        .MAIN_CNT (MAIN_CNT),
        .H1 (ONE_COLOR == 2'd2),
        .COL_CNT (GREEN_CNT),
        .LED_OUT (GREEN_OUT)
    );
    
    ColorCompare Blue(
        .CLK (CLK),
        .CLR (CLR),
        .INCR (INCR_OUT),
        .DIR_CNT (DIR_CNT),
        .MAIN_CNT (MAIN_CNT),
        .H1 (ONE_COLOR == 2'd3),
        .COL_CNT (BLUE_CNT),
        .LED_OUT (BLUE_OUT)
    );
    
    DisplayControl SevenSeg(
        .CLK (CLK),
        .CLR (CLR),
        .CE_IN (CE_O),
        .H1 (ONE_COLOR),
        .RED_DUTY (RED_CNT),
        .GREEN_DUTY (GREEN_CNT),
        .BLUE_DUTY (BLUE_CNT),
        .SEG (SEG),
        .DISP (DISP)
    );
endmodule
