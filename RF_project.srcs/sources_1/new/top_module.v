`timescale 1ns / 1ps

module top_module(
    input wire clk,
    input wire rst_n,
    output reg [7:0] LED = 8'b10101010,
    
    output reg LCD_CS,
    output reg LCD_RST,
    output reg LCD_DCX,
    output reg LCD_SDA,
    output reg LCD_SCK,
    output reg LCD_LED

    );
    
    reg [23:0] counter = 24'd0;
    
    always @(posedge clk) begin
    
        // Initial value
        LCD_CS <= 1'b1;
        LCD_RST <= 1'b1;
        LCD_DCX <= 1'b0;
        LCD_SDA <= 1'b0;
        LCD_LED <= 1'b1;
        
        
        if (rst_n == 0) LED[7:0] = 8'b01010101;
        else begin
            if (counter < 10_000_000) begin
                counter <= counter + 1;
            end
            else begin
                counter <= 0;
                LED[7:0] <= ~LED[7:0];
            end
        end
        
        
    end
endmodule








