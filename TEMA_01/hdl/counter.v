module counter #(
parameter WIDTH			= 28,		//cat de lung sa fie delay-ul
parameter LED_WIDTH 	= 3,
parameter CNT_STOP		= 10		//tacte
)(
	input						clk_i,
	input						rst_ni,
	output reg [WIDTH-1:0]		cnt_o,

	wire [LED_WIDTH-1:0]		LED_Lenght,
	output reg [LED_WIDTH-1:0]	led_o
);

always @(posedge clk_i or negedge rst_ni) begin
if (!rst_ni) cnt_o <= 0; else

if (cnt_o == CNT_STOP) cnt_o <= 0; else
	cnt_o <= cnt_o + 1;

end

reg last_led = 0;

assign LED_Lenght = (1 << LED_WIDTH - 1) ;

always @(posedge clk_i or negedge rst_ni) begin
if (!rst_ni) begin
	led_o[0] 	<= 1;
	led_o[7:1]	<=0	;
	last_led 	<= 0; 
	end else

if (!cnt_o && !last_led ) 				led_o <= led_o << 1; else

if (!cnt_o && last_led && !led_o[0]) 	led_o <= led_o >> 1;

end

always @(posedge clk_i or negedge rst_ni) begin
if 	(!rst_ni) begin
											led_o[0] 	<= 1;
											led_o[7:1]	<=0	; end else
					
if	( (cnt_o == CNT_STOP) && (led_o[0]) ) 	last_led <= 0; else
if 	( (led_o == LED_Lenght) && !last_led) 	last_led <= 1;

end


endmodule

