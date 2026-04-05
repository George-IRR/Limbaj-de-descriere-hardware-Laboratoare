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

wire [7:0]          HEX0;
wire [7:0]          HEX1;
wire [7:0]          HEX2;
wire [7:0]          HEX3;
wire [7:0]          HEX4;
wire [7:0]          HEX5;


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

display #(
) display_dut(
    .clk_i      (clk),
    .rst_ni     (rst_n),
    .column_i   (column),
    .row_i      (row),
    .HEX0       (HEX0),
    .HEX1       (HEX1),
    .HEX2       (HEX2),
    .HEX3       (HEX3),
    .HEX4       (HEX4),
    .HEX5       (HEX5)

);

initial begin
    clk = 0;
    forever #(CLK_PER_NS/2.0) clk = ~clk;    // Using .0 to force real-number (floating-point) division
end

// test seq
initial begin
    rst_n = 1;              
    #(CLK_PER_NS * 10);     
    rst_n = 0;              
	
	#(CLK_PER_NS * 6);
	
	rst_n = 1;        
	#(CLK_PER_NS * 2);        
	
	
	#(CLK_PER_NS * 300);
	
	$stop;
end

endmodule