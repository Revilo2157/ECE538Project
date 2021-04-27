
set top_module s5378_bench
set scan_lib ./nangate_scan.v
set stil_file  ./des2d1.spf 

read_netlist -delete
# read in scan cell library
read_netlist $scan_lib -library
# read in user's synthesized verilog code
#read_netlist $synthesized_files

read_netlist  s5378_bench.v


run_build_model $top_module
# ignoring warnings like N20 or B10
# Set STIL file from DFT Compiler
set_drc $stil_file
# run check to see if synthesized code violates any testing rules
add_clocks 0 blif_clk_net
add_pi_constraints 0 test_se
run_drc

set_atpg -full_seq_merge medium
set_faults -model path_delay
set_faults -report collapsed
#add_faults -all
set_rule P7 war

set NUM_PATHS $::env(NUM_PATHS)
add_delay_path ./pathdelay/timing${NUM_PATHS}withoutmob.rpt
add_faults -all
#set_atpg -nofull_seq_atpg
run_atpg -auto
write_patterns ./pathdelay/patterns${NUM_PATHS}.stil -internal -format STIL -unified_stil_flow -replace 




exit
