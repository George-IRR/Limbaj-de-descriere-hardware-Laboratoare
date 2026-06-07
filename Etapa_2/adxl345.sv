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


// Instruction packet for ADXL345 SPI communication
typedef struct packed {
    logic       OPCODE;
    logic       MB;
    logic [5:0] ADDRESS;
    logic [7:0] DATA;
} instr_t;

// Program Counter States
typedef enum logic [2:0] {
    STATE_DATA_FORMAT = 3'd0,
    STATE_POWER_CTL   = 3'd1,
    STATE_DATA_X0     = 3'd2,
    STATE_DATA_X1     = 3'd3,
    STATE_DATA_Y0     = 3'd4,
    STATE_DATA_Y1     = 3'd5
} pc_t;


// ADXL345 Register Addresses
localparam logic [5:0] REG_DATA_FORMAT = 6'h31;
localparam logic [5:0] REG_POWER_CTL   = 6'h2D;
localparam logic [5:0] REG_DATA_X0     = 6'h32;
localparam logic [5:0] REG_DATA_X1     = 6'h33;
localparam logic [5:0] REG_DATA_Y0     = 6'h34;
localparam logic [5:0] REG_DATA_Y1     = 6'h35;

// Configuration Values
localparam logic [7:0] VAL_DATA_FORMAT = 8'h48; // Full resolution, +/-2g
localparam logic [7:0] VAL_POWER_CTL   = 8'h08; // Enable measure mode

// SPI Operation Opcodes
localparam logic OP_WRITE = 1'b0;
localparam logic OP_READ  = 1'b1;

localparam logic SPI_SINGLE_BYTE = 1'b0;
localparam logic SPI_MULTI_BYTE  = 1'b1;

localparam int NUM_INSTR = 6;

localparam instr_t INITIALIZATION_PROG [NUM_INSTR] = '{
    '{OPCODE: OP_WRITE, MB: SPI_SINGLE_BYTE, ADDRESS: REG_DATA_FORMAT, DATA: VAL_DATA_FORMAT},
    '{OPCODE: OP_WRITE, MB: SPI_SINGLE_BYTE, ADDRESS: REG_POWER_CTL,   DATA: VAL_POWER_CTL},
    '{OPCODE: OP_READ,  MB: SPI_SINGLE_BYTE, ADDRESS: REG_DATA_X0,     DATA: 8'h00},
    '{OPCODE: OP_READ,  MB: SPI_SINGLE_BYTE, ADDRESS: REG_DATA_X1,     DATA: 8'h00},
    '{OPCODE: OP_READ,  MB: SPI_SINGLE_BYTE, ADDRESS: REG_DATA_Y0,     DATA: 8'h00},
    '{OPCODE: OP_READ,  MB: SPI_SINGLE_BYTE, ADDRESS: REG_DATA_Y1,     DATA: 8'h00}
};

// Signals & Registers
instr_t current_instr;
pc_t    PC;

logic ack_prev;
logic [7:0] data_x0, data_x1, data_y0, data_y1;

// Instruction Logic
assign req_o         = PC < NUM_INSTR;
assign rw_no         = current_instr.OPCODE;
assign addr_i        = current_instr.ADDRESS;
assign wr_data_o     = current_instr.DATA;
assign current_instr = (PC < NUM_INSTR) ? INITIALIZATION_PROG[PC] : '0;

// Program Counter State Machine
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        PC       <= STATE_DATA_FORMAT;
        ack_prev <= 1'b0;
    end else begin
        ack_prev <= ack_i;
        if (!ack_prev && ack_i) begin
            if ( PC == STATE_DATA_Y1 )
					PC   <= STATE_DATA_X0;
				else
					PC <= pc_t'(PC + 1'b1);
        end
    end
end

// Data Acquisition
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_x0 <= 8'b0;
        data_x1 <= 8'b0;
        data_y0 <= 8'b0;
        data_y1 <= 8'b0;
    end else begin
        if (!ack_prev && ack_i) begin
            case (PC)
                STATE_DATA_X0: data_x0 <= rd_data_i;
                STATE_DATA_X1: data_x1 <= rd_data_i;
                STATE_DATA_Y0: data_y0 <= rd_data_i;
                STATE_DATA_Y1: data_y1 <= rd_data_i;
                default: ; 
            endcase
        end
    end
end

assign x_data_o = {data_x1, data_x0};
assign y_data_o = {data_y1, data_y0};

endmodule