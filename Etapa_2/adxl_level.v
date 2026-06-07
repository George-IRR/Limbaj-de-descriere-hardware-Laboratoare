module adxl_level #(
    parameter N = 4
)(
    input signed [15:0]          data_xi ,
	 input signed [15:0]   	 		data_yi ,
    output       [$clog2(N)-1:0] column_o,
	 output 		  						row_o	  
);

wire signed [15:0] raw_position;

assign raw_position = ((data_xi + 200) * N) / 400;

assign row_o = data_yi[15];

assign column_o = (raw_position < 0)  ? 0 : 
                  (raw_position >= N) ? (N - 1) : 
                  raw_position[$clog2(N)-1:0];


endmodule