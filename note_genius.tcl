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
# Generated on: Fri Mar 24 11:34:38 2023

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
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "18:26:36  MARÃÂ§O 23, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "20.1.1 Lite Edition"
	set_global_assignment -name VHDL_FILE src/unidade_controle.vhd
	set_global_assignment -name VHDL_FILE src/shift_register.vhd
	set_global_assignment -name VHDL_FILE src/registrador_n.vhd
	set_global_assignment -name VHDL_FILE src/ram_16x12.vhd
	set_global_assignment -name VHDL_FILE src/note_genius_tb2.vhd
	set_global_assignment -name VHDL_FILE src/note_genius_tb1.vhd
	set_global_assignment -name VHDL_FILE src/note_genius.vhd
	set_global_assignment -name VHDL_FILE src/note_generator.vhd
	set_global_assignment -name VHDL_FILE src/hexa7seg.vhd
	set_global_assignment -name VHDL_FILE src/gerador_freq.vhd
	set_global_assignment -name VHDL_FILE src/fluxo_dados.vhd
	set_global_assignment -name VHDL_FILE src/encoder16x4.vhd
	set_global_assignment -name VHDL_FILE src/edge_detector.vhd
	set_global_assignment -name VHDL_FILE src/decoder4x16.vhd
	set_global_assignment -name VHDL_FILE src/contador_m_maior.vhd
	set_global_assignment -name VHDL_FILE src/contador_m.vhd
	set_global_assignment -name VHDL_FILE src/contador_163.vhd
	set_global_assignment -name VHDL_FILE src/comparador_85.vhd
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
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
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
	set_location_assignment PIN_R22 -to chaves[3]
	set_location_assignment PIN_K20 -to chaves[0]
	set_location_assignment PIN_K22 -to chaves[1]
	set_location_assignment PIN_M21 -to chaves[2]
	set_location_assignment PIN_T22 -to chaves[4]
	set_location_assignment PIN_N19 -to chaves[5]
	set_location_assignment PIN_P19 -to chaves[6]
	set_location_assignment PIN_P17 -to chaves[7]
	set_location_assignment PIN_M18 -to chaves[8]
	set_location_assignment PIN_L17 -to chaves[9]
	set_location_assignment PIN_K17 -to chaves[10]
	set_location_assignment PIN_P18 -to chaves[11]
	set_location_assignment PIN_N16 -to clock
	set_location_assignment PIN_W9 -to iniciar
	set_location_assignment PIN_A12 -to pronto
	set_location_assignment PIN_U7 -to reset
	set_location_assignment PIN_Y19 -to db_estado[0]
	set_location_assignment PIN_AB17 -to db_estado[1]
	set_location_assignment PIN_AA10 -to db_estado[2]
	set_location_assignment PIN_Y14 -to db_estado[3]
	set_location_assignment PIN_V14 -to db_estado[4]
	set_location_assignment PIN_AB22 -to db_estado[5]
	set_location_assignment PIN_AB21 -to db_estado[6]
	set_location_assignment PIN_Y16 -to db_jogada[0]
	set_location_assignment PIN_W16 -to db_jogada[1]
	set_location_assignment PIN_Y17 -to db_jogada[2]
	set_location_assignment PIN_V19 -to db_jogada[6]
	set_location_assignment PIN_V16 -to db_jogada[3]
	set_location_assignment PIN_U17 -to db_jogada[4]
	set_location_assignment PIN_V18 -to db_jogada[5]
	set_location_assignment PIN_U21 -to erros[0]
	set_location_assignment PIN_V21 -to erros[1]
	set_location_assignment PIN_W22 -to erros[2]
	set_location_assignment PIN_W21 -to erros[3]
	set_location_assignment PIN_Y22 -to erros[4]
	set_location_assignment PIN_Y21 -to erros[5]
	set_location_assignment PIN_AA22 -to erros[6]
	set_location_assignment PIN_AA20 -to erros[7]
	set_location_assignment PIN_AB20 -to erros[8]
	set_location_assignment PIN_AA19 -to erros[9]
	set_location_assignment PIN_AA18 -to erros[10]
	set_location_assignment PIN_AB18 -to erros[11]
	set_location_assignment PIN_AA17 -to erros[12]
	set_location_assignment PIN_U22 -to erros[13]
	set_location_assignment PIN_U20 -to db_nota_aleatoria[0]
	set_location_assignment PIN_Y20 -to db_nota_aleatoria[1]
	set_location_assignment PIN_V20 -to db_nota_aleatoria[2]
	set_location_assignment PIN_U16 -to db_nota_aleatoria[3]
	set_location_assignment PIN_U15 -to db_nota_aleatoria[4]
	set_location_assignment PIN_Y15 -to db_nota_aleatoria[5]
	set_location_assignment PIN_P9 -to db_nota_aleatoria[6]
	set_location_assignment PIN_N9 -to db_rodada[0]
	set_location_assignment PIN_M8 -to db_rodada[1]
	set_location_assignment PIN_T14 -to db_rodada[2]
	set_location_assignment PIN_P14 -to db_rodada[3]
	set_location_assignment PIN_C1 -to db_rodada[4]
	set_location_assignment PIN_C2 -to db_rodada[5]
	set_location_assignment PIN_W19 -to db_rodada[6]
	set_location_assignment PIN_M7 -to iniciar_tradicional
	set_location_assignment PIN_F15 -to db_nota[11]
	set_location_assignment PIN_E16 -to db_nota[10]
	set_location_assignment PIN_E14 -to db_nota[9]
	set_location_assignment PIN_B15 -to db_nota[8]
	set_location_assignment PIN_L8 -to db_nota[7]
	set_location_assignment PIN_A15 -to db_nota[6]
	set_location_assignment PIN_J11 -to db_nota[5]
	set_location_assignment PIN_G11 -to db_nota[4]
	set_location_assignment PIN_J18 -to db_nota[3]
	set_location_assignment PIN_G17 -to db_nota[2]
	set_location_assignment PIN_D13 -to db_nota[1]
	set_location_assignment PIN_B13 -to db_nota[0]
	set_location_assignment PIN_M9 -to clock_nota
	set_location_assignment PIN_H16 -to db_toca_nota
	set_location_assignment PIN_T15 -to sinal_buzzer
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
