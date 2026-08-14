`timescale 1ns / 1ps

module clk_module(
    input wire clk,
    input wire [9:0] counter,
    output reg LCD_SCK = 0
    );
//    reg [9:0] clk_cnt = cnt_temp;
    
    always @(posedge clk) begin
        if (counter == 0) LCD_SCK <= ~LCD_SCK;
    end
endmodule
