onbreak {quit -f}
onerror {quit -f}

vsim  -lib xil_defaultlib LCD_AXI4_lite_3_0_opt

set NumericStdNoWarnings 1
set StdArithNoWarnings 1

do {wave.do}

view wave
view structure
view signals

do {LCD_AXI4_lite_3_0.udo}

run 1000ns

quit -force
