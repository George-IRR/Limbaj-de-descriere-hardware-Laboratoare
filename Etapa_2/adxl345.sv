module adxl345 (
    input  logic       clk,
    input  logic       rst_n,
    output logic       spi_cs_n,
    output logic       spi_clk,
    output logic       spi_sdi,
    input  logic       spi_sdo,
    input  logic       spi_clk_ref,
    output logic [15:0] x_data 
);

// Definiții tipuri și program (din pașii anteriori)
typedef struct packed {
    logic       OPCODE;
    logic       MB;
    logic [5:0] ADDRESS;
    logic [7:0] DATA;
} instr_t;

localparam int NUM_INSTR = 6;
localparam instr_t INITIALIZATION_PROG [NUM_INSTR] = '{
    '{OPCODE: 1'b0, MB: 1'b0, ADDRESS: 6'h31, DATA: 8'h0B}, // DATA_FORMAT
    '{OPCODE: 1'b0, MB: 1'b0, ADDRESS: 6'h2D, DATA: 8'h08},  // POWER_CTL
	 
	 '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h32, DATA: 8'h00}, // PC = 2: DATAX0
    '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h33, DATA: 8'h00}, // PC = 3: DATAX1
    '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h34, DATA: 8'h00}, // PC = 4: DATAY0
    '{OPCODE: 1'b1, MB: 1'b0, ADDRESS: 6'h35, DATA: 8'h00}  // PC = 5: DATAY1
};

logic [$clog2(NUM_INSTR):0] PC;
logic ack_prev, spi_ack;
instr_t current_instr;

assign current_instr = (PC < NUM_INSTR) ? INITIALIZATION_PROG[PC] : '0;

// Logica Program Counter
always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        PC       <= '0;
        ack_prev <= '0;
    end else begin
        ack_prev <= spi_ack;
        if (!ack_prev && spi_ack) begin
            if ( PC == 5 )
					PC   <= 2;
				else
					PC <= PC + 1;
        end
    end
end

logic [7:0] data_x0, data_x1, data_y0, data_y1;

always_ff @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        data_x0 <= '0;
        data_x1 <= '0;
        data_y0 <= '0;
        data_y1 <= '0;
    end else begin
        if (!ack_prev && spi_ack) begin
            case (PC)
                2: data_x0 <= spi_rd_data;
                3: data_x1 <= spi_rd_data;
                4: data_y0 <= spi_rd_data;
                5: data_y1 <= spi_rd_data;
                default: ; 
            endcase
        end
    end
end

assign x_data = {data_x1, data_x0};

// Instanțiere SPI PHY
spi_phy i_spi_phy (
    .rst_ni    (rst_n),
    .clk_i     (clk),
    .spi_clk_i (spi_clk_ref),
    .req_i     (PC < NUM_INSTR),        
    .rw_ni     (current_instr.OPCODE),
    .addr_i    (current_instr.ADDRESS),
    .wr_data_i (current_instr.DATA),
    .ack_o     (spi_ack),              
    .rd_data_o (spi_rd_data),
    .spi_cs_no (spi_cs_n),             
    .spi_clk_o (spi_clk),
    .spi_data_o(spi_sdi),
    .spi_data_i(spi_sdo),
    .spi_oe_o  ()
);

endmodule