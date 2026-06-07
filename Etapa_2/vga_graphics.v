module vga_graphics #(
	parameter WIDTH = 10
)(
	input                  clk_i     ,
	input                  rst_ni    ,
	input                  vid_actv_i,
	input      [WIDTH-1:0] pixel_xi  ,
	input      [WIDTH-1:0] pixel_yi  ,
	output reg 		  [3:0] vga_r_o   ,
	output reg 		  [3:0] vga_g_o   ,
	output reg 		  [3:0] vga_b_o   ,
	
	input  signed 	 [15:0] data_xi	,
	input  signed 	 [15:0] data_yi	,
	input 					  vsync_i
);

localparam CH_W 	  = 15 ;
localparam CH_H 	  = 15 ;

localparam X_CENTER = 320;
localparam Y_CENTER = 240;
localparam X_RES 	  = 640;
localparam Y_RES 	  = 480;

wire [WIDTH-1:0] obj_x, obj_y;

wire [$clog2(X_CENTER):0] column;
wire [$clog2(Y_CENTER):0] row;


adxl_level #(
   .DISP_X(X_RES),
	.DISP_Y(Y_RES)
	
) level (
    .data_xi  ( data_xi ),
	 .data_yi  ( data_yi ),
    .column_o ( column ),
	 .row_o	  ( row	  )
);
reg [WIDTH-1:0] obj_x_stable;
reg [WIDTH-1:0] obj_y_stable;

always @(posedge vsync_i or negedge rst_ni) begin
    if (!rst_ni) begin
       obj_x_stable <= X_CENTER;
		 obj_y_stable <= Y_CENTER;
    end else begin
        obj_x_stable <= column;
		  obj_y_stable <= row;
    end
end

assign obj_x = obj_x_stable;
assign obj_y = obj_y_stable;

wire   obj_active;
assign obj_active = (pixel_xi + CH_W/2 >= obj_x) && (pixel_xi <= obj_x + CH_W/2) &&
                    (pixel_yi + CH_H/2 >= obj_y) && (pixel_yi <= obj_y + CH_H/2);
						  
always @(*) begin
	if (!vid_actv_i) begin
		vga_r_o = 4'h0;
		vga_g_o = 4'h0;
		vga_b_o = 4'h0;
	end else begin
		if (obj_active) begin
			vga_r_o = 4'hF;
			vga_g_o = 4'h0;
			vga_b_o = 4'hF;
		end else begin
			vga_r_o = 4'h0;
			vga_g_o = 4'h0;
			vga_b_o = 4'h4;
		end
	end
end

endmodule