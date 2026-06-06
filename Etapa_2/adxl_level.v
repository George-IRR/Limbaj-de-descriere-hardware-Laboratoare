module adxl_level #(
    parameter N = 6
)(
    input signed [15:0]          data_xi ,
    output       [$clog2(N)-1:0] column_o
);
	
wire signed [15:0] raw_position;

assign raw_position = (data_xi >>> N)+3;

assign column_o = (raw_position < 0) ? 0 : 
                  (raw_position >= N) ? (N - 1) : 
                  raw_position;
endmodule