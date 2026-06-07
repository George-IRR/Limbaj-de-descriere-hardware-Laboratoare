module counter #(
	parameter WIDTH = 10
)(
	input  					   clk_i	  ,
	input  					   rst_ni  ,
	input  					   en_i	  ,
	input  	  [WIDTH-1:0]	stop_cnt,
	output reg [WIDTH-1:0]	cnt_o		
);

always @(posedge clk_i or negedge rst_ni)
begin
	if(!rst_ni) cnt_o <= 0;
	else if (en_i) begin
		if 	  (cnt_o <  stop_cnt) cnt_o <= cnt_o + 1;
		else if (cnt_o >= stop_cnt) cnt_o <= 0;
	end
end

endmodule