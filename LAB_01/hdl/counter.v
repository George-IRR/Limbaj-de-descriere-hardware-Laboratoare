module counter #(						//pt parametrii
WIDTH = 3								// 3 bistabile , un registru de 3 biti
)(
	input 					clk_i,		//sufix pentru directie (input)
	input 					reset_ni,	//ni - negate input
	
	output reg [WIDTH-1:0] 	cnt_o,	
);

always @(posedge clk_i or negedge rst_ni) begin
if (~rst_ni) cnt_o <= 0; else			//pt circuite secventiale
	cnt_o <= cnt_o + 1; 

end
