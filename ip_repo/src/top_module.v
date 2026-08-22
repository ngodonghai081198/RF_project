`timescale 1ns / 1ps

module top_module(
    // AXI4-Lite Interface
    input  wire        s_axi_aclk,
    input  wire        s_axi_aresetn,
    input  wire [3:0]  s_axi_awaddr,
    input  wire [2:0]  s_axi_awprot,
    input  wire        s_axi_awvalid,
    output wire        s_axi_awready,
    input  wire [31:0] s_axi_wdata,
    input  wire [3:0]  s_axi_wstrb,
    input  wire        s_axi_wvalid,
    output wire        s_axi_wready,
    output wire [1:0]  s_axi_bresp,
    output wire        s_axi_bvalid,
    input  wire        s_axi_bready,
    input  wire [3:0]  s_axi_araddr,
    input  wire [2:0]  s_axi_arprot,
    input  wire        s_axi_arvalid,
    output wire        s_axi_arready,
    output reg  [31:0] s_axi_rdata,
    output wire [1:0]  s_axi_rresp,
    output wire        s_axi_rvalid,
    input  wire        s_axi_rready,

//    input wire clk,
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
    
    always @(posedge s_axi_aclk) begin
        if (counter > 0) counter <= counter - 1;
        else counter <= 3;
    end
    
    clk_module dut_clk_module(
        .clk(s_axi_aclk),
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
        .clk(s_axi_aclk),
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








