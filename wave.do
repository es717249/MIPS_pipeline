onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /MIPS_pipeline_TB/reset
add wave -noupdate /MIPS_pipeline_TB/enable
add wave -noupdate -divider mux_to_updatePC_jump
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_updatePC_withJump/mux_sel
add wave -noupdate -label PC_next_f -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_updatePC_withJump/data1
add wave -noupdate -label New_JumpAddress_m -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_updatePC_withJump/data2
add wave -noupdate -label RD1_m -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_updatePC_withJump/data3
add wave -noupdate -label Branch_or_not_m -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_updatePC_withJump/data4
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_updatePC_withJump/Data_out
add wave -noupdate -divider ProgramCounter_Reg
add wave -noupdate /MIPS_pipeline_TB/testing_mips/ProgramCounter_Reg/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/ProgramCounter_Reg/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/ProgramCounter_Reg/Data_Output
add wave -noupdate -divider Fetch_pipeline
add wave -noupdate -label PC_current_f -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Fetch_Pipeline1/Data_Input
add wave -noupdate -label PC_current_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Fetch_Pipeline1/Data_Output
add wave -noupdate -divider 2
add wave -noupdate -color Red /MIPS_pipeline_TB/clk
add wave -noupdate -label Inst.Fetched_f -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Fetch_Pipeline2/Data_Input
add wave -noupdate -color Red -label Inst.Fetched_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Fetch_Pipeline2/Data_Output
add wave -noupdate -divider 3
add wave -noupdate -label PC_next_f -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Fetch_Pipeline3/Data_Input
add wave -noupdate -label PC_next_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Fetch_Pipeline3/Data_Output
add wave -noupdate -divider V_ROM
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualAddress_ROM/translated_addr
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualAddress_ROM/MIPS_address
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualAddress_ROM/aligment_error
add wave -noupdate -divider rom
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/ROM/addr
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/ROM/q
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider Decoder
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/opcode_reg
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/funct_reg
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/addr_input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/zero
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/RegDst_reg
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/ALUControl
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/flag_sw
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/flag_lw
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/flag_R_type
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/flag_I_type
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/flag_J_type
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/ALUSrcBselector
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/mult_operation
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/mflo_flag
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/MemtoReg
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/see_uartflag_ind
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/MemWrite
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/decoder_module/PC_En
add wave -noupdate -divider Reg_File
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/reset
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Read_Reg1
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Read_Reg2
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Write_Reg
add wave -noupdate -color Red -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Write_Data
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Write
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Read_Data1
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Read_Data2
add wave -noupdate -divider mux_A3_dest
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/mux_A3_destination/mux_sel
add wave -noupdate -label rt_wire -radix unsigned /MIPS_pipeline_TB/testing_mips/mux_A3_destination/data1
add wave -noupdate -label rd_wire -radix unsigned /MIPS_pipeline_TB/testing_mips/mux_A3_destination/data2
add wave -noupdate -label 5'd31 -radix unsigned /MIPS_pipeline_TB/testing_mips/mux_A3_destination/data3
add wave -noupdate -label reserved -radix unsigned /MIPS_pipeline_TB/testing_mips/mux_A3_destination/data4
add wave -noupdate -label mux_A3out -radix unsigned /MIPS_pipeline_TB/testing_mips/mux_A3_destination/Data_out
add wave -noupdate -divider pipe_MuxA3out
add wave -noupdate /MIPS_pipeline_TB/testing_mips/Decode_Pipeline_Mux_A3out/clk
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/Decode_Pipeline_Mux_A3out/Data_Input
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/Decode_Pipeline_Mux_A3out/Data_Output
add wave -noupdate -divider SignExtended_out_d
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/signExt/immediate
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/signExt/extended_sign_out
add wave -noupdate -divider decode_alucontrolFF
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline_ALUControl/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline_ALUControl/Data_Output
add wave -noupdate -divider address_prep
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/add_prep/Mmemory_output
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/add_prep/opcode
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/add_prep/funct
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/add_prep/rs
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/add_prep/rt
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/add_prep/rd
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/add_prep/shamt
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/add_prep/immediate_data
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/add_prep/address_j
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider pipeline_FF1-Addresjwire
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline1/clk
add wave -noupdate -label Addresjwire_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline1/Data_Input
add wave -noupdate -label Addresjwire_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline1/Data_Output
add wave -noupdate -divider pipeline_FF2-PC_Current
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline2/clk
add wave -noupdate -label PC_Current_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline2/Data_Input
add wave -noupdate -label PC_Current_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline2/Data_Output
add wave -noupdate -divider pipeline_FF3-Sign_extend_d
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline3/clk
add wave -noupdate -label Sign_extend_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline3/Data_Input
add wave -noupdate -label Sign_extend_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline3/Data_Output
add wave -noupdate -divider pipeline_FF4-Shamt_wire_d
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline4/clk
add wave -noupdate -label Shamt_wire_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline4/Data_Input
add wave -noupdate -label Shamt_wire_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline4/Data_Output
add wave -noupdate -divider pipeline_FF5-RD1_d
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline5/clk
add wave -noupdate -label {RD1_d } -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline5/Data_Input
add wave -noupdate -label RD1_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline5/Data_Output
add wave -noupdate -divider pipeline_FF6-RD2_d
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline6/clk
add wave -noupdate -label RD2_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline6/Data_Input
add wave -noupdate -label RD2_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline6/Data_Output
add wave -noupdate -divider pipeline_FF7-PC_Next
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline7/clk
add wave -noupdate -label PC_next_d -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline7/Data_Input
add wave -noupdate -label PC_next_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Decode_Pipeline7/Data_Output
add wave -noupdate -divider ALU_unit
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/dataA
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/dataB
add wave -noupdate -color Red -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/dataC
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/control
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/shmt
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/carry
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/zero
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/negative
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/result_reg
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/mask
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/compl_B
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/alu_unit/negative_reg
add wave -noupdate -divider Adder_branch
add wave -noupdate -label shifted2 -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Adder_branch/A
add wave -noupdate -label PC_next -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Adder_branch/B
add wave -noupdate -label Branch_or_not -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Adder_branch/C
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider Pipeline1-RD1
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline1/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline1/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline1/Data_Output
add wave -noupdate -divider Pipeline2-new_JumpAdd
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline2/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline2/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline2/Data_Output
add wave -noupdate -divider Pipeline3-Zero_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline3/clk
add wave -noupdate -label zero_e -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline3/Data_Input
add wave -noupdate -label zero_m -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline3/Data_Output
add wave -noupdate -divider Pipeline4-RD2_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline4/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline4/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline4/Data_Output
add wave -noupdate -divider Pipeline5-carry_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline5/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline5/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline5/Data_Output
add wave -noupdate -divider Pipeline6-negative_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline6/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline6/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline6/Data_Output
add wave -noupdate -divider Pipeline7_ALU_result_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline7/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline7/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline7/Data_Output
add wave -noupdate -divider Pipeline8-Branch_ornot_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline8/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline8/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline8/Data_Output
add wave -noupdate -divider Pipeline9-PC_next_e
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline9/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline9/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/Execution_Pipeline9/Data_Output
add wave -noupdate -divider mux_alu_lo_reg
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mux_ALU_Lo_reg/mux_sel
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mux_ALU_Lo_reg/data1
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mux_ALU_Lo_reg/data2
add wave -noupdate -label ALUout -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mux_ALU_Lo_reg/Data_out
add wave -noupdate -divider demux_aluout
add wave -noupdate -label ALUout -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_aluout/Demux_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_aluout/Selector
add wave -noupdate -label Demux_aluout0 -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_aluout/Dataout0
add wave -noupdate -label Demux_aluout1 -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_aluout/Dataout1
add wave -noupdate -divider demux_writeback
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_writeback/Demux_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_writeback/Selector
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_writeback/Dataout0
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_writeback/Dataout1
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_writeback/Dataout2
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/demux_writeback/Dataout3
add wave -noupdate -divider virtual_RAM
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/address
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/swdetect
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/translated_addr
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/MIPS_address
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/aligment_error
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/dataBack_Selector_out
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/Data_selector_periph_or_mem
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/clr_rx_flag
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/clr_tx_flag
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/Start_uart_tx
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/VirtualRAM_Mem/enable_StoreTxbuff
add wave -noupdate -divider RAM
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mem_RAM/addr
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mem_RAM/wdata
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mem_RAM/we
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mem_RAM/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/mem_RAM/q
add wave -noupdate -divider Pipeline1-DataRAM_m
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MemAccess_Pipeline1/clk
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MemAccess_Pipeline1/Data_Input
add wave -noupdate -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MemAccess_Pipeline1/Data_Output
TreeUpdate [SetDefaultTree]
quietly WaveActivateNextPane
add wave -noupdate -divider Mux_to_WriteData_RegFile
add wave -noupdate -label MemtoReg_wire -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_WriteData_RegFile/mux_sel
add wave -noupdate -label Demux_aluout0 -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_WriteData_RegFile/data1
add wave -noupdate -label Mem_or_Periph_D -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_WriteData_RegFile/data2
add wave -noupdate -label PC_next_w -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_WriteData_RegFile/data3
add wave -noupdate -label peripheral_data -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_WriteData_RegFile/data4
add wave -noupdate -label DatatoWD3 -radix hexadecimal /MIPS_pipeline_TB/testing_mips/MUX_to_WriteData_RegFile/Data_out
add wave -noupdate -divider Reg_File
add wave -noupdate -color Red -radix hexadecimal /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Write_Data
add wave -noupdate -radix unsigned /MIPS_pipeline_TB/testing_mips/RegisterFile_Unit/Write_Reg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {Fetch {775 ps} 0} {Decode {800 ps} 0} {Execution {850 ps} 0} {Mem_access {888 ps} 0} {WriteBack {1556 ps} 0}
quietly wave cursor active 5
configure wave -namecolwidth 176
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ps
update
WaveRestoreZoom {1138 ps} {1598 ps}
