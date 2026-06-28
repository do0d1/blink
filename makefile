.PHONY: all sim build program clean

all: build

sim:
	mkdir -p build
	cd build && \
		xvlog -sv ../src/top.sv ../tb/tb_top.sv && \
		xelab -debug typical tb_top -s tb_snap && \
		xsim tb_snap -runall

build: src/top.sv constraints/nexys_a7.xdc scripts/build.tcl
	mkdir -p build
	vivado -mode batch -source scripts/build.tcl \
		-log build/vivado.log -journal build/vivado.jou

program: build/top.bit
	vivado -mode batch -source scripts/program.tcl \
		-log build/program.log -journal build/program.jou

flash: scripts/flash.tcl
	vivado -mode batch -source scripts/flash.tcl \
		-log build/flash.log -journal build/flash.jou

clean:
	rm -rf build


