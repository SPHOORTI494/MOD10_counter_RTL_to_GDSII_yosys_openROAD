# Load the Sky130 standard-cell timing library
read_liberty /sky130hd/lib/sky130_fd_sc_hd__tt_025C_1v80.lib

# Read the synthesized gate-level netlist
read_verilog /work/output/mod10_counter_netlist.v

# Resolve the design and its standard-cell instances
link_design mod10_counter

# Apply timing constraints
read_sdc /work/constraints/constraint.sdc

# Report setup timing paths and timing summary
puts "\n===== POST-SYNTHESIS TIMING PATHS ====="
report_checks -path_delay max

puts "\n===== WORST SETUP SLACK ====="
report_worst_slack -max

puts "\n===== TOTAL NEGATIVE SLACK ====="
report_tns -max

puts "\n===== TIMING CONSTRAINT CHECK ====="
check_setup

puts "\n===== MINIMUM-DELAY PATHS ====="
report_checks -path_delay min -group_count 5

puts "\n===== MAXIMUM-DELAY PATHS ====="
report_checks -path_delay max -group_count 10
