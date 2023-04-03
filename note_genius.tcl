# Copyright (C) 2020  Intel Corporation. All rights reserved.
# Your use of Intel Corporation's design tools, logic functions 
# and other software and tools, and any partner logic 
# functions, and any output files from any of the foregoing 
# (including device programming or simulation files), and any 
# associated documentation or information are expressly subject 
# to the terms and conditions of the Intel Program License 
# Subscription Agreement, the Intel Quartus Prime License Agreement,
# the Intel FPGA IP License Agreement, or other applicable license
# agreement, including, without limitation, that your use is for
# the sole purpose of programming logic devices manufactured by
# Intel and sold by Intel or its authorized distributors.  Please
# refer to the applicable agreement for further details, at
# https://fpgasoftware.intel.com/eula.

# Quartus Prime: Generate Tcl File for Project
# File: note_genius.tcl
# Generated on: Mon Apr 03 10:26:28 2023

# Load Quartus Prime Tcl Project package
package require ::quartus::project

set need_to_close_project 0
set make_assignments 1

# Check that the right project is open
if {[is_project_open]} {
	if {[string compare $quartus(project) "note_genius"]} {
		puts "Project note_genius is not open"
		set make_assignments 0
	}
} else {
	# Only open if not already open
	if {[project_exists note_genius]} {
		project_open -revision note_genius note_genius
	} else {
		project_new -revision note_genius note_genius
	}
	set need_to_close_project 1
}

# Make assignments
if {$make_assignments} {
	set_global_assignment -name FAMILY "Cyclone V"
	set_global_assignment -name DEVICE 5CEBA4F23C7
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 20.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "18:26:36  MARÃÂÃÂÃÂÃÂ§O 23, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "20.1.1 Lite Edition"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name DEVICE_FILTER_PACKAGE FBGA
	set_global_assignment -name DEVICE_FILTER_PIN_COUNT 484
	set_global_assignment -name DEVICE_FILTER_SPEED_GRADE 7
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name REVISION_TYPE BASE -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS OFF -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "Cyclone V"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 30 -family "Cyclone V"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "Cyclone V"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER OFF -family "Cyclone V"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "Cyclone V"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 3 -family "Cyclone V"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "Cyclone V"
	set_global_assignment -name STRATIXV_CONFIGURATION_SCHEME "PASSIVE SERIAL" -family "Cyclone V"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "Cyclone V"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "Cyclone V"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "Cyclone V"
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN ON -family "Cyclone V"
	set_global_assignment -name ACTIVE_SERIAL_CLOCK FREQ_100MHZ -family "Cyclone V"
	set_global_assignment -name ADVANCED_PHYSICAL_OPTIMIZATION ON -family "Cyclone V"
	set_global_assignment -name ENABLE_OCT_DONE OFF -family "Cyclone V"
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_global_assignment -name VHDL_FILE src/unidade_controle.vhd
	set_global_assignment -name VHDL_FILE src/tx.vhd
	set_global_assignment -name VHDL_FILE src/shift_register.vhd
	set_global_assignment -name VHDL_FILE src/serial_controller.vhd
	set_global_assignment -name VHDL_FILE src/rom_palavras.vhd
	set_global_assignment -name VHDL_FILE src/registrador_n.vhd
	set_global_assignment -name VHDL_FILE src/note_genius_tb2.vhd
	set_global_assignment -name VHDL_FILE src/note_genius_tb1.vhd
	set_global_assignment -name VHDL_FILE src/note_genius.vhd
	set_global_assignment -name VHDL_FILE src/note_generator.vhd
	set_global_assignment -name VHDL_FILE src/msg_generator.vhd
	set_global_assignment -name VHDL_FILE src/hexa7seg.vhd
	set_global_assignment -name VHDL_FILE src/gerador_freq.vhd
	set_global_assignment -name VHDL_FILE src/fluxo_dados.vhd
	set_global_assignment -name VHDL_FILE src/encoder_letras.vhd
	set_global_assignment -name VHDL_FILE src/encoder16x4.vhd
	set_global_assignment -name VHDL_FILE src/edge_detector.vhd
	set_global_assignment -name VHDL_FILE src/decoder4x16.vhd
	set_global_assignment -name VHDL_FILE src/contador_m_maior.vhd
	set_global_assignment -name VHDL_FILE src/contador_m.vhd
	set_global_assignment -name VHDL_FILE src/contador_163.vhd
	set_global_assignment -name VHDL_FILE src/comparador_85.vhd
	set_location_assignment PIN_K22 -to chaves[3]
	set_location_assignment PIN_B16 -to chaves[0]
	set_location_assignment PIN_C16 -to chaves[1]
	set_location_assignment PIN_K20 -to chaves[2]
	set_location_assignment PIN_M21 -to chaves[4]
	set_location_assignment PIN_R22 -to chaves[5]
	set_location_assignment PIN_T22 -to chaves[6]
	set_location_assignment PIN_N19 -to chaves[7]
	set_location_assignment PIN_P19 -to chaves[8]
	set_location_assignment PIN_P17 -to chaves[9]
	set_location_assignment PIN_M18 -to chaves[10]
	set_location_assignment PIN_L17 -to chaves[11]
	set_location_assignment PIN_H13 -to clock
	set_location_assignment PIN_W9 -to iniciar
	set_location_assignment PIN_A12 -to pronto
	set_location_assignment PIN_U7 -to reset
	set_location_assignment PIN_H16 -to db_toca_nota
	set_location_assignment PIN_T15 -to sinal_buzzer
	set_location_assignment PIN_AA14 -to sel_dificuldade[0]
	set_location_assignment PIN_AA13 -to sel_dificuldade[1]
	set_location_assignment PIN_AB13 -to sel_dificuldade[2]
	set_location_assignment PIN_AB12 -to sel_dificuldade[3]
	set_location_assignment PIN_U21 -to msg_hex0[0]
	set_location_assignment PIN_V21 -to msg_hex0[1]
	set_location_assignment PIN_W22 -to msg_hex0[2]
	set_location_assignment PIN_W21 -to msg_hex0[3]
	set_location_assignment PIN_Y22 -to msg_hex0[4]
	set_location_assignment PIN_Y21 -to msg_hex0[5]
	set_location_assignment PIN_AA22 -to msg_hex0[6]
	set_location_assignment PIN_AA20 -to msg_hex1[0]
	set_location_assignment PIN_AB20 -to msg_hex1[1]
	set_location_assignment PIN_AA19 -to msg_hex1[2]
	set_location_assignment PIN_AA18 -to msg_hex1[3]
	set_location_assignment PIN_AB18 -to msg_hex1[4]
	set_location_assignment PIN_AA17 -to msg_hex1[5]
	set_location_assignment PIN_U22 -to msg_hex1[6]
	set_location_assignment PIN_Y19 -to msg_hex2[0]
	set_location_assignment PIN_AB17 -to msg_hex2[1]
	set_location_assignment PIN_AA10 -to msg_hex2[2]
	set_location_assignment PIN_Y14 -to msg_hex2[3]
	set_location_assignment PIN_V14 -to msg_hex2[4]
	set_location_assignment PIN_AB22 -to msg_hex2[5]
	set_location_assignment PIN_AB21 -to msg_hex2[6]
	set_location_assignment PIN_Y16 -to msg_hex3[0]
	set_location_assignment PIN_W16 -to msg_hex3[1]
	set_location_assignment PIN_Y17 -to msg_hex3[2]
	set_location_assignment PIN_V16 -to msg_hex3[3]
	set_location_assignment PIN_U17 -to msg_hex3[4]
	set_location_assignment PIN_V18 -to msg_hex3[5]
	set_location_assignment PIN_V19 -to msg_hex3[6]
	set_location_assignment PIN_U20 -to msg_hex4[0]
	set_location_assignment PIN_Y20 -to msg_hex4[1]
	set_location_assignment PIN_V20 -to msg_hex4[2]
	set_location_assignment PIN_U16 -to msg_hex4[3]
	set_location_assignment PIN_U15 -to msg_hex4[4]
	set_location_assignment PIN_Y15 -to msg_hex4[5]
	set_location_assignment PIN_P9 -to msg_hex4[6]
	set_location_assignment PIN_N9 -to msg_hex5[0]
	set_location_assignment PIN_M8 -to msg_hex5[1]
	set_location_assignment PIN_T14 -to msg_hex5[2]
	set_location_assignment PIN_P14 -to msg_hex5[3]
	set_location_assignment PIN_C1 -to msg_hex5[4]
	set_location_assignment PIN_C2 -to msg_hex5[5]
	set_location_assignment PIN_W19 -to msg_hex5[6]
	set_location_assignment PIN_U13 -to sel_modo[0]
	set_location_assignment PIN_V13 -to sel_modo[1]
	set_location_assignment PIN_N16 -to sout
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
