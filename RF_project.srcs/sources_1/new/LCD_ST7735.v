`timescale 1ns / 1ps

module LCD_ST7735(
    input wire clk,
    input wire LCD_SCK,
    input wire rst_n,
    input wire [9:0] counter_top,
    
    output reg LCD_CSX,
    output reg LCD_RESX,
    output reg LCD_DCX,
    output reg LCD_SDA,
    output reg LCD_LED = 1'b1,
    output reg [7:0] LED
//    output reg [20:0] counter = 21'd0

    );
    
    reg [20:0] counter = 21'd0;
    reg rst_n_ispressed = 1'b0;
    reg [22:0] counter_rst = 23'd0;
    reg [15:0] LCD_parameter = 16'd0;
    reg [3:0] LCD_state = 4'b0000;
    reg [7:0] LCD_data = 8'b0000_0000;
    reg [2:0] LCD_data_cnt = 3'b111;
    wire LCD_para_temp = 1'b0;
    
    assign LCD_para_temp = LCD_parameter % 2;
    
    reg [1:0] POWER_ON_state = 2'd0;
    reg [1:0] SWRESET_state = 2'd0;
    reg [1:0] SPLOUT_state = 2'd0;
    reg [1:0] COLMOD_state = 2'd0;
    reg [1:0] MADCTL_state = 2'd0;
    reg DISPON_state = 1'b0;
    reg [1:0] CASET_state = 2'd0;
    reg [1:0] RASET_state = 2'd0;
    reg [1:0] RAMWR_state = 2'd0;
    
    localparam POWER_ON = 0;
    localparam SWRESET = 1;
    localparam SPLOUT = 2;
    localparam COLMOD = 3;
    localparam MADCTL = 4;
    localparam DISPON = 5;
    localparam CASET = 6;
    localparam RASET = 7;
    localparam RAMWR = 8;
    localparam CMD_WAIT = 9;
    
    // POWER_ON sequence
    localparam POWER_ON_initial = 0;
    localparam POWER_ON_reset = 1;
    localparam POWER_ON_wait = 2;
    
    // SWRESET sequence
    localparam SWRESET_cmd = 0;
    localparam SWRESET_cmdwr = 1;
    localparam SWRESET_wait = 2;
    
    // SLPOUT sequence
    localparam SPLOUT_cmd = 0;
    localparam SPLOUT_cmdwr = 1;
    localparam SPLOUT_wait = 2;
    
    // COLMOD sequence
    localparam COLMOD_cmd = 0;
    localparam COLMOD_cmdwr = 1;
    localparam COLMOD_datawr = 2;
    
    // MADCTL sequence
    localparam MADCTL_cmd = 0;
    localparam MADCTL_cmdwr = 1;
    localparam MADCTL_datawr = 2;
    
    // DISPON sequence
    localparam DISPON_cmd = 0;
    localparam DISPON_cmdwr = 1;
    
    // CASET sequence
    localparam CASET_cmd = 0;
    localparam CASET_cmdwr = 1;
    localparam CASET_datawr = 2;
    
    // RASET sequence
    localparam RASET_cmd = 0;
    localparam RASET_cmdwr = 1;
    localparam RASET_datawr = 2;
    
    // RAMWR sequence
    localparam RAMWR_cmd = 0;
    localparam RAMWR_cmdwr = 1;
    localparam RAMWR_datawr = 2;
    
    // LCD_SCK = 12.5 MHz = 80ns.
    // counter_RESET = 500ms/80ns = 6 250 000; counter_rst = 2^23
    // counter_POWER_ON = 120.010ms/80ns = 1 500 125; counter = 2^21
    
    localparam counter_RESET = 3125000;
    localparam counter_POWER_ON_high = 750000;
    localparam counter_wait = 750000;
    localparam counter_POWER_ON_low = 125;
    
    
    
//    // Begin first LCD_SCK
//    always @(negedge LCD_SCK) begin
        
//        if (!rst_n) begin
//            rst_n_ispressed = 1'b1;
//        end
//        else begin
//            if (rst_n_ispressed == 1'b1) begin
//                if (counter_rst < counter_RESET) begin
//                    case (counter_rst)
//                        23'd0: LCD_state <= POWER_ON;
//                    endcase
//                    counter_rst <= counter_rst + 1;
//                end
//            end
            
//            else begin
//                rst_n_ispressed <= 1'b0;
//                counter_rst <= 23'd0;
//                counter <= 21'd0;
//            end
//        end
        

    
    
//    // End first LCD_SCK
//    end
    
    // Begin second LCD_SCK
    always @(posedge clk) begin
        
        if (LCD_SCK == 1'b0 && counter_top == 2) begin
        
        //Begin case for rst_n_ispressed
        case (rst_n_ispressed)
            1'b0: begin
                case (LCD_state)
                    
                    // Begin of POWER_ON
                    POWER_ON: begin 
                        LED[7:0] <= 8'b1000_0000;
                        case (POWER_ON_state)
                            POWER_ON_initial: begin 
                                
                                case (counter)
                                    21'd0: begin
                                        LCD_CSX <= 1'b1;
                                        LCD_DCX <= 1'b0;
                                        LCD_SDA <= 1'b0;
                                        LCD_RESX <= 1'b1;
                                    end
                                endcase
                                if (counter < counter_POWER_ON_high) begin
                                    counter <= counter + 1;
                                end
                                else begin
                                    counter <= 21'd0;
                                    POWER_ON_state <= POWER_ON_reset;
                                end
                            end
                            
                            POWER_ON_reset: begin 
                                case (counter)
                                    21'd0: begin
                                        LCD_RESX <= 1'b0;
                                    end
                                endcase
                                if (counter < counter_POWER_ON_low) begin
                                    counter <= counter + 1;
                                end
                                else begin
                                    counter <= 21'd0;
                                    POWER_ON_state <= POWER_ON_wait;
                                end                            
                            end
                            
                            POWER_ON_wait: begin 
                                LED[7:0] <= 8'b0100_0000;
                                case (counter)
                                    21'd0: begin
                                        LCD_RESX <= 1'b1;
                                    end
                                endcase
                                if (counter < counter_POWER_ON_high) begin
                                    counter <= counter + 1;
                                end
                                else begin
                                    counter <= 21'd0;
                                    POWER_ON_state <= POWER_ON_initial;
                                    LCD_state <= SWRESET;
                                end                             
                            end
                        endcase
                    // End of POWER_ON
                    end
                    
                    // Begin of SWRESET
                    SWRESET: begin 
                        case (SWRESET_state)
                            SWRESET_cmd: begin
                                LCD_data [7:0] <= 8'b0000_0001;
                                SWRESET_state <= SWRESET_cmdwr;
                            end
                            
                            SWRESET_cmdwr: begin
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt]; 
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end 
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    SWRESET_state <= SWRESET_wait;
                                end
                            end
                            
                            SWRESET_wait: begin
                                LCD_CSX <= 1'b1;
                                LCD_SDA <= 1'b0;
                                if (counter < counter_wait) begin
                                    counter <= counter + 1;
                                end
                                else begin
                                    counter <= 21'd0;
                                    SWRESET_state <= SWRESET_cmd;
                                    LCD_state <= SPLOUT;
                                end
                            end
                        endcase
                    // End of SWRESET
                    end
                    
                    // Begin of SPLOUT
                    SPLOUT: begin 
                        case (SPLOUT_state)
                            SPLOUT_cmd: begin 
                                LCD_data [7:0] <= 8'b0001_0001;
                                SPLOUT_state <= SPLOUT_cmdwr;
                            end
                            
                            SPLOUT_cmdwr: begin 
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt]; 
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end 
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    SPLOUT_state <= SPLOUT_wait;
                                end
                            end
                            
                            SPLOUT_wait: begin 
                                LCD_CSX <= 1'b1;
                                LCD_SDA <= 1'b0;
                                if (counter < counter_wait) begin
                                    counter <= counter + 1;
                                end
                                else begin
                                    counter <= 21'd0;
                                    SPLOUT_state <= SPLOUT_cmd;
                                    LCD_state <= COLMOD;
                                end
                            end
                        endcase
                    // End of SPLOUT
                    end
                    
                    // Begin of COLMOD
                    COLMOD: begin 
                        case (COLMOD_state)
                            COLMOD_cmd: begin 
                                LCD_data [7:0] <= 8'b0011_1010;
                                COLMOD_state <= COLMOD_cmdwr;
                            end
                            
                            COLMOD_cmdwr: begin 
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    LCD_data [7:0] <= 8'b0101_0101;
//                                    LCD_DCX <= 1'b1; 
                                    COLMOD_state <= COLMOD_datawr;
                                end
                            end
                            
                            COLMOD_datawr: begin 
                                LCD_DCX <= 1'b1;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    COLMOD_state <= COLMOD_cmd;
                                    LCD_state <= MADCTL;
                                end
                            end
                        endcase
                    // End of COLMOD
                    end
                    
                    // Begin of MADCTL
                    MADCTL: begin 
                        case (MADCTL_state)
                            MADCTL_cmd: begin 
                                LCD_CSX <=1'b1;
                                LCD_data [7:0] <= 8'b0011_0110;
                                MADCTL_state <= MADCTL_cmdwr;
                            end
                            
                            MADCTL_cmdwr: begin 
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    LCD_data [7:0] <= 8'b0000_0000;
//                                    LCD_DCX <= 1'b1; 
                                    MADCTL_state <= MADCTL_datawr;
                                end
                            end
                            
                            MADCTL_datawr: begin 
                                LCD_DCX <= 1'b1;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
//                                    LCD_CSX <=1'b1;
                                    MADCTL_state <= MADCTL_cmd;
                                    LCD_state <= DISPON;
                                end
                            end
                        endcase
                    // End of MADCTL
                    end
                    
                    // Begin of DISPON
                    DISPON: begin 
                        case (DISPON_state)
                            DISPON_cmd: begin
                                LCD_CSX <=1'b1;
                                LCD_data [7:0] <= 8'b0010_1001;
                                DISPON_state <= DISPON_cmdwr;
                            end
                            
                            DISPON_cmdwr: begin
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt]; 
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end 
                                else begin
                                    LCD_data_cnt <= 3'b111;
//                                    LCD_CSX <= 1'b1;
                                    DISPON_state <= DISPON_cmd;
                                    LCD_state <= CASET;
                                end
                            end
                        endcase
                    // End of DISPON
                    end
                    
                    // Begin of CASET
                    CASET: begin 
                        case (CASET_state)
                            CASET_cmd: begin 
                                LCD_CSX <= 1'b1;
                                LCD_data [7:0] <= 8'b0010_1010;
                                LCD_parameter [14:0] <= 15'd3;
                                CASET_state <= CASET_cmdwr;
                            end
                            
                            CASET_cmdwr: begin 
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    LCD_data [7:0] <= 8'b0000_0000;
//                                    LCD_DCX <= 1'b1; 
                                    CASET_state <= CASET_datawr;
                                end
                            end
                            
                            CASET_datawr: begin 
                                LCD_DCX <= 1'b1;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    if (LCD_parameter > 0) begin
                                        LCD_parameter <= LCD_parameter - 1;
                                        case (LCD_parameter)
                                            14'd3: LCD_data [7:0] <= 8'b0000_0000;
                                            14'd2: LCD_data [7:0] <= 8'b0000_0000;
                                            14'd1: LCD_data [7:0] <= 8'b0111_1111;
                                        endcase
                                    end
                                    else begin
//                                        LCD_CSX <= 1'b1;
                                        CASET_state <= CASET_cmd;
                                        LCD_state <= RASET;
                                    end
                                    
                                end
                            end
                        endcase
                    // End of CASET
                    end
                    
                    // Begin of RASET
                    RASET: begin 
                        case (RASET_state)
                            RASET_cmd: begin 
                                LCD_CSX <= 1'b1;
                                LCD_data [7:0] <= 8'b0010_1011;
                                LCD_parameter [14:0] <= 15'd3;
                                RASET_state <= RASET_cmdwr;
                            end
                            
                            RASET_cmdwr: begin 
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    LCD_data [7:0] <= 8'b0000_0000;
//                                    LCD_DCX <= 1'b1; 
                                    RASET_state <= RASET_datawr;
                                end
                            end
                            
                            RASET_datawr: begin 
                                LCD_DCX <= 1'b1;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    if (LCD_parameter > 0) begin
                                        LCD_parameter <= LCD_parameter - 1;
                                        case (LCD_parameter)
                                            14'd3: LCD_data [7:0] <= 8'b0000_0000;
                                            14'd2: LCD_data [7:0] <= 8'b0000_0000;
                                            14'd1: LCD_data [7:0] <= 8'b1001_1111;
                                        endcase
                                    end
                                    else begin
//                                        LCD_CSX <= 1'b1;
                                        RASET_state <= RASET_cmd;
                                        LCD_state <= RAMWR;
                                    end
                                    
                                end
                            end
                        endcase
                    // End of RASET
                    end
                    
                    // Begin of RAMWR    
                    RAMWR: begin 
                        LED[7:0] <= 8'b0010_1000;
                        case (RAMWR_state)
                            RAMWR_cmd: begin 
                                LCD_CSX <= 1'b1;
                                LCD_data [7:0] <= 8'b0010_1100;
                                LCD_parameter [15:0] <= 16'd40960;
                                RAMWR_state <= RAMWR_cmdwr;
                            end
                            
                            RAMWR_cmdwr: begin 
                                LCD_CSX <= 1'b0;
                                LCD_DCX <= 1'b0;
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    LCD_data [7:0] <= 8'b0000_0111;
//                                    LCD_DCX <= 1'b1; 
                                    RAMWR_state <= RAMWR_datawr;
                                end
                            end
                            
                            RAMWR_datawr: begin 
                                LCD_DCX <= 1'b1; 
                                LCD_SDA <= LCD_data[LCD_data_cnt];
                                if (LCD_data_cnt > 0) begin
                                    LCD_data_cnt <= LCD_data_cnt - 1;
                                end
                                else begin
                                    LCD_data_cnt <= 3'b111;
                                    if (LCD_parameter > 0) begin
                                        LCD_parameter <= LCD_parameter - 1;
                                        if ((LCD_parameter % 2) == 1) begin
                                            LCD_data [7:0] <= 8'b1110_0000;
                                        end
                                        else LCD_data [7:0] <= 8'b0000_0111;
                                    end
                                    else begin
//                                        LCD_CSX <= 1'b1;
                                        RAMWR_state <= RAMWR_cmd;
                                        LCD_state <= CMD_WAIT;
                                    end
                                    
                                end
                            end
                        endcase
                    // End of RAMWR
                    end
                    
                    CMD_WAIT: begin LCD_CSX <= 1'b1; end
                    
                endcase
            end
            default: begin end
        
        // Endcase for rst_n_ispressed
        endcase
    
    end
    
    // End second LCD_SCK
    end
    
    
endmodule













