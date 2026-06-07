module adxl345 (
    input  logic       	clk,
    input  logic       	rst_n,
	 
	 input  logic [7:0]  rd_data_i,
	 output logic 			req_o,
	 output logic 			rw_no,
	 output logic [5:0] 	addr_i,
	 output logic [7:0]	wr_data_o,
	 input  logic 			ack_i,
	 
	 output logic [15:0] x_data_o,
	 output logic [15:0] y_data_o
);


typedef struct packed {
    logic       OPCODE;
    logic       MB;
    logic [5:0] ADDRESS;
    logic [7:0] DATA;
} instr_t;

localparam int NUM_INSTR = 6;
localparam instr_t INITIALIZATION_PROG [NUM_INSTR] = '{
    '{OPCODE: 1'b0, MB: 1'b0, ADDRESS: 6'h31, DATA: 8'h48}, // DATA_FORMAT
    '{OPCODE: 1'b0, MB: 1'b0, ADDRESS: 6'h2D, DATA: 8'h08}, // POWER_CTL
	 
	 '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h32, DATA: 8'h00}, // PC = 2: DATAX0
    '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h33, DATA: 8'h00}, // PC = 3: DATAX1
    '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h34, DATA: 8'h00}, // PC = 4: DATAY0
    '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h35, DATA: 8'h00}  // PC = 5: DATAY1
};

instr_t current_instr;

assign req_o		= PC < NUM_INSTR;

assign rw_no		= current_instr.OPCODE	;
assign addr_i		= current_instr.ADDRESS	;
assign wr_data_o 	= current_instr.DATA		;

logic [$clog2(NUM_INSTR):0] PC;
logic ack_prev;

assign current_instr = (PC < NUM_INSTR) ? INITIALIZATION_PROG[PC] : '0;

// Logica Program Counter
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        PC       <= '0;
        ack_prev <= '0;
    end else begin
        ack_prev <= ack_i;
        if (!ack_prev && ack_i) begin
            if ( PC == 5 )
					PC   <= 2;
				else
					PC <= PC + 1;
        end
    end
end

logic [7:0] data_x0, data_x1, data_y0, data_y1;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_x0 <= '0;
        data_x1 <= '0;
        data_y0 <= '0;
        data_y1 <= '0;
    end else begin
        if (!ack_prev && ack_i) begin
            case (PC)
                2: data_x0 <= rd_data_i;
                3: data_x1 <= rd_data_i;
                4: data_y0 <= rd_data_i;
                5: data_y1 <= rd_data_i;
                default: ; 
            endcase
        end
    end
end

assign x_data_o = {data_x1, data_x0};
assign y_data_o = {data_y1, data_y0};

endmodule