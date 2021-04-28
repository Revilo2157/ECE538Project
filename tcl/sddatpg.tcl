set top_module $::env(top)

set scan_lib ./nangate_scan.v
set stil_file  ./gate/${top_module}/${top_module}.spf 

read_netlist -delete
# read in scan cell library
read_netlist $scan_lib -library
# read in user's synthesized verilog code
#read_netlist $synthesized_files

read_netlist  ./gate/${top_module}/${top_module}_scan.v


run_build_model $top_module
# ignoring warnings like N20 or B10
# Set STIL file from DFT Compiler
set_drc $stil_file
# run check to see if synthesized code violates any testing rules
add_clocks 0  $::env(clk)
add_pi_constraints 0 test_se
run_drc


read_timing ./SDD/slack.dat
set_delay -launch_cycle last_shift
set_faults -model transition
add_faults -all
set_faults -report collapsed
set_faults -summary verbose 

set_delay -max_tmgn $::env(TMGN)
puts $::env(TMGN)

set max_patterns $::env(patterns)
set time_per_run $::env(time)
set_atpg -patterns $max_patterns -time [list 0 $time_per_run]

run_atpg basic_scan_only -ndetects 1
# report_faults -slack effectiveness  
#report_faults -slack tdet 
#report_faults -slack delta
report_faults -slack sdql
write_patterns ./SDD/pattern_sdd_slack.stil -internal -format STIL -unified_stil_flow -replace 


exit
