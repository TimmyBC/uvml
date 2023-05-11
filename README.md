# uvml

[![License: CC BY 4.0](https://i.creativecommons.org/l/by-nc/4.0/88x31.png)](https://creativecommons.org/licenses/by-nc/4.0/)

UVML is a UVM<sup>[1]</sup> Like framework, that actually follows Universal Verification Methodology, but does not use the standard UVM libraries. UVML consist of common agents like AXI-S and base agents that are meant to be extended to write any other agents like AXI-S. Main purpose of UVML is to simplify the usage of UVM such that one can create a UVM test bench just only by creating the top.sv and test.svh, while having the freedom to use advanced features of SystemVerilog. It does not consist of all the features UVM, but it works with free simulators, Vivado XSIM and Intel QuestaSim.

## How to use

* Copy test bench sources sim/uvml and rtl/uvml_if to your project
* Create test bench top similar to tb/tb_axis.sv
* Create test package similar to test/eg_axis_test.svh,test/eg_axis_seq_item.svh and test/eg_test_pkg.sv
* Compile and run the simulation. Sim.ps1 is a sample QuestaSim power shell script.

## How to create new agent

TODO


<sup>[1]</sup> "IEEE Standard for Universal Verification Methodology Language Reference Manual," in IEEE Std 1800.2-2020 
  (Revision of IEEE Std 1800.2-2017) , vol., no., pp.1-458, 14 Sept. 2020, doi: 10.1109/IEEESTD.2020.9195920.