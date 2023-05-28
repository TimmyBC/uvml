#!/bin/bash
 Testbench="tb_pkt_fifo"
# Testbench="tb_fifo"
# Testbench="tb_axi"
# Testbench="tb_axilite"
# Testbench="tb_axis"
# Testbench="tb_stream"
# Testbench="tb_hs"

set -e

if [ "$#" -ne 1 ]; then
    echo "Syntex: ./sim.sh < o - optimized, d - debug, g - gui debug, v - view, c - clean>"
fi

if [ "$1" == "v" ]; then

	echo "Viewing vsim.wlf..."
	vsim -view vsim.wlf -do wave.do

elif [ "$1" == "c" ]; then

	echo "Cleaning..."
	rm -rf ./work 
	rm -f ./vsim.wlf 
	rm -f ./transcript 
	rm -f ./xsim/vivado* 
	rm -rf ./xsim/.Xil 
	rm -rf ./xsim/uvml.sim 
	rm -rf ./xsim/uvml.ip_user_files 
	rm -rf ./xsim/uvml.hw 
	rm -rf ./xsim/uvml.cache 
	echo "Done"

elif [ "$1" == "d" ]; then

	vlib work
	vlog -incr -f ../rtl/rtl.f
	vlog +define+LOG_COLOR -incr -f uvml/uvml.f -f sim.f
	vsim -c -voptargs="+acc=lnpr" -t 1ns -lib work work.$Testbench -do "log -r /*" -do "run -all" 
	echo "Done"

elif [ "$1" == "g" ]; then

	vlib work
	vlog -incr -f ../rtl/rtl.f
	vlog -incr -f uvml/uvml.f -f sim.f
	echo "Starting GUI..."
	vsim -voptargs="+acc=lnpr" -t 1ns -lib work work.$Testbench -onfinish stop -do "log -r /*" -do "run 0" -do "wave.do"

fi
