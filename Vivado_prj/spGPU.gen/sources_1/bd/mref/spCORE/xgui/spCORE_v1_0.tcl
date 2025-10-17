# Definitional proc to organize widgets for parameters.
proc init_gui { IPINST } {
  ipgui::add_param $IPINST -name "Component_Name"
  #Adding Page
  set Page_0 [ipgui::add_page $IPINST -name "Page 0"]
  ipgui::add_param $IPINST -name "INSTR_LENGTH" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_Accelerators" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_color" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_opcode" -parent ${Page_0}
  ipgui::add_param $IPINST -name "N_pixel" -parent ${Page_0}


}

proc update_PARAM_VALUE.INSTR_LENGTH { PARAM_VALUE.INSTR_LENGTH } {
	# Procedure called to update INSTR_LENGTH when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.INSTR_LENGTH { PARAM_VALUE.INSTR_LENGTH } {
	# Procedure called to validate INSTR_LENGTH
	return true
}

proc update_PARAM_VALUE.N_Accelerators { PARAM_VALUE.N_Accelerators } {
	# Procedure called to update N_Accelerators when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_Accelerators { PARAM_VALUE.N_Accelerators } {
	# Procedure called to validate N_Accelerators
	return true
}

proc update_PARAM_VALUE.N_color { PARAM_VALUE.N_color } {
	# Procedure called to update N_color when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_color { PARAM_VALUE.N_color } {
	# Procedure called to validate N_color
	return true
}

proc update_PARAM_VALUE.N_opcode { PARAM_VALUE.N_opcode } {
	# Procedure called to update N_opcode when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_opcode { PARAM_VALUE.N_opcode } {
	# Procedure called to validate N_opcode
	return true
}

proc update_PARAM_VALUE.N_pixel { PARAM_VALUE.N_pixel } {
	# Procedure called to update N_pixel when any of the dependent parameters in the arguments change
}

proc validate_PARAM_VALUE.N_pixel { PARAM_VALUE.N_pixel } {
	# Procedure called to validate N_pixel
	return true
}


proc update_MODELPARAM_VALUE.INSTR_LENGTH { MODELPARAM_VALUE.INSTR_LENGTH PARAM_VALUE.INSTR_LENGTH } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.INSTR_LENGTH}] ${MODELPARAM_VALUE.INSTR_LENGTH}
}

proc update_MODELPARAM_VALUE.N_opcode { MODELPARAM_VALUE.N_opcode PARAM_VALUE.N_opcode } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_opcode}] ${MODELPARAM_VALUE.N_opcode}
}

proc update_MODELPARAM_VALUE.N_color { MODELPARAM_VALUE.N_color PARAM_VALUE.N_color } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_color}] ${MODELPARAM_VALUE.N_color}
}

proc update_MODELPARAM_VALUE.N_pixel { MODELPARAM_VALUE.N_pixel PARAM_VALUE.N_pixel } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_pixel}] ${MODELPARAM_VALUE.N_pixel}
}

proc update_MODELPARAM_VALUE.N_Accelerators { MODELPARAM_VALUE.N_Accelerators PARAM_VALUE.N_Accelerators } {
	# Procedure called to set VHDL generic/Verilog parameter value(s) based on TCL parameter value
	set_property value [get_property value ${PARAM_VALUE.N_Accelerators}] ${MODELPARAM_VALUE.N_Accelerators}
}

