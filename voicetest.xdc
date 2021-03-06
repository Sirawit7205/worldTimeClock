## Constraint file voicetest.xdc for BASYS3 FPGA board.
## Auto-generated by Constraint Generator on 17/11/2561 1:07:56

## Clock
set_property PACKAGE_PIN W5 [get_ports clock]
	set_property IOSTANDARD LVCMOS33 [get_ports clock]
	create_clock -add -name sys_clk_pin -period 10.00 -waveform {0 5} [get_ports clock]


## Switches
set_property PACKAGE_PIN W17 [get_ports flag]					
	set_property IOSTANDARD LVCMOS33 [get_ports flag]

## LEDs


## Seven segment


## Buttons
set_property PACKAGE_PIN T18 [get_ports swRec]
	set_property IOSTANDARD LVCMOS33 [get_ports swRec]
set_property PACKAGE_PIN U17 [get_ports swStop]
	set_property IOSTANDARD LVCMOS33 [get_ports swStop]


## PMOD A


## PMOD B


## PMOD C
set_property PACKAGE_PIN N17 [get_ports rec]
	set_property IOSTANDARD LVCMOS33 [get_ports rec]
set_property PACKAGE_PIN P18 [get_ports play]
	set_property IOSTANDARD LVCMOS33 [get_ports play]


## PMOD X


## VGA


## USB RS-232


## USB PS/2 (HID)


## Quad SPI


## End file
