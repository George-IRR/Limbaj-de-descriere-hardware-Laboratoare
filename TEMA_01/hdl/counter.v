module counter #(
parameter WIDTH		= 3,
parameter LED_WIDTH = 3
)(
	input						clk_i,
	input						rst_ni,
	
	output reg [WIDTH-1:0]		cnt_o,
	output reg [LED_WIDTH-1:0]	led_o
);

always @(posedge clk_i or negedge rst_ni) begin
if (~rst_ni) cnt_o <= 0; else
	cnt_o <= cnt_o + 1;

end

/*
always @(posedge clk_i or negedge rst_ni) begin
if (~rst_ni) led_o <= 0; else
	led_o <=   led_o  + 1;

end
*/

always @(posedge clk_i or negedge rst_ni) begin
if (~rst_ni) led_o <= 0; else
if (cnt_o == 0)	led_o <= led_o + 1;

end


endmodule