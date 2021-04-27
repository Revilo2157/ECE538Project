set target_library "NangateOpenCellLibrary.db "
set link_library   "* NangateOpenCellLibrary.db"

set timestamp [clock format [clock scan now] -format "%Y-%m-%d_%H-%M"]
set enable_page_mode false
set sh_new_variable_message false
set verilogout_no_tri true
set verilogout_show_unconnected_pins true
set hdlin_auto_save_templates true

set sourceDir $::env(source)
set top_module $::env(top)
set clk_pin $::env(clk)

############# Elaborate Design ################
foreach {file} [ls ${sourceDir}/*.v] { 
    read_file -format verilog ${file}
}

current_design ${top_module}
link
compile

uniquify -dont_skip_empty_designs
#set set_ultra_optimization true


set all_input_but_clock  [remove_from_collection [all_inputs] $clk_pin]

###################################################################
##...............define generated clock............................
create_clock -period  2  [get_ports $clk_pin]
set_clock_uncertainty -setup 0.1 [get_ports $clk_pin]
set_clock_uncertainty -hold  0.1 [get_ports $clk_pin]
set_clock_transition 0.1 [get_clocks $clk_pin]
##.............delay and drive strength on input ports.............
set_input_delay -max 0 -clock $clk_pin  $all_input_but_clock
set_input_delay -min 0 -clock $clk_pin  $all_input_but_clock
#set_driving_cell  -lib_cell INVX1 $all_input_but_clock
##set_operating_conditions -min best -max worst
set_wire_load_mode segmented
set_load 0.1 [all_inputs]
###################################################################
check_design
set_max_area 0
set_fix_hold [all_clocks]
set verilogout_show_unconnected_pins true
set verilogout_no_tri true
set_fix_multiple_port_nets -all -buffer_constants

compile

## Report Design
define_name_rules verilog -case_insensitive
change_names -hierarchy -rules verilog
ungroup -all -flatten
write  -h -format verilog -output "${top_module}_gatelevel.v"
exit
