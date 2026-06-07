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

localparam WIDTH_DISPLAY_COUNT  = 6;
localparam HEIGHT_DISPLAY_COUNT = 2;

localparam COL_WIDTH = $clog2(WIDTH_DISPLAY_COUNT);
localparam ROW_WIDTH = $clog2(HEIGHT_DISPLAY_COUNT);

localparam COUNTER_WIDTH = 'd10;

wire pll_rst, rst_n;
wire sys_clk, spi_clk, vga_clk;

wire [7:0] rd_data;
wire ack;
wire pll_locked;

assign rst_n   = KEY[0];
assign pll_rst = ~rst_n;

wire spi_oe_o;
wire sdo;
assign GSENSOR_SDI = spi_oe_o ? sdo : 1'bZ;

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

wire 		  video_active	   ;
wire [9:0] pixel_x, pixel_y;

wire v_sync;
assign VGA_VS = v_sync;

wire [COL_WIDTH - 1:0] column;
wire [ROW_WIDTH - 1:0] row	 ;

wire [COL_WIDTH-1:0] column_inv;
assign column_inv = 3'd5 - column; // inversed x axis

wire rw_n;
wire req;

wire [ 7:0] wr_data;
wire [ 5:0] addr;
wire [15:0] x_data;
wire [15:0] y_data;

vga_graphics #(
	.WIDTH(COUNTER_WIDTH)
) vga_graphic (
	.clk_i	   ( vga_clk 		),
	.rst_ni     ( rst_n 			),
	.vid_actv_i ( video_active ),
	.pixel_xi   ( pixel_x 		),
	.pixel_yi   ( pixel_y 		),
	.vga_r_o    ( VGA_R 			),
	.vga_g_o    ( VGA_G 			),
	.vga_b_o    ( VGA_B 			),
	.data_xi		( x_axis 		),
	.data_yi		( y_axis 		),
	.vsync_i		( v_sync			)
);

vga_controller #(
	.WIDTH(COUNTER_WIDTH)
) vga_cntrl (
	.clk_i	 		 ( vga_clk 		 ),
	.rst_ni	 		 ( rst_n 		 ),
	.h_sync_o 		 ( VGA_HS 		 ),
	.v_sync_o 		 ( v_sync 		 ),
	.video_active_o ( video_active ),
	.pixel_x_o		 ( pixel_x 		 ),
	.pixel_y_o		 ( pixel_y 		 )
);

adxl_level #(
   .DISP_X(WIDTH_DISPLAY_COUNT ),
	.DISP_Y(HEIGHT_DISPLAY_COUNT)
) level (
    .data_xi  ( x_axis ),
	 .data_yi  ( y_axis ),
    .column_o ( column ),
	 .row_o	  ( row	  )
);

display display_output (
    .clk_i      ( sys_clk 	  ),
    .rst_ni     ( rst_n	  	  ),
    .column_i   ( column_inv ),
    .row_i      ( row     	  ),
    .HEX0       ( HEX0    	  ),
    .HEX1       ( HEX1    	  ),
    .HEX2       ( HEX2    	  ),
    .HEX3       ( HEX3    	  ),
    .HEX4       ( HEX4    	  ),
    .HEX5       ( HEX5    	  )
);

pll pll_inst (
    .areset     ( pll_rst       ),
    .inclk0     ( MAX10_CLK1_50 ),
    .c0         ( sys_clk       ),
    .c1         ( spi_clk       ),
	 .c2			 ( vga_clk		  ),
    .locked     ( pll_locked    )
);

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