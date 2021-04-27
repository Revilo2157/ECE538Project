# To Be Run From the Compilation Directory
set top_module $::env(top)
read_verilog ${top_module}_gatelevel.v
set link_library "* nangate_scan.db"
current_design ${top_module}
link
set_scan_configuration -style multiplexed_flip_flop
create_clock $::env(clk) -period 10
set target_library nangate_scan.db  
compile -scan -map_effort medium
set_scan_configuration -chain_count 3
create_test_protocol -infer_clock -infer_asynch
dft_drc
report_dft_drc_violations > ${top_module}_DRCviolations.rpt
preview_dft 
insert_dft

# Report Things
report_scan_path > ${top_module}.scan_path_rpt
report_area > ${top_module}.area_rpt                                                                                     
report_timing > ${top_module}.timing_rpt
report_power > ${top_module}.power_rpt
write_test_protocol -output ${top_module}.spf
write -hierarchy -format verilog -output ${top_module}_scan.v
write -hierarchy -format ddc -output ${top_module}.ddc
write_sdf -version 2.1 -context verilog ${top_module}.sdf 
exit
