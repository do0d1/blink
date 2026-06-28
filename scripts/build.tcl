set part xc7a100tcsg324-1        ;# change to xc7a50tcsg324-1 for the -50T

read_verilog -sv src/top.sv
read_xdc constraints/nexys_a7.xdc

synth_design -top top -part $part
write_checkpoint -force build/post_synth.dcp

#set_property CONFIG_MODE SPIx4 [current_design]
#set_property BITSTREAM.CONFIG.SPI_BUSWIDTH 4 [current_design]
#set_property BITSTREAM.CONFIG.CONFIGRATE 33 [current_design]
#set_property BITSTREAM.GENERAL.COMPRESS TRUE [current_design]

opt_design
place_design
route_design
write_checkpoint -force build/post_route.dcp

report_timing_summary -file build/timing.rpt
report_utilization     -file build/utilization.rpt

write_bitstream -force build/top.bit
