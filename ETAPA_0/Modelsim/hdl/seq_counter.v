module seq_counter #(
    parameter CLK_FREQ      = 50_000_000, 
    parameter UPDATE_HZ     = 2,        
    parameter LED_WIDTH     = 10,
    parameter WIDTH         = 28,
    
    parameter DISP_WIDTH    = 10
)(
    input                            clk_i,
    input                            rst_ni,
    
    output reg [2:0]                 column_o,
    output reg                       row_o
);

localparam CNT_STOP = CLK_FREQ / UPDATE_HZ;

reg  [WIDTH-1:0]       cnt_o;
wire [LED_WIDTH-1:0]   LED_Lenght;

always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni)                    cnt_o   <= 0; else
    if (cnt_o == CNT_STOP - 1)      cnt_o   <= 0; else
                                    cnt_o   <= cnt_o + 1;

always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni)                    row_o   <= 0;
    else if (column_o == 3'b111)    row_o   <= 1;
    else if (!column_o)             row_o   <= 0;
  

always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni)                    column_o <= 0;
    else if (!row_o) begin
        if (!cnt_o)                 column_o <= column_o + 1;
    end
    else if (row_o) begin
        if (!cnt_o)                 column_o <= column_o - 1;
    end


endmodule