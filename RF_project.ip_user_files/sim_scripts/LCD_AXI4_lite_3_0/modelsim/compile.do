vlib modelsim_lib/work
vlib modelsim_lib/msim

vlib modelsim_lib/msim/xil_defaultlib

vmap xil_defaultlib modelsim_lib/msim/xil_defaultlib

vlog -work xil_defaultlib -64 -incr -mfcu  "+incdir+../../../../../Documents/vivado/2025.1/data/rsb/busdef" \
"../../../../RF_project.gen/sources_1/ip/LCD_AXI4_lite_3_0/src/LCD_ST7735.v" \
"../../../../RF_project.gen/sources_1/ip/LCD_AXI4_lite_3_0/src/clk_module.v" \
"../../../../RF_project.gen/sources_1/ip/LCD_AXI4_lite_3_0/src/top_module.v" \
"../../../../RF_project.gen/sources_1/ip/LCD_AXI4_lite_3_0/sim/LCD_AXI4_lite_3_top_module_0_0.v" \
"../../../../RF_project.gen/sources_1/ip/LCD_AXI4_lite_3_0/sim/LCD_AXI4_lite_3.v" \
"../../../../RF_project.gen/sources_1/ip/LCD_AXI4_lite_3_0/sim/LCD_AXI4_lite_3_0.v" \


vlog -work xil_defaultlib \
"glbl.v"

