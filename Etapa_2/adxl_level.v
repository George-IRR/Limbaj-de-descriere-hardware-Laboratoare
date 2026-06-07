module adxl_level #(
    parameter DISP_X = 6,
	 parameter DISP_Y = 2
)(
    input signed 					 [15:0] data_xi ,
	 input signed 					 [15:0] data_yi ,
    output       [$clog2(DISP_X)-1:0] column_o,
	 output 		  [$clog2(DISP_Y)-1:0] row_o	  
);

wire signed [15:0] raw_x_position;
wire signed [15:0] raw_y_position;



assign raw_x_position = ((data_xi + 200) * DISP_X) / 400;

assign column_o = (raw_x_position < 0)  ? 0 		  			   : 
                  (raw_x_position >= DISP_X) ? (DISP_X - 1) : 
                   raw_x_position[$clog2(DISP_X)-1:0]      	; 
						 

assign raw_y_position = ((data_yi + 200) * DISP_Y) / 400;

assign row_o = (raw_y_position < 0)  ? 0 		  			   : 
                  (raw_y_position >= DISP_Y) ? (DISP_Y - 1) : 
                   raw_y_position[$clog2(DISP_Y)-1:0]      	; 
						 
endmodule