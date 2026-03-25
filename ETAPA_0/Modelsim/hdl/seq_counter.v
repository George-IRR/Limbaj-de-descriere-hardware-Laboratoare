module seq_counter #(
    parameter CLK_FREQ      = 50_000_000, 
    parameter UPDATE_HZ     = 2,        
    parameter LED_WIDTH     = 10,
    parameter WIDTH         = 28,
    
    parameter DISP_WIDTH    = 10
)(
    input                            clk_i,
    input                            rst_ni,
    output reg [LED_WIDTH-1:0]       led_o,
    
    output reg [2:0]                 column_o,
    output reg                       row_o
);

localparam CNT_STOP = CLK_FREQ / UPDATE_HZ;

reg  [WIDTH-1:0]       cnt_o;
wire [LED_WIDTH-1:0]   LED_Lenght;
reg                    last_led;

assign LED_Lenght = 1 << (LED_WIDTH - 1);

always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni)                   cnt_o <= 0; else
    if (cnt_o == CNT_STOP - 1)     cnt_o <= 0; else
                                   cnt_o <= cnt_o + 1;

always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni) begin
        column_o [0]    <= 1;
        column_o [2:1]  <= 0;
        row_o           <= 1;
        last_led        <= 0;
    end 
    else if ()



always @(posedge clk_i or negedge rst_ni)
    if (!rst_ni) begin
        led_o[0]    	     <= 1;
		led_o[LED_WIDTH-1:1] <= 0;
        last_led             <= 0;
    end 
    else begin
        if (cnt_o == CNT_STOP - 1 && led_o[0]) last_led <= 0; else
        if (led_o == LED_Lenght && !last_led)  last_led <= 1;

        if (cnt_o == CNT_STOP - 1) begin
            if (!last_led)             led_o <= led_o << 1; else
            if (last_led && !led_o[0]) led_o <= led_o >> 1;
        end
    end

endmodule