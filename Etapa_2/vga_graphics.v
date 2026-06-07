module vga_graphics #(
	parameter WIDTH = 10
)(
	input 				 clk_i	  ,
	input 				 rst_ni    ,
	input 		       vid_actv_i,
	input  [WIDTH-1:0] pixel_xi  ,
	input  [WIDTH-1:0] pixel_yi  ,
	output [3:0] 		 vga_r_o   ,
	output [3:0] 		 vga_g_o   ,
	output [3:0] 		 vga_b_o   
);

assign vga_r_o = ( vid_actv_i ) ? 4'hF : 4'h0;
assign vga_g_o = ( vid_actv_i ) ? 4'hF : 4'h0;
assign vga_b_o = ( vid_actv_i ) ? 4'hF : 4'h0;


endmodule