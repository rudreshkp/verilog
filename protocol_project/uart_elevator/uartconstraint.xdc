###############################################################################
# Clock (50 MHz)
###############################################################################

set_property -dict { PACKAGE_PIN N11 IOSTANDARD LVCMOS33 } [get_ports clk]
create_clock -period 20.000 -name sys_clk [get_ports clk]

###############################################################################
# Reset Button (Center Push Button)
###############################################################################

set_property -dict { PACKAGE_PIN M14 IOSTANDARD LVCMOS33 PULLDOWN true } [get_ports rst]

###############################################################################
# USB UART RX
###############################################################################

set_property -dict { PACKAGE_PIN D4 IOSTANDARD LVCMOS33 } [get_ports rx]

###############################################################################
# Floor Display LEDs
###############################################################################

set_property -dict { PACKAGE_PIN J3 IOSTANDARD LVCMOS33 } [get_ports {current_floor[0]}]
set_property -dict { PACKAGE_PIN H3 IOSTANDARD LVCMOS33 } [get_ports {current_floor[1]}]

###############################################################################
# Elevator Status LEDs
###############################################################################

set_property -dict { PACKAGE_PIN J1 IOSTANDARD LVCMOS33 } [get_ports motor_up]
set_property -dict { PACKAGE_PIN K1 IOSTANDARD LVCMOS33 } [get_ports motor_down]
set_property -dict { PACKAGE_PIN L3 IOSTANDARD LVCMOS33 } [get_ports door_open]
