# $Testbench="tb_axi"
 $Testbench="tb_axilite"
# $Testbench="tb_axis"
# $Testbench="tb_stream"
# $Testbench="tb_hs"

$ErrorActionPreference = "Stop"

if ($args.count -ne 1){
	echo "Syntex: .\sim.ps1 <mode: o - optimized, d - debug, g - gui debug, v - view, c - clean>"
	exit
}

$mode = $args[0]

if ($mode -eq "v"){
	echo "Viewing vsim.wlf..."
	Start-Process -FilePath "vsim.exe" -ArgumentList "-view vsim.wlf -do `"wave.do`"" -NoNewWindow
} elseif ($mode -eq "c"){
	echo "Cleaning..."
	if (Test-Path ".\work") { rmdir work }
    	if (Test-Path ".\vsim.wlf") { del .\vsim.wlf }
	if (Test-Path ".\transcript") { del .\transcript }
	if (Test-Path ".\xsim\vivado*") { del .\xsim\vivado* }
	if (Test-Path ".\xsim\.Xil") { rmdir .\xsim\.Xil }
	if (Test-Path ".\xsim\uvml.sim") { rmdir .\xsim\uvml.sim }
	if (Test-Path ".\xsim\uvml.ip_user_files") { rmdir .\xsim\uvml.ip_user_files }
	if (Test-Path ".\xsim\uvml.hw") { rmdir .\xsim\uvml.hw }
	if (Test-Path ".\xsim\uvml.cache") { rmdir .\xsim\uvml.cache }

} elseif ($mode -eq "d"){
	vlib work
	vlog -incr -f ../rtl/rtl.f
	if ( -not $? ) { exit } 

	vlog +define+LOG_COLOR -incr -f uvml/uvml.f -f sim.f
	if ( -not $? ) { exit } 

	vsim -c -voptargs="+acc=lnpr" -t 1ns -lib work work.$Testbench -do "log -r /*" -do "run -all" 
	if ( -not $? ) { exit } 

	echo "Done"

} elseif ($mode -eq "g") {
	vlib work
	vlog -incr -f ../rtl/rtl.f
	if ( -not $? ) { exit } 

	vlog -incr -f uvml/uvml.f -f sim.f
	if ( -not $? ) { exit } 

	echo "Starting GUI..."

	Start-Process -FilePath "vsim.exe" -ArgumentList "-voptargs=`"+acc=lnpr`" -t 1ns -lib work work.$Testbench -onfinish stop -do `"log -r /*`" -do `"run 0`" -do `"wave.do`""  -NoNewWindow

} elseif ($mode -eq "gc") {

	vlog -incr -f ../rtl/rtl.f
	if ( -not $? ) { exit } 

	vlog -incr -f uvml/uvml.f -f sim.f
	if ( -not $? ) { exit } 

}