module red_filter(
input clk,
    input [7:0] red_color,
    input [7:0] blue_color,
    input [7:0] value,
    output reg [7:0] red_val,
    output reg [7:0] blue_val
);

    integer i, j;
    reg [7:0] reg_value [0:7]; // 2D array to store intermediate results
    reg [7:0] reg_blue_value [0:7];


    always @(posedge clk) begin
        // Initialize red_val and reg_value
       red_val = 8'b0;
       for (i = 0; i < 8; i = i + 1) begin
            reg_value[i] = 8'b0;
        end

        // Perform row-wise multiplication and accumulate the results
        for (i = 0; i < 8; i = i + 1) begin
                 reg_value[i][0] = (red_color[0] * value[i]);
                 reg_value[i][1] = (red_color[1] * value[i]);
                 reg_value[i][2] = (red_color[2] * value[i]);
                 reg_value[i][3] = (red_color[3] * value[i]);
                 reg_value[i][4] = (red_color[4] * value[i]);
                 reg_value[i][5] = (red_color[5] * value[i]);
                 reg_value[i][6] = (red_color[6] * value[i]);
                 reg_value[i][7] = (red_color[7] * value[i]);
                 
                 reg_blue_value[i][0] = (blue_color[0] * value[i]);
                 reg_blue_value[i][1] = (blue_color[1] * value[i]);
                 reg_blue_value[i][2] = (blue_color[2] * value[i]);
                 reg_blue_value[i][3] = (blue_color[3] * value[i]);
                 reg_blue_value[i][4] = (blue_color[4] * value[i]);
                 reg_blue_value[i][5] = (blue_color[5] * value[i]);
                 reg_blue_value[i][6] = (blue_color[6] * value[i]);
                 reg_blue_value[i][7] = (blue_color[7] * value[i]);
                 
        end

        // Sum the intermediate results to obtain the final red_val
        for (i = 0; i < 8; i = i + 1) begin
            red_val = red_val + reg_value[i];
            blue_val = blue_val + reg_blue_value[i];
        end
    end

endmodule
