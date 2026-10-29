create_clock -name core_clock -period 10.0 [get_ports {clk}]
set_input_delay 1.0 -clock core_clock [get_ports {rst}]
set_output_delay 1.0 -clock core_clock [get_ports {count[*]}]
