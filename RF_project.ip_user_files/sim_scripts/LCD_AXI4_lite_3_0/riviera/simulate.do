transcript off
onbreak {quit -force}
onerror {quit -force}
transcript on

asim +access +r +m+LCD_AXI4_lite_3_0  -L xil_defaultlib -L unisims_ver -L unimacro_ver -L secureip -O5 xil_defaultlib.LCD_AXI4_lite_3_0 xil_defaultlib.glbl

do {LCD_AXI4_lite_3_0.udo}

run 1000ns

endsim

quit -force
