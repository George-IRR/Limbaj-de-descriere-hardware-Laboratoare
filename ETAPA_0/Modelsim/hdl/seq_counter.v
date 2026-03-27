module seq_counter #(
    parameter CLK_FREQ      = 50_000_000,
    parameter UPDATE_HZ     = 2,        
    parameter DISP_WIDTH    = 10
)(
    input    				clk_i,
    input    				rst_ni,
    
    output reg [2:0]    column_o,
    output reg          row_o
);

localparam CNT_STOP = CLK_FREQ / UPDATE_HZ;
localparam WIDTH = $clog2(CLK_FREQ);

reg [WIDTH-1:0] cnt_o;
wire            tick_w = (cnt_o == CNT_STOP - 1);

always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni)     cnt_o <= 0;
    else if (tick_w) cnt_o <= 0;
    else             cnt_o <= cnt_o + 1;

	 
always @(posedge clk_i or negedge rst_ni)
    if 				(!rst_ni) 										row_o <= 1'b0;
    else if 		(tick_w)
         if 		(row_o == 1'b0 && column_o == 3'b101) 	row_o <= 1'b1;
         else if 	(row_o == 1'b1 && column_o == 3'b000) 	row_o <= 1'b0;
		  
		  
always @(posedge clk_i or negedge rst_ni)
    if 			  	(!rst_ni) 										column_o <= 3'd0;
    else if 	  	(tick_w)
         if 	  	(row_o == 1'b0 && column_o != 3'b101) 	column_o <= column_o + 1'b1;
         else if 	(row_o == 1'b1 && column_o != 3'b000)  column_o <= column_o - 1'b1;

endmodule