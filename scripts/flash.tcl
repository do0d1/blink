# Generate MCS — x1, simplest possible
write_cfgmem -force -format mcs -interface spix1 -size 16 \
    -loadbit {up 0x0 build/top.bit} \
    -file build/top.mcs

# Connect and program FPGA first (it bridges JTAG to SPI)
open_hw_manager
connect_hw_server
open_hw_target

set device [lindex [get_hw_devices] 0]
current_hw_device $device
set_property PROGRAM.FILE {build/top.bit} $device
program_hw_devices $device
refresh_hw_device $device

# Set up flash
create_hw_cfgmem -hw_device $device \
    [lindex [get_cfgmem_parts {s25fl128sxxxxxx0-spi-x1_x2_x4}] 0]

set cfgmem [get_property PROGRAM.HW_CFGMEM $device]
set_property PROGRAM.FILES       [list build/top.mcs] $cfgmem
set_property PROGRAM.ERASE       1                    $cfgmem
set_property PROGRAM.CFG_PROGRAM 1                    $cfgmem
set_property PROGRAM.VERIFY      1                    $cfgmem

program_hw_cfgmem -hw_cfgmem $cfgmem

close_hw_manager
