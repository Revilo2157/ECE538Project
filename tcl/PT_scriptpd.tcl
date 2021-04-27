set library_name NangateOpenCellLibrary
set link_library [list * ./nangate_scan.db]


read_verilog  s5378_bench.v

#ungroup -flatten -all
# Define top level in the hierarchy
current_design "s5378_bench"

link_design 

# SET CONSTRAINTS

set_max_area 0
#Clock setup commands
set CLK_PERIOD $::env(CLK_PERIOD)
#set DFF_CKQ 0.02
#set SETUP_TIME 0.01
set CLK "blif_clk_net" 
create_clock -period $CLK_PERIOD [get_ports $CLK]
set_clock_transition -rise 0.05 [get_clocks $CLK]
set_clock_transition -fall 0.03 [get_clocks $CLK]
set_clock_latency -rise 0.01 [get_clocks $CLK]
set_clock_latency -fall 0.03 [get_clocks $CLK]



set_ideal_network [get_ports blif_clk_net]
#set_propagated_clock [all_clocks]
#set_clock_uncertainty 0.2 [all_clocks]

#set_operating_conditions -min WORST -max WORST

report_timing 

source pt2tmax.tcl

set NUM_PATHS $::env(NUM_PATHS)
write_delay_paths -max_paths $NUM_PATHS  -nworst 1  -delay_type max ./pathdelay/timing${NUM_PATHS}withoutmob.rpt


quit



