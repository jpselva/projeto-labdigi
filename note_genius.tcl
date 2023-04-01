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
# Generated on: Fri Mar 31 15:51:44 2023

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
	set_global_assignment -name FAMILY "MAX 10"
	set_global_assignment -name DEVICE 10M50DAF484C7G
	set_global_assignment -name ORIGINAL_QUARTUS_VERSION 20.1.1
	set_global_assignment -name PROJECT_CREATION_TIME_DATE "19:11:23  MARçO 23, 2023"
	set_global_assignment -name LAST_QUARTUS_VERSION "20.1.1 Lite Edition"
	set_global_assignment -name PARTITION_NETLIST_TYPE SOURCE -section_id Top
	set_global_assignment -name PARTITION_FITTER_PRESERVATION_LEVEL PLACEMENT_AND_ROUTING -section_id Top
	set_global_assignment -name PARTITION_COLOR 16764057 -section_id Top
	set_global_assignment -name PROJECT_OUTPUT_DIRECTORY output_files
	set_global_assignment -name MIN_CORE_JUNCTION_TEMP 0
	set_global_assignment -name MAX_CORE_JUNCTION_TEMP 85
	set_global_assignment -name ERROR_CHECK_FREQUENCY_DIVISOR 256
	set_global_assignment -name EDA_SIMULATION_TOOL "ModelSim-Altera (Verilog)"
	set_global_assignment -name EDA_TIME_SCALE "1 ps" -section_id eda_simulation
	set_global_assignment -name EDA_OUTPUT_DATA_FORMAT "VERILOG HDL" -section_id eda_simulation
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_timing
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_symbol
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_signal_integrity
	set_global_assignment -name EDA_GENERATE_FUNCTIONAL_NETLIST OFF -section_id eda_board_design_boundary_scan
	set_global_assignment -name TIMING_ANALYZER_MULTICORNER_ANALYSIS ON -family "MAX 10"
	set_global_assignment -name TIMING_ANALYZER_REPORT_WORST_CASE_TIMING_PATHS OFF -family "MAX 10"
	set_global_assignment -name TIMING_ANALYZER_CCPP_TRADEOFF_TOLERANCE 0 -family "MAX 10"
	set_global_assignment -name TDC_CCPP_TRADEOFF_TOLERANCE 0 -family "MAX 10"
	set_global_assignment -name TIMING_ANALYZER_DO_CCPP_REMOVAL ON -family "MAX 10"
	set_global_assignment -name DISABLE_LEGACY_TIMING_ANALYZER OFF -family "MAX 10"
	set_global_assignment -name SYNTH_TIMING_DRIVEN_SYNTHESIS ON -family "MAX 10"
	set_global_assignment -name SYNCHRONIZATION_REGISTER_CHAIN_LENGTH 2 -family "MAX 10"
	set_global_assignment -name SYNTH_RESOURCE_AWARE_INFERENCE_FOR_BLOCK_RAM ON -family "MAX 10"
	set_global_assignment -name OPTIMIZE_HOLD_TIMING "ALL PATHS" -family "MAX 10"
	set_global_assignment -name OPTIMIZE_MULTI_CORNER_TIMING ON -family "MAX 10"
	set_global_assignment -name AUTO_DELAY_CHAINS ON -family "MAX 10"
	set_global_assignment -name CRC_ERROR_OPEN_DRAIN OFF -family "MAX 10"
	set_global_assignment -name USE_CONFIGURATION_DEVICE ON -family "MAX 10"
	set_global_assignment -name ENABLE_OCT_DONE ON -family "MAX 10"
	set_global_assignment -name VHDL_FILE src/unidade_controle.vhd
	set_global_assignment -name VHDL_FILE src/shift_register.vhd
	set_global_assignment -name VHDL_FILE src/rom_palavras.vhd
	set_global_assignment -name VHDL_FILE src/registrador_n.vhd
	set_global_assignment -name VHDL_FILE src/ram_16x12.vhd
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
	set_global_assignment -name POWER_PRESET_COOLING_SOLUTION "23 MM HEAT SINK WITH 200 LFPM AIRFLOW"
	set_global_assignment -name POWER_BOARD_THERMAL_MODEL "NONE (CONSERVATIVE)"
	set_location_assignment PIN_B8 -to reset
	set_location_assignment PIN_A7 -to iniciar
	set_location_assignment PIN_P11 -to clock
	set_location_assignment PIN_W10 -to chaves[0]
	set_location_assignment PIN_W9 -to chaves[1]
	set_location_assignment PIN_W8 -to chaves[2]
	set_location_assignment PIN_W7 -to chaves[3]
	set_location_assignment PIN_V5 -to chaves[4]
	set_location_assignment PIN_AA15 -to chaves[5]
	set_location_assignment PIN_W13 -to chaves[6]
	set_location_assignment PIN_AB13 -to chaves[7]
	set_location_assignment PIN_Y11 -to chaves[8]
	set_location_assignment PIN_W11 -to chaves[9]
	set_location_assignment PIN_AA10 -to chaves[10]
	set_location_assignment PIN_Y8 -to chaves[11]
	set_location_assignment PIN_AA2 -to sinal_buzzer
	set_location_assignment PIN_C14 -to erros[0]
	set_location_assignment PIN_E15 -to erros[1]
	set_location_assignment PIN_C15 -to erros[2]
	set_location_assignment PIN_C16 -to erros[3]
	set_location_assignment PIN_E16 -to erros[4]
	set_location_assignment PIN_D17 -to erros[5]
	set_location_assignment PIN_C17 -to erros[6]
	set_location_assignment PIN_C18 -to erros[7]
	set_location_assignment PIN_D18 -to erros[8]
	set_location_assignment PIN_E18 -to erros[9]
	set_location_assignment PIN_B16 -to erros[10]
	set_location_assignment PIN_A17 -to erros[11]
	set_location_assignment PIN_A18 -to erros[12]
	set_location_assignment PIN_B17 -to erros[13]
	set_location_assignment PIN_J20 -to db_rodada[0]
	set_location_assignment PIN_K20 -to db_rodada[1]
	set_location_assignment PIN_L18 -to db_rodada[2]
	set_location_assignment PIN_N18 -to db_rodada[3]
	set_location_assignment PIN_M20 -to db_rodada[4]
	set_location_assignment PIN_N19 -to db_rodada[5]
	set_location_assignment PIN_N20 -to db_rodada[6]
	set_location_assignment PIN_F21 -to db_jogada[0]
	set_location_assignment PIN_E22 -to db_jogada[1]
	set_location_assignment PIN_E21 -to db_jogada[2]
	set_location_assignment PIN_C19 -to db_jogada[3]
	set_location_assignment PIN_C20 -to db_jogada[4]
	set_location_assignment PIN_D19 -to db_jogada[5]
	set_location_assignment PIN_E17 -to db_jogada[6]
	set_location_assignment PIN_B20 -to db_estado[0]
	set_location_assignment PIN_A20 -to db_estado[1]
	set_location_assignment PIN_B19 -to db_estado[2]
	set_location_assignment PIN_A21 -to db_estado[3]
	set_location_assignment PIN_B21 -to db_estado[4]
	set_location_assignment PIN_C22 -to db_estado[5]
	set_location_assignment PIN_B22 -to db_estado[6]
	set_location_assignment PIN_A13 -to sel_dificuldade[0]
	set_location_assignment PIN_A14 -to sel_dificuldade[1]
	set_location_assignment PIN_B14 -to sel_dificuldade[2]
	set_location_assignment PIN_F15 -to sel_dificuldade[3]
	set_location_assignment PIN_A8 -to pronto
	set_location_assignment PIN_B11 -to db_toca_nota
	set_location_assignment PIN_F18 -to db_nota_correta[0]
	set_location_assignment PIN_E20 -to db_nota_correta[1]
	set_location_assignment PIN_E19 -to db_nota_correta[2]
	set_location_assignment PIN_J18 -to db_nota_correta[3]
	set_location_assignment PIN_H19 -to db_nota_correta[4]
	set_location_assignment PIN_F19 -to db_nota_correta[5]
	set_location_assignment PIN_F20 -to db_nota_correta[6]
	set_location_assignment PIN_A12 -to sel_modo[0]
	set_location_assignment PIN_B12 -to sel_modo[1]
	set_location_assignment PIN_C14 -to msg_hex0[0]
	set_location_assignment PIN_C17 -to msg_hex0[6]
	set_location_assignment PIN_D17 -to msg_hex0[5]
	set_location_assignment PIN_E16 -to msg_hex0[4]
	set_location_assignment PIN_C16 -to msg_hex0[3]
	set_location_assignment PIN_C15 -to msg_hex0[2]
	set_location_assignment PIN_E15 -to msg_hex0[1]
	set_location_assignment PIN_B17 -to msg_hex1[6]
	set_location_assignment PIN_A18 -to msg_hex1[5]
	set_location_assignment PIN_A17 -to msg_hex1[4]
	set_location_assignment PIN_B16 -to msg_hex1[3]
	set_location_assignment PIN_E18 -to msg_hex1[2]
	set_location_assignment PIN_D18 -to msg_hex1[1]
	set_location_assignment PIN_C18 -to msg_hex1[0]
	set_location_assignment PIN_B22 -to msg_hex2[6]
	set_location_assignment PIN_C22 -to msg_hex2[5]
	set_location_assignment PIN_B21 -to msg_hex2[4]
	set_location_assignment PIN_A21 -to msg_hex2[3]
	set_location_assignment PIN_B19 -to msg_hex2[2]
	set_location_assignment PIN_A20 -to msg_hex2[1]
	set_location_assignment PIN_B20 -to msg_hex2[0]
	set_location_assignment PIN_E17 -to msg_hex3[6]
	set_location_assignment PIN_D19 -to msg_hex3[5]
	set_location_assignment PIN_C20 -to msg_hex3[4]
	set_location_assignment PIN_C19 -to msg_hex3[3]
	set_location_assignment PIN_E21 -to msg_hex3[2]
	set_location_assignment PIN_E22 -to msg_hex3[1]
	set_location_assignment PIN_F21 -to msg_hex3[0]
	set_location_assignment PIN_F20 -to msg_hex4[6]
	set_location_assignment PIN_F19 -to msg_hex4[5]
	set_location_assignment PIN_H19 -to msg_hex4[4]
	set_location_assignment PIN_J18 -to msg_hex4[3]
	set_location_assignment PIN_E19 -to msg_hex4[2]
	set_location_assignment PIN_E20 -to msg_hex4[1]
	set_location_assignment PIN_F18 -to msg_hex4[0]
	set_location_assignment PIN_N20 -to msg_hex5[6]
	set_location_assignment PIN_N19 -to msg_hex5[5]
	set_location_assignment PIN_M20 -to msg_hex5[4]
	set_location_assignment PIN_N18 -to msg_hex5[3]
	set_location_assignment PIN_L18 -to msg_hex5[2]
	set_location_assignment PIN_K20 -to msg_hex5[1]
	set_location_assignment PIN_J20 -to msg_hex5[0]
	set_instance_assignment -name PARTITION_HIERARCHY root_partition -to | -section_id Top

	# Including default assignments

	# Commit assignments
	export_assignments

	# Close project
	if {$need_to_close_project} {
		project_close
	}
}
