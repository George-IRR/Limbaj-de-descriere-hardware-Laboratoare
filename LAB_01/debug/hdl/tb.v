'timescape 1ns/1ps //unitate de masura / precizia de 1000 de ori mai buna precizia decat um

module test_bench;

localparam BITS 	= 5;		//private, ow val WIDTH din counter
localparam CLK_PER_NS 	= 5;	//clock period nanosec

reg clk, rst_n
wire [BITS-1:0] cnt			//nu are legatura cu WIDTH

counter #(					//pt parametrii
.WIDTH 		(BITS)			// 3 bistabile , un registru de 3 biti
)(
.clk_i		(clk	),		//fara sufix pentru ca este intern
.reset_ni	(reset_n),

.cnt_o		(cnt	)
);

initial begin
	clk = 0;
	forever #(CLK_PER_NS/2.0) clk = ~clk;	//.0 pentru a forta sa fie nr real
	
end
