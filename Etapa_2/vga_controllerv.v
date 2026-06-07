module vga_controller #(
	parameter WIDTH = 10
)(
	input  		  		 clk_i	 		,
	input  		  		 rst_ni	 		,
	output 		  		 h_sync_o 		,
	output 		  		 v_sync_o 		,
	output 		  		 video_active_o,
	output [WIDTH-1:0] pixel_x_o		,
	output [WIDTH-1:0] pixel_y_o
);

localparam ON    		=  1'b1	;
localparam OFF   		=  1'b0	;
localparam ON_N    	=  1'b0	;
localparam OFF_N   	=  1'b1	;

localparam H_CNT 		=   'd799;
localparam V_CNT 		=   'd524;

localparam X_RES		=   'd640;
localparam Y_RES		=   'd480;

localparam HS_START  = 10'd656;
localparam HS_STOP   = 10'd751;
localparam VS_START  = 10'd490;
localparam VS_STOP   = 10'd491;

wire v_cnt_en;

assign v_cnt_en = pixel_x_o == H_CNT ? ON : OFF;

assign h_sync_o = ( pixel_x_o >= HS_START && pixel_x_o <= HS_STOP ) ? ON_N : OFF_N;
assign v_sync_o = ( pixel_y_o >= VS_START && pixel_y_o <= VS_STOP ) ? ON_N : OFF_N;

assign video_active_o = ( pixel_x_o < X_RES && pixel_y_o < Y_RES) ? ON : OFF;

counter #(
	.WIDTH(WIDTH)
) h_counter (
	.clk_i	 ( clk_i		 ),
	.rst_ni   ( rst_ni	 ),
	.en_i	    ( ON    	 ),
	.stop_cnt ( H_CNT   	 ),
	.cnt_o	 ( pixel_x_o )
);

counter #(
	.WIDTH(WIDTH)
) v_counter (
	.clk_i	 ( clk_i		 ),
	.rst_ni   ( rst_ni	 ),
	.en_i	    ( v_cnt_en  ),
	.stop_cnt ( V_CNT 	 ),
	.cnt_o	 ( pixel_y_o )
);

endmodule	