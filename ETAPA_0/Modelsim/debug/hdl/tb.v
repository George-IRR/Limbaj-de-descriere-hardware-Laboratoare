`timescale 1ns/1ps 

module test_bench;

localparam LED			= 10;
localparam BITS       	= 3;
localparam CLK_PER_NS 	= 5;
localparam CLK_FREQ     = 10;
localparam UPDATE_HZ    = 2;


reg clk, rst_n;                   
wire [BITS-1:0] 	cnt;

wire [2:0]          column;
wire                row;

// Instantierea modulului
seq_counter #(
    .CLK_FREQ       (CLK_FREQ),
    .UPDATE_HZ      (UPDATE_HZ),                      
    .WIDTH        	(BITS	),
	.LED_WIDTH 		(LED 	)
) dut (                           
    .clk_i        	(clk  	),
    .rst_ni       	(rst_n	),
    .column_o       (column),
    .row_o          (row)
);

// Generarea semnalului de ceas
initial begin
    clk = 0;
    forever #(CLK_PER_NS/2.0) clk = ~clk;    // .0 pentru a forta sa fie nr real
end

// Secventa de test
initial begin
    // Secvența de reset
    rst_n = 1;              // reset activ
    #(CLK_PER_NS * 10);      // asteptam cateva perioade de ceas 
    rst_n = 0;              // reset dezactivat
	
	#(CLK_PER_NS * 6);
	
	rst_n = 1;        
	#(CLK_PER_NS * 2);        
	
	
	#(CLK_PER_NS * 300);
	
	$stop;
end

endmodule