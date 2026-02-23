`timescale 1ns/1ps 

module test_bench;

localparam LED			= 2; 
localparam BITS       	= 28;        
localparam CLK_PER_NS 	= 5;        

reg clk, rst_n;                   
wire [BITS-1:0] 	cnt;
wire [LED-1:0] 		led;

// Instantierea modulului
counter #(                        
    .WIDTH        	(BITS	),
	.LED_WIDTH 		(LED 	)
) dut (                           
    .clk_i        	(clk  	),
    .rst_ni       	(rst_n	),
    .cnt_o        	(cnt  	),
	.led_o			(led	)
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
    #(CLK_PER_NS * 2);      // asteptam 2 perioade de ceas (10 ns)
    rst_n = 0;              // reset dezactivat
	
	#(CLK_PER_NS * 2);
	
	rst_n = 1;        
	#(CLK_PER_NS * 2);        
	
	
	#(CLK_PER_NS * 100);
	
	$stop;
end

endmodule