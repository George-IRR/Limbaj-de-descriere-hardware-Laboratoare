module display #(
)(
    input               clk_i,
    input               rst_ni,
    input [2:0]         column_i ,
    input               row_i,
    output reg [7:0]     HEX0,
    output reg [7:0]     HEX1,
    output reg [7:0]     HEX2,
    output reg [7:0]     HEX3,
    output reg [7:0]     HEX4,
    output reg [7:0]     HEX5

);

localparam upper_mask = 8'b0110_0011;
localparam lower_mask = 8'b0101_1100;

always @(posedge clk_i or negedge rst_ni) begin
    if (!rst_ni) begin
        HEX0 <= 8'hFF;
        HEX1 <= 8'hFF;
        HEX2 <= 8'hFF;
        HEX3 <= 8'hFF;
        HEX4 <= 8'hFF;
        HEX5 <= 8'hFF;
    end else begin
        // Turn off all displays mask (common anode)
        HEX0 <= 8'hFF;
        HEX1 <= 8'hFF;
        HEX2 <= 8'hFF;
        HEX3 <= 8'hFF;
        HEX4 <= 8'hFF;
        HEX5 <= 8'hFF;

        // Overwrite only selected display
        case (column_i)
            3'd0: HEX0 <= row_i ? upper_mask : lower_mask;
            3'd1: HEX1 <= row_i ? upper_mask : lower_mask;
            3'd2: HEX2 <= row_i ? upper_mask : lower_mask;
            3'd3: HEX3 <= row_i ? upper_mask : lower_mask;
            3'd4: HEX4 <= row_i ? upper_mask : lower_mask;
            3'd5: HEX5 <= row_i ? upper_mask : lower_mask;
        endcase
    end
end

endmodule