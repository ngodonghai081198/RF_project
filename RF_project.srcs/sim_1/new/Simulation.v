`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 08/08/2026 08:29:08 PM
// Design Name: 
// Module Name: Simulation
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Simulation(
    
    );
    reg clk = 1'b1;
    reg rst_n = 1'b1;
    wire LCD_SCK;
    wire LCD_RESX;
    wire LCD_SDA;
    wire LCD_CSX;
    wire LCD_DCX;
    wire [7:0] LED;
    
    top_module dut(
        .clk(clk),
        .LCD_CSX(LCD_CSX),
        .LCD_DCX(LCD_DCX),
        .rst_n(rst_n),
        .LCD_SCK(LCD_SCK),
        .LCD_RESX(LCD_RESX),
        .LCD_SDA(LCD_SDA),
        .LED(LED)
    );
    
    always #10 clk = ~clk;
    
    initial begin
    #500_000_000;
    $finish();
    end
    
    
endmodule






