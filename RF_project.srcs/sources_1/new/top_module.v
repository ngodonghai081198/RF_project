`timescale 1ns / 1ps

module top_module(
    input wire clk,
    input wire rst_n,
    output wire [7:0] LED,
    
    output wire LCD_CSX,
    output wire LCD_RESX,
    output wire LCD_DCX,
    output wire LCD_SDA,
    output wire LCD_SCK,
    output wire LCD_LED
//    output wire [20:0] counter

    );
    
    reg [9:0] counter = 10'd3;
    
    always @(posedge clk) begin
        if (counter > 0) counter <= counter - 1;
        else counter <= 3;
    end
    
    clk_module dut_clk_module(
        .clk(clk),
        .LCD_SCK(LCD_SCK),
        .counter(counter)
    );
    
//    reg [23:0] counter = 24'd0;
    
//    always @(posedge clk) begin
    
        // Initial value
//        LCD_CSX <= 1'b1;
//        LCD_RESX <= 1'b1;
//        LCD_DCX <= 1'b0;
//        LCD_SDA <= 1'b0;
//        LCD_LED <= 1'b1;
        
        
//        if (rst_n == 0) LED[7:0] = 8'b01010101;
//        else begin
//            if (counter < 10_000_000) begin
//                counter <= counter + 1;
//            end
//            else begin
//                counter <= 0;
//                LED[7:0] <= ~LED[7:0];
//            end
//        end
//    end
    
    LCD_ST7735 dut_LCD_ST7735(
        .clk(clk),
        .counter_top(counter),
        .rst_n(rst_n),
        .LCD_SCK(LCD_SCK),
        .LCD_CSX(LCD_CSX),
        .LCD_RESX(LCD_RESX),
        .LCD_DCX(LCD_DCX),
        .LCD_SDA(LCD_SDA),
        .LCD_LED(LCD_LED),
        .LED(LED)
//        .counter(counter)
    );
    
endmodule








