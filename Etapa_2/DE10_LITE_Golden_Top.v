// ============================================================================
//   Ver  :| Author					:| Mod. Date :| Changes Made:
//   V1.1 :| Alexandra Du			:| 06/01/2016:| Added Verilog file
// ============================================================================

`define ENABLE_ADC_CLOCK
`define ENABLE_CLOCK1
`define ENABLE_CLOCK2
`define ENABLE_SDRAM
`define ENABLE_HEX0
`define ENABLE_HEX1
`define ENABLE_HEX2
`define ENABLE_HEX3
`define ENABLE_HEX4
`define ENABLE_HEX5
`define ENABLE_KEY
`define ENABLE_LED
`define ENABLE_SW
`define ENABLE_VGA
`define ENABLE_ACCELEROMETER
`define ENABLE_ARDUINO
`define ENABLE_GPIO

module DE10_LITE_Golden_Top(
`ifdef ENABLE_ADC_CLOCK
    input                               ADC_CLK_10,
`endif
`ifdef ENABLE_CLOCK1
    input                               MAX10_CLK1_50,
`endif
`ifdef ENABLE_CLOCK2
    input                               MAX10_CLK2_50,
`endif
`ifdef ENABLE_SDRAM
    output            [12:0]        DRAM_ADDR,
    output             [1:0]        DRAM_BA,
    output                          DRAM_CAS_N,
    output                          DRAM_CKE,
    output                          DRAM_CLK,
    output                          DRAM_CS_N,
    inout             [15:0]        DRAM_DQ,
    output                          DRAM_LDQM,
    output                          DRAM_RAS_N,
    output                          DRAM_UDQM,
    output                          DRAM_WE_N,
`endif
`ifdef ENABLE_HEX0
    output             [7:0]        HEX0,
`endif
`ifdef ENABLE_HEX1
    output             [7:0]        HEX1,
`endif
`ifdef ENABLE_HEX2
    output             [7:0]        HEX2,
`endif
`ifdef ENABLE_HEX3
    output             [7:0]        HEX3,
`endif
`ifdef ENABLE_HEX4
    output             [7:0]        HEX4,
`endif
`ifdef ENABLE_HEX5
    output             [7:0]        HEX5,
`endif
`ifdef ENABLE_KEY
    input              [1:0]        KEY,
`endif
`ifdef ENABLE_LED
    output             [9:0]        LEDR,
`endif
`ifdef ENABLE_SW
    input              [9:0]        SW,
`endif
`ifdef ENABLE_VGA
    output             [3:0]        VGA_B,
    output             [3:0]        VGA_G,
    output                          VGA_HS,
    output             [3:0]        VGA_R,
    output                          VGA_VS,
`endif
`ifdef ENABLE_ACCELEROMETER
    output                          GSENSOR_CS_N,
    input              [2:1]        GSENSOR_INT,
    output                          GSENSOR_SCLK,
    inout                           GSENSOR_SDI,
    inout                           GSENSOR_SDO,
`endif
`ifdef ENABLE_ARDUINO
    inout             [15:0]        ARDUINO_IO,
    inout                           ARDUINO_RESET_N,
`endif
`ifdef ENABLE_GPIO
    inout             [35:0]        GPIO
`endif
);

//=======================================================
//  REG/WIRE declarations
//=======================================================
wire pll_rst, rst_n;
wire sys_clk, spi_clk;
wire [7:0] rd_data;
wire ack;
wire pll_locked;

assign rst_n   = KEY[0];
assign pll_rst = ~rst_n;

wire spi_oe_o;
wire sdo;
assign GSENSOR_SDI = spi_oe_o ? sdo : 1'bZ;

wire front_detector;
reg  signal_delay;

always @(posedge sys_clk) begin
    signal_delay <= KEY[1];
end
assign front_detector = ~KEY[1] & signal_delay;

reg signed [15:0] x_axis;
reg signed [15:0] y_axis;
always @(posedge sys_clk or negedge rst_n) begin
    if (~rst_n) begin
	 x_axis <= 0; 
    y_axis <= 0;
	 end
	 else if (ack) begin
		x_axis[15:0] <= x_data[15:0];
		y_axis[15:0] <= y_data[15:0];
		end
end

//=======================================================
//  Structural coding
//=======================================================
wire [15:0] abs_x = x_axis[15] ? (~x_axis + 1) : x_axis;
wire sign_x = x_axis[15];

assign LEDR[9:0] = leds;

reg [9:0] leds;
always @(posedge sys_clk or negedge rst_n) begin
    if (!rst_n) begin
        leds <= 10'b0;
    end else begin
        if (abs_x < 40) begin
            leds <= 10'b0000110000;
        end 
        else if (sign_x == 1'b1) begin
            if (abs_x >= 40 && abs_x < 100)
                leds <= 10'b0001000000;
            else if (abs_x >= 100 && abs_x < 160)
                leds <= 10'b0010000000;
            else
                leds <= 10'b0100000000;
        end 
        else begin
            if (abs_x >= 40 && abs_x < 100)
                leds <= 10'b0000001000;
            else if (abs_x >= 100 && abs_x < 160)
                leds <= 10'b0000000100;
            else
                leds <= 10'b0000000010;
        end
    end
end

wire [2:0] column;
wire       row;

//seq_counter #(
//    .CLK_FREQ       (50000000),
//    .UPDATE_HZ      (2)
//) sequence_counter (
//    .clk_i          (MAX10_CLK1_50),  
//    .rst_ni         (KEY[0]),         
//    .column_o       (column),
//    .row_o          (row)
//);

adxl_level #(
   .N(6)
) level (
    .data_xi  (x_axis),
    .column_o (column)
);

display display_output (
    .clk_i      (MAX10_CLK1_50),
    .rst_ni     (KEY[0]),
    .column_i   (column),
    .row_i      (row),
    .HEX0       (HEX0),
    .HEX1       (HEX1),
    .HEX2       (HEX2),
    .HEX3       (HEX3),
    .HEX4       (HEX4),
    .HEX5       (HEX5)
);

pll pll_inst (
    .areset     ( pll_rst       ),
    .inclk0     ( MAX10_CLK1_50 ),
    .c0         ( sys_clk       ),
    .c1         ( spi_clk       ),
    .locked     ( pll_locked    )
);


wire rw_n;
wire req;

wire [ 7:0] wr_data;
wire [ 5:0] addr;
wire [15:0] x_data;
wire [15:0] y_data;

adxl345 u_control(
    .clk			( sys_clk ),
    .rst_n		( rst_n	 ),
	 .rd_data_i	( rd_data ),
	 .req_o		( req 	 ),
	 .rw_no		( rw_n 	 ),
	 .addr_i		( addr 	 ),
	 .wr_data_o	( wr_data ),
	 .ack_i		( ack		 ),
	 .x_data_o	( x_data	 ),
	 .y_data_o	( y_data	 )
);

spi_phy spi_phy_inst(
    .rst_ni     ( rst_n        ),
    .clk_i      ( sys_clk      ), 
    .spi_clk_i  ( spi_clk      ),
    .req_i      ( req 			 ),
    .rw_ni      ( rw_n         ),  
    .addr_i     ( addr		    ),
    .wr_data_i  ( wr_data      ),
    .ack_o      ( ack          ),
    .rd_data_o  ( rd_data      ),
    .spi_cs_no  ( GSENSOR_CS_N ),
    .spi_clk_o  ( GSENSOR_SCLK ),
    .spi_data_o ( sdo          ),
    .spi_data_i ( GSENSOR_SDI  ),
    .spi_oe_o   ( spi_oe_o     )   
);

endmodule