/* FPGA: DEVICE 5CGXFC5C6F27C7*/

module MIPS_pipeline #(
    parameter DATA_WIDTH=32,	/* length of data */
    parameter ADDR_WIDTH=8,		/* bits to address the elements */    
    //UART TX/RX
    parameter UART_Nbit =8,
    parameter baudrate =9600,
    parameter clk_freq = 50000000
    /* parameter baudrate= 5,	
	parameter clk_freq =50 */
)(
    input clk, 					/* clk signal */
    input reset, 				/* async signal to reset */	
    //UART RX
    input SerialDataIn, //it's the input data port     
    output Rx_flag,  //indicates the data was completely received 
    output [UART_Nbit-1:0] DataRx_out/*synthesis keep*/, //Port where Rx information is available
    //UART TX
    output SerialDataOut,
    output [7:0] gpio_data_out
);


/*****************************************************************************************************************************
                F E T C H   S I G N A L S 
*****************************************************************************************************************************/

/***************************************************************
Signals to update Program Counter
***************************************************************/
wire [DATA_WIDTH-1:0] PC_current_f/*synthesis keep*/;	/* Current Program counter */
wire [DATA_WIDTH-1:0] PC_source/*synthesis keep*/;	/* signal from mux to PC register */
wire [DATA_WIDTH-1:0] start_PC;                     /* Signal to initialize the PC to x400000 */
wire [DATA_WIDTH-1:0] PC_next_f;	                    /* signal from mux to PC register */
wire [DATA_WIDTH-1:0] Branch_or_not_m;                  /* Branch address */
/***************************************************************
Signals for the Virtual Memory unit 
***************************************************************/
wire aligment_error_wire;
wire [DATA_WIDTH-1:0] translated_addr_wire/*synthesis keep*/;
wire [DATA_WIDTH-1:0] MIPS_address/*synthesis keep*/;
wire [DATA_WIDTH-1:0]Instruction_fetched_f/*synthesis keep*/; 	//Instruction fetched -fetch

/* Flip flop stage for Pipeline */
wire enable_fetchFF_stage;

/*****************************************************************************************************************************
                D E C O D E   S I G N A L S 
*****************************************************************************************************************************/

wire [DATA_WIDTH-1:0] PC_current_d/*synthesis keep*/;	/* Current Program counter */
wire [DATA_WIDTH-1:0] PC_next_d;	                    /* signal from mux to PC register */
wire [DATA_WIDTH-1:0]Instruction_fetched_d/*synthesis keep*/; 	//Instruction fetched -decode
/***************************************************************
Signals for Address preparation module
***************************************************************/
wire [5 :0 ]opcode_wire/*synthesis keep*/;							//Opcode field of the instruction
wire [4 : 0]rs_wire/*synthesis keep*/;		 			//source 1	(R-I type)
wire [4 : 0]rt_wire/*synthesis keep*/;		 			//source 2	(R-I type)
wire [4 : 0]rd_wire/*synthesis keep*/;		  			//Destination: 15:11 bit (R type)
wire [4 : 0]shamt_wire_d/*synthesis keep*/;				//shamt field (R type)
wire [5 : 0]funct_wire/*synthesis keep*/;				//select the function
wire [15: 0]immediate_data_wire/*synthesis keep*/;		//immediate field (I type)
wire [25: 0]address_j_wire_d/*synthesis keep*/;			//address field for (J type)
/***************************************************************
Signals for Register File 
***************************************************************/
wire [DATA_WIDTH-1 : 0] RD1_d/*synthesis keep*/;  
wire [DATA_WIDTH-1 : 0] RD2_d/*synthesis keep*/;
wire [4:0]mux_A3out/*synthesis keep*/;
/***************************************************************
Signals for Sign Extend module
***************************************************************/
wire [DATA_WIDTH-1:0] sign_extended_out_d/*synthesis keep*/;
/* Flip flop stage for Pipeline */
wire enable_decodeFF_stage;
wire flag_bne;
wire flag_beq;

/*****************************************************************************************************************************
                E X E C U T I O N   S I G N A L S 
*****************************************************************************************************************************/
/* Address preparation */
wire [4 : 0]rs_wire_e/*synthesis keep*/;		 			//source 1	(R-I type)
wire [4 : 0]rt_wire_e/*synthesis keep*/;		 			//source 2	(R-I type)
wire [4 : 0]rd_wire_e/*synthesis keep*/;		  			//Destination: 15:11 bit (R type)

/* Program counter */
wire [3:0] PC_current_e/*synthesis keep*/;	/* Current Program counter */
wire [DATA_WIDTH-1:0] PC_next_e;	                    /* signal from mux to PC register */
/* Decoder */
wire [4 : 0]shamt_wire_e/*synthesis keep*/;				//shamt field (R type)
wire [25: 0]address_j_wire_e/*synthesis keep*/;			//address field for (J type)
/* Register File */
wire [DATA_WIDTH-1 : 0] RD1_e/*synthesis keep*/;
wire [DATA_WIDTH-1 : 0] RD2_e/*synthesis keep*/;
wire [4:0]mux_A3out_e/*synthesis keep*/;
/* Signals for Sign Extend module */
wire [DATA_WIDTH-1:0] sign_extended_out_e/*synthesis keep*/;
wire [DATA_WIDTH-1:0]shifted2/*synthesis keep*/;		//4th input for ALU: shifted by 2 data
/* Adder_branch */
wire [DATA_WIDTH-1:0] Branch_or_not_e;                  /* Branch address */
/********************************************
Signals for ALU unit
*********************************************/
wire zero_e;							//zero flag
wire carry_e;							//carry flag
wire negative_e;						//negative flag
wire [DATA_WIDTH-1:0] SrcA/*synthesis keep*/;			//input 1 of ALU
wire [DATA_WIDTH-1:0] SrcB_e/*synthesis keep*/;			
wire [DATA_WIDTH-1:0] SrcB/*synthesis keep*/;			//input 2 of ALU
wire [DATA_WIDTH-1 : 0]ALU_result_e/*synthesis keep*/;	//Output result of ALU unit
/********************************************
Signals for Shift and concatenate jump address module 
*********************************************/
wire [DATA_WIDTH-1:0] New_JumpAddress_e;

/* Signals for Mux_RtRd */
wire mux_rtrd_ctrl;

/* Flip flop stage for Pipeline */
wire enable_executionFF_stage;
wire flag_bne_e;
wire flag_beq_e;

/*****************************************************************************************************************************
                M E M O R Y    A C C E S S   S I G N A L S 
*****************************************************************************************************************************/
/* Program Counter */
wire [DATA_WIDTH-1:0] PC_next_m;	                    /* signal from mux to PC register */
/* Register File */
wire [DATA_WIDTH-1 : 0] RD1_m/*synthesis keep*/;
wire [DATA_WIDTH-1 : 0] RD2_m/*synthesis keep*/;
wire [4:0]mux_A3out_m/*synthesis keep*/;
/***********************************************
Signals for the Virtual Memory unit 
************************************************/
wire aligment_error_RAM_wire;
wire [DATA_WIDTH-1:0] MIPS_RAM_address/*synthesis keep*/;
/***********************************************
Signals for RAM
************************************************/
wire [DATA_WIDTH-1 : 0]RAM_addr_Translated/*synthesis keep*/;		//Registerd output of RAM q
wire [DATA_WIDTH-1:0]Data_RAM_m/* synthesis keep */;


/***********************************************
Signals for ALU
************************************************/
wire [DATA_WIDTH-1 : 0]ALU_result_m/*synthesis keep*/;	//Output result of ALU unit
wire [DATA_WIDTH-1 : 0]ALUOut/*synthesis keep*/;		//Registerd output of ALU
wire zero_m;							//zero flag
wire carry_m;							//carry flag
wire negative_m;						//negative flag
/* Signals for Shift and concatenate jump address module */
wire [DATA_WIDTH-1:0] New_JumpAddress_m;
/***************************************************************
Signals for Lo and Hi registers
***************************************************************/
wire hi_data/*synthesis keep*/;
wire [DATA_WIDTH-1:0]lo_data_m;
//wire enable_lo_hi/*synthesis keep*/;
/***************************************************************
Signals for Lo-Hi demux
***************************************************************/
wire [DATA_WIDTH-1:0] demux_aluout_0/*synthesis keep*/ ;
wire [DATA_WIDTH-1:0] demux_aluout_0_w/*synthesis keep*/ ;
wire [DATA_WIDTH-1:0] demux_aluout_1/*synthesis keep*/;
/* Demux writeback */
wire [1:0] dataBack_Selector_wire/*synthesis keep*/;
wire [DATA_WIDTH-1 : 0] WD_input/*synthesis keep*/;	//output of demux module to data input of Memory unit
wire [DATA_WIDTH-1:0]reserved_output_wb;

/***************************************************************
Signals for UART
***************************************************************/
wire clr_rx_flag/*synthesis keep*/; //to clear the Rx signal. 0=start new Reception, 1=stop, clear flag after reading the data
wire clr_tx_flag/*synthesis keep*/; //to clear the Tx signal. 0=start new Transmission, 1=no effect
wire [DATA_WIDTH-1:0] uart_tx_input/*synthesis keep*/;
wire [DATA_WIDTH-1:0] UART_Data_m/*synthesis keep*/;
wire Start_uartTx_input_wire/*synthesis keep*/;
wire enable_StoreTxbuff_fromMem/*synthesis keep*/;   
wire enable_StoreTxbuff_output/*synthesis keep*/;  
wire [DATA_WIDTH-1:0] Rx_flag_m;
wire [DATA_WIDTH-1:0] Tx_flag_m;

/***************************************************************
Signals for GPIO
***************************************************************/
wire gpio_enable/*synthesis keep*/;
wire [DATA_WIDTH-1:0]Gpio_data_input/*synthesis keep*/;

/* Flip flop stage for Pipeline */
wire enable_memaccFF_stage;

wire flag_bne_m;
wire flag_beq_m;

/*****************************************************************************************************************************
                W R I T E B A C K   S I G N A L S 
*****************************************************************************************************************************/

wire [DATA_WIDTH-1:0] PC_next_w;	                    /* signal from mux to PC register */
/* UART */
wire flag_R_type_wire;
wire flag_I_type_wire;
/* MUX_Mem_or_Periph_to_MUXWriteData */
wire Data_selector_uart_or_mem;
wire [DATA_WIDTH-1:0] UART_Data_w/*synthesis keep*/;

/* MUX_UART_bitRxorTx */
wire [DATA_WIDTH-1:0] Rx_flag_w;
wire [DATA_WIDTH-1:0] Tx_flag_w;
wire see_uartflag_wire/*synthesis keep*/;
wire [DATA_WIDTH-1:0] peripheral_data;

/* Signals for Register File */
wire [DATA_WIDTH-1:0]datatoWD3/*synthesis keep*/;   	/* Conexion from MUX to select a Data from Memory or from ALU. 0=ALU,1=Memory */
wire [DATA_WIDTH-1:0] Mem_or_Periph_Data;
wire [4:0]mux_A3out_w/*synthesis keep*/;
/***************************************************************
Signals for Lo and Hi registers
***************************************************************/
wire [DATA_WIDTH-1:0]lo_data_w/*synthesis keep*/;
/* RAM */
wire [DATA_WIDTH-1:0]Data_RAM_w/* synthesis keep */;
wire flag_bne_w;
wire flag_beq_w;

/*****************************************************************************************************************************
                C O N T R O L    U N I T 
*****************************************************************************************************************************/
/* Signals for MUX ALU result / Lo Reg */
wire mflo_flag;
wire mflo_flag_e;
/* Program Counter */
wire startPC_wire;                                      /* @Control signal: for bootloader mux*/
wire PC_en_hazard;                                        /* Enable signal of ProgramCounter_Reg */
//wire PC_en_boot=1;
/* RAM */
wire MemWrite_wire;			//@Control signal: Write enable for the memory unit
wire MemWrite_wire_e;			//@Control signal: Write enable for the memory unit
/* Register File */
wire [1:0] RegDst_wire/*synthesis keep*/;					/*@Control signal: for Write reg in Register File */
wire [1:0] RegDst_wire_e/*synthesis keep*/;					/*@Control signal: for Write reg in Register File */
wire [1:0]MemtoReg_wire/*synthesis keep*/;					/*@Control signal: for the Mux from ALU to Register File */
wire [1:0]MemtoReg_wire_e/*synthesis keep*/;					/*@Control signal: for the Mux from ALU to Register File */
wire [1:0]MemtoReg_wire_m/*synthesis keep*/;					/*@Control signal: for the Mux from ALU to Register File */
wire [1:0]MemtoReg_wire_w/*synthesis keep*/;					/*@Control signal: for the Mux from ALU to Register File */
wire RegWrite_wire/*synthesis keep*/;					/*@Control signal: Write enable for register file unit*/
/* ALU */
wire [3:0]ALUControl_wire/*synthesis keep*/; 			//@Control signal: Selects addition operation (010b)
wire [3:0]ALUControl_wire_e/*synthesis keep*/; 			//@Control signal: Selects addition operation (010b)
wire sel_muxALU_srcB/*synthesis keep*/; 			//@Control signal: allows to select the operand for getting srcB number on mux 'Mux4_1_forALU'
wire sel_muxALU_srcB_e/*synthesis keep*/; 			//@Control signal: allows to select the operand for getting srcB number on mux 'Mux4_1_forALU'
/* Signals for Shift and concatenate jump address module */
wire [1:0] flag_Jtype_wire;
wire [1:0] flag_Jtype_wire2;
wire [1:0] flag_Jtype_wire_e;
/* Detector of sw and lw operation */
wire sw_inst_detector/*synthesis keep*/;
wire sw_inst_detector_e/*synthesis keep*/;
wire lw_inst_detector/*synthesis keep*/;
wire lw_inst_detector_e/*synthesis keep*/;
/* Demux aluout */
wire demux_aluout_sel/*synthesis keep*/;
wire demux_aluout_sel_e/*synthesis keep*/;

/* assign enable_fetchFF_stage = 1; */
assign enable_decodeFF_stage= 1;
/* assign enable_decodeFF_stage= PC_en_hazard; */
assign enable_executionFF_stage =1;
assign enable_memaccFF_stage = 1;

/*****************************************************************************************************************************
                F O R W A R D    U N I T 
*****************************************************************************************************************************/
wire [1:0] ForwardA;
wire [1:0] ForwardB;
/*****************************************************************************************************************************
                S T A L L    U N I T 
*****************************************************************************************************************************/
wire stall_ctrl_wire;
wire reset_stall;



//assign PC_En_wire_s = PC_en_boot & PC_en_hazard ;

/* {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

                                        F E T C H    S T A G E

 ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]*/


 //####################   MUX to update PC considering Jump instruction  ########################

mux4to1#(
    .Nbit(DATA_WIDTH)
)MUX_to_updatePC_withJump
(
    //.mux_sel(flag_Jtype_wire),		//@Control signal: mux selector, 0=normal PC,1 =jump address
    .mux_sel(flag_Jtype_wire2),		//@Control signal: mux selector, 0=normal PC,1 =jump address    
    .data1(PC_next_f), 			//comes from MUX_for_PC_source
    .data2(New_JumpAddress_m), 		//New jump address 32 bit long
    .data3(RD1_m),						//for JR instruction
    .data4(Branch_or_not_m),    
    .Data_out(start_PC) 			//Input for ProgramCounter_Reg
);


//#################### Mux for Program Counter source: Bootloader addr or from MUX_to_updatePC_withJump #################

mux2to1#(
    .Nbit(DATA_WIDTH)
)MUX_Boot_startAddr
(
    .mux_sel(startPC_wire),				//@Control signal: Instruction or Data selection. 1=from ALU    
    .data1(32'h400000), 				//0=Comes from bootloader    
    .data2(start_PC), 					//1=comes from mux to update PC w jump 
    .Data_out(PC_source) 	
);

//#################### Register for Program Counter #################
Register#(
    .WORD_LENGTH(DATA_WIDTH)
)ProgramCounter_Reg
(		
    .clk(clk),
    .reset(reset),
    //.enable(PC_en_boot),
    .enable( PC_en_hazard ),	        
    .Data_Input(PC_source), 	//This comes from the ALU Result after MUX_for_PC_source
    .Data_Output(PC_current_f)	//output Program counter update
);

//####################     ROM Address translator unit   #######################
VirtualMemory_unit #(
    .ADDR_WIDTH(DATA_WIDTH)
)VirtualAddress_ROM
(
    /* input */
    .address(PC_current_f),
    /* output */
    .translated_addr(translated_addr_wire),
    .MIPS_address(MIPS_address),
    .aligment_error(aligment_error_wire)
);

// ################ ROM Memory

Memory_ROM#(
    .DATA_WIDTH(DATA_WIDTH), 		//data length   
	.ADDR_WIDTH(8)			//bits to address the elements
)ROM(
    .addr(translated_addr_wire[7:0]),	//Address for rom instruction mem. Program counter
	//output
	.q(Instruction_fetched_f)
);

//####################     Adder_nextPC unit   #######################
Adder #(
    .DATA_WIDTH(DATA_WIDTH)
)Adder_nextPC(
    .A(PC_current_f),
    .B(32'd4),
    .C(PC_next_f)
);

//####################     Pipeline flip flops   #######################

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Fetch_Pipeline1
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_fetchFF_stage),
    .Data_Input(PC_current_f), 
    .Data_Output(PC_current_d) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Fetch_Pipeline2
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_fetchFF_stage),
    .Data_Input(Instruction_fetched_f), 
    .Data_Output(Instruction_fetched_d) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Fetch_Pipeline3
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_fetchFF_stage),
    .Data_Input(PC_next_f), 
    .Data_Output(PC_next_d) 
);

/* {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

                                        D E C O D E   S T A G E

 ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]*/

//####################     Control unit   #######################
ControlUnit CtrlUnit(
    /* Inputs */
    .clk(clk), 						//clk signal
    .reset(reset), 					//async s ignal to reset 	
    .sw_flag(sw_inst_detector),
    /* Outputs */
    .Start_PC(startPC_wire),
    .RegWrite(RegWrite_wire)
);


Hazard_Detection_Unit hazard_unit
(
    /* Inputs */
    .lw_detected(lw_inst_detector_e),
    .ID_EX_rt(mux_A3out_e),
    .IF_ID_rs(rs_wire),
    .IF_ID_rt(rt_wire),
    /* Outputs */
    .PC_En(PC_en_hazard),
    .IFID_ctrl(enable_fetchFF_stage),
    .stall_ctrl(stall_ctrl_wire)
);


//####################     Address preparation   #######################
address_preparation add_prep
(	
    /* Input */
    .Mmemory_output(Instruction_fetched_d),	//rom fetched instruction content
    /* Output */
    .opcode(opcode_wire),  			//Opcode  value
    .funct(funct_wire),    				//function value
    .rs(rs_wire),		 				//source 1	(R-I type)		
    .rt(rt_wire),		 				//source 2	(R-I type)		
    .rd(rd_wire),						//Destination: 15:11 bit (R type)		
    .shamt(shamt_wire_d),					//shamt field (R type)	
    .immediate_data(immediate_data_wire),//immediate field (I type)	
    .address_j(address_j_wire_d)			//address field for (J type)	
);

decode_instruction decoder_module
(
    /* Inputs */
	.opcode_reg(opcode_wire),
	.funct_reg(funct_wire),
    .addr_input(translated_addr_wire[7:0]),
    .zero(zero_e),
    /* Outputs */
	.RegDst_reg(RegDst_wire), //1: R type, 0: I type
	.ALUControl(ALUControl_wire),
	.flag_sw(sw_inst_detector),
	.flag_lw(lw_inst_detector),
    .flag_R_type(flag_R_type_wire), 
    .flag_I_type(flag_I_type_wire), 
    .flag_J_type(flag_Jtype_wire),
	.ALUSrcBselector(sel_muxALU_srcB),    //allows to select the operand for getting srcB number
    .mult_operation(demux_aluout_sel),
    .mflo_flag(mflo_flag),    
    .MemtoReg(MemtoReg_wire),
    .see_uartflag_ind(see_uartflag_wire),    
	.MemWrite(MemWrite_wire),
	/* .RegWrite(RegWrite_wire), */
	/* .PC_En(PC_en_hazard), */
    .flag_bne(flag_bne),
    .flag_beq(flag_beq)
);

//####################  Sign extend Module  ###############
SignExtend_module signExt
(
    .immediate(immediate_data_wire),
    .extended_sign_out(sign_extended_out_d)
);

//###############   Mux for Target register, for Register File    ##################

mux4to1#(
    .Nbit(3'd5)
)mux_A3_destination
(
    .mux_sel(RegDst_wire),		/* 1= R type (rd), 0= I type (rt) */
    .data1(rt_wire),
    .data2(rd_wire),
    .data3(5'd31),			/* For writing to $ra (31) register */
    .data4(5'd0),           /* @TODO: for future use */
    .Data_out(mux_A3out)
);

////####################  Register File  #######################
Register_File #(
    .WORD_LENGTH(DATA_WIDTH),	
    .NBITS(5)
)RegisterFile_Unit
(
    /* Inputs */
    .clk(clk),
    .reset(reset),
    .Read_Reg1(rs_wire),		//It'll always be 'Rs'-> 25:21. 
    .Read_Reg2(rt_wire), 			//It'll always be 'Rt'-> 20:16
    .Write_Reg(mux_A3out_w),		//(A3)Register destination; bits I->20:16 ; R->15:11
    .Write_Data(datatoWD3),  	//(WD3) data to write 
    .Write(RegWrite_wire),		//@Control Signal:(WE3) enable signal
    /* Outputs */
    .Read_Data1(RD1_d),
    .Read_Data2(RD2_d)	
);


//####################     Pipeline flip flops   #######################



//assign reset_stall = reset & stall_ctrl_wire;



Register#(
    .WORD_LENGTH(26)
)Decode_Pipeline1
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(address_j_wire_d), 
    .Data_Output(address_j_wire_e) 
);


Register#(
    .WORD_LENGTH(4)
)Decode_Pipeline2
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(PC_current_d[31:28]), 
    .Data_Output(PC_current_e) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Decode_Pipeline3
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(sign_extended_out_d), 
    .Data_Output(sign_extended_out_e) 
);

Register#(
    .WORD_LENGTH(5)
)Decode_Pipeline4
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(shamt_wire_d), 
    .Data_Output(shamt_wire_e) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Decode_Pipeline5
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(RD1_d), 
    .Data_Output(RD1_e) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Decode_Pipeline6
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(RD2_d), 
    .Data_Output(RD2_e) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Decode_Pipeline7
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(PC_next_d), 
    .Data_Output(PC_next_e) 
);
/* FF for decode_instruction signals */

Register#(
    .WORD_LENGTH(2)
)Decode_Pipeline_RegDst_reg
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(RegDst_wire), 
    .Data_Output(RegDst_wire_e) 
);

Register#(
    .WORD_LENGTH(4)
)Decode_Pipeline_ALUControl
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(ALUControl_wire), 
    .Data_Output(ALUControl_wire_e) 
);

Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_flag_sw
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(sw_inst_detector), 
    .Data_Output(sw_inst_detector_e) 
);

Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_flag_lw
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(lw_inst_detector), 
    .Data_Output(lw_inst_detector_e) 
);

/* Register#(
    .WORD_LENGTH(2)
)Decode_Pipeline_flag_J_type
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(flag_Jtype_wire), 
    .Data_Output(flag_Jtype_wire_e) 
); */

Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_ALUSrcBselector
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(sel_muxALU_srcB), 
    .Data_Output(sel_muxALU_srcB_e) 
);


Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_mult_operation
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(demux_aluout_sel), 
    .Data_Output(demux_aluout_sel_e) 
);

Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_mflo_flag
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(mflo_flag), 
    .Data_Output(mflo_flag_e) 
);

Register#(
    .WORD_LENGTH(2)
)Decode_Pipeline_MemtoReg
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(MemtoReg_wire), 
    .Data_Output(MemtoReg_wire_e) 
);


Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_MemWrite
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(MemWrite_wire), 
    .Data_Output(MemWrite_wire_e) 
);

Register#(
    .WORD_LENGTH(5)
)Decode_Pipeline_Mux_A3out
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(mux_A3out), 
    .Data_Output(mux_A3out_e) 
);

Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_flag_bne
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(flag_bne), 
    .Data_Output(flag_bne_e) 
);

Register#(
    .WORD_LENGTH(1)
)Decode_Pipeline_flag_beq
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(flag_beq), 
    .Data_Output(flag_beq_e) 
);




Register#(
    .WORD_LENGTH(5)
)Decode_Pipeline_rs
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(rs_wire), 
    .Data_Output(rs_wire_e) 
);

Register#(
    .WORD_LENGTH(5)
)Decode_Pipeline_rt
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(rt_wire), 
    .Data_Output(rt_wire_e) 
);

Register#(
    .WORD_LENGTH(5)
)Decode_Pipeline_rd
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_decodeFF_stage),
    .Data_Input(rd_wire), 
    .Data_Output(rd_wire_e) 
);



 /* {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

                                        E X E C U T I O N    S T A G E

 ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]*/

assign DataRx_out = UART_Data_m[7:0]/*synthesis keep*/;
assign Rx_flag = Rx_flag_m[0];


//####################   Shift and concatenate jump address module ####################
Shift_Concatenate shiftConcat_mod
(
    .J_address(address_j_wire_e ), /* shifted <<2 */
    .PC_add(PC_current_e),
    .new_jumpAddr(New_JumpAddress_e)
);


//####################	 Mux RegFile to Alu             ######################
mux2to1#(
    .Nbit(DATA_WIDTH)
)mux_RegFile_RD2_to_ALU
(
    //.mux_sel(sel_muxALU_srcB),		/* 1= R type (rd), 0= I type (rt) */
    .mux_sel(sel_muxALU_srcB_e),		/* 1= R type (rd), 0= I type (rt) */
    .data1(RD2_e),
    .data2(sign_extended_out_e),
    .Data_out(SrcB_e)
);

//####################	 Shifted <<2 to Mux SrcB             ######################
assign shifted2[1:0]=2'd0;
assign shifted2[DATA_WIDTH-1:2] = sign_extended_out_e[DATA_WIDTH-1-2:0];		/* immediate value x 4 */



//###############   Mux for Forward A to ALU    ##################

mux4to1#(
    .Nbit(DATA_WIDTH)
)Mux_Fw_A
(
    .mux_sel(ForwardA),		/* 1= R type (rd), 0= I type (rt) */
    .data1(RD1_e),
    .data2(datatoWD3),
    .data3(ALU_result_m),			/* For writing to $ra (31) register */
    .data4(32'd0),           /* @TODO: for future use */
    .Data_out(SrcA)
);

mux4to1#(
    .Nbit(DATA_WIDTH)
)Mux_Fw_B
(
    .mux_sel(ForwardB),		/* 1= R type (rd), 0= I type (rt) */
    .data1(SrcB_e),
    .data2(datatoWD3),
    .data3(ALU_result_m),			/* For writing to $ra (31) register */
    .data4(32'd0),           /* @TODO: for future use */
    .Data_out(SrcB)
);

//####################        ALU   #######################
ALU #(
    .WORD_LENGTH(DATA_WIDTH)
)alu_unit
(
    /* inputs */	
    .dataA(SrcA),					//From MUX_to_updateSrcA 	, input 1
    .dataB(SrcB),					//From Mux 4 to 1		, input 2 
    //.control(ALUControl_wire),		//@Control signal
    .control(ALUControl_wire_e),		//@Control signal
    .shmt(shamt_wire_e),				//shamt field to do shift operations
    /* outputs */
    .carry(carry_e),					//Carry signal
    .zero(zero_e),					//Zero signal
    .negative(negative_e),			//Negative signal
    .dataC(ALU_result_e) 				//Result	
);

//####################     Adder_branch unit   #######################
Adder #(
    .DATA_WIDTH(DATA_WIDTH)
)Adder_branch(
    .A(shifted2),       
    .B(PC_next_e),
    .C(Branch_or_not_e)
);

Forward_Unit Fw_Unit (
    .rt_current(rt_wire_e),
    .rs_current(rs_wire_e),
    .RegDest_Dfw(mux_A3out_m),
    .RegDest_Mfw(mux_A3out_w),
    .ForwardA_out(ForwardA),
    .ForwardB_out(ForwardB)
);


//####################     Pipeline flip flops   #######################

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Execution_Pipeline_RD1
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(RD1_e), 
    .Data_Output(RD1_m) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Execution_Pipeline_newJmp
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(New_JumpAddress_e), 
    .Data_Output(New_JumpAddress_m) 
);


Register#(
    .WORD_LENGTH(1)
)Execution_Pipeline_Zero
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(zero_e), 
    .Data_Output(zero_m) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Execution_Pipeline_Srcb
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(SrcB), 
    .Data_Output(RD2_m) 
);


Register#(
    .WORD_LENGTH(1)
)Execution_Pipeline_carry
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(carry_e), 
    .Data_Output(carry_m) 
);


Register#(
    .WORD_LENGTH(1)
)Execution_Pipeline_neg
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(negative_e), 
    .Data_Output(negative_m) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Execution_Pipeline_ALURes
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(ALU_result_e), 
    .Data_Output(ALU_result_m) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Execution_Pipeline_branch
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(Branch_or_not_e), 
    .Data_Output(Branch_or_not_m) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Execution_Pipeline_PCnext
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(PC_next_e), 
    .Data_Output(PC_next_m) 
);

Register#(
    .WORD_LENGTH(2)
)Execution_Pipeline_MemtoReg
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(MemtoReg_wire_e), 
    .Data_Output(MemtoReg_wire_m) 
);

Register#(
    .WORD_LENGTH(5)
)Execution_Pipeline_Mux_A3out
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(mux_A3out_e), 
    .Data_Output(mux_A3out_m) 
);


Register#(
    .WORD_LENGTH(1)
)Execution_Pipeline_flag_bne
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(flag_bne_e), 
    .Data_Output(flag_bne_m) 
);

Register#(
    .WORD_LENGTH(1)
)Execution_Pipeline_flag_beq
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_executionFF_stage),
    .Data_Input(flag_beq_e), 
    .Data_Output(flag_beq_m) 
);


assign flag_Jtype_wire2 = (flag_bne_m ==1'b1 && zero_m == 1'b0)|| (flag_beq_m ==1'b1 && zero_m == 1'b1) ? (2'd3) : (2'd0) ; 



 /* {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

                                        M E M O R Y    A C C E S S   S T A G E

 ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]*/

//####################	 Mux Alu/Lo Reg             ######################
mux2to1#(
    .Nbit(DATA_WIDTH)
)mux_ALU_Lo_reg
(
    .mux_sel(mflo_flag),		/* 1= R type (rd), 0= I type (rt) */
    .data1(ALU_result_m),
    .data2(lo_data_w),
    .Data_out(ALUOut)
);

//####################   Demux to pass the Aluout result to RegFile or Lo-Hi registers ######
Demux1to2 #(
    .DATA_LENGTH(DATA_WIDTH)
)demux_aluout(
    // Input Ports
    .Demux_Input(ALUOut),
    .Selector(demux_aluout_sel),
    //output Ports
    .Dataout0(demux_aluout_0),
    .Dataout1(demux_aluout_1)
);


//####################   Lo Register for mult operation ####################
Register#(
    .WORD_LENGTH(DATA_WIDTH)
)Lo_Reg
(		
    .clk(clk),
    .reset(reset),
    .enable(demux_aluout_sel),
    .Data_Input(demux_aluout_1), //This comes from 
    .Data_Output(lo_data_m)//output 
);


//####################     DEMUX for writeback operation   #######################

Demux1to4 #(
    .DATA_LENGTH(DATA_WIDTH)
)demux_writeback(
	// Input Ports
	.Demux_Input(RD2_m),
	.Selector(dataBack_Selector_wire),
    //output Ports
    .Dataout0(WD_input),
    .Dataout1(uart_tx_input),
    .Dataout2(Gpio_data_input),
    .Dataout3(reserved_output_wb)
);

//####################     RAM Address translator unit   #######################
VirtualAddress_RAM #(
    .ADDR_WIDTH(DATA_WIDTH)
)VirtualRAM_Mem
(
    /* inputs */
    .address(demux_aluout_0),	
    .swdetect(sw_inst_detector),
    /* outputs */
    .translated_addr(RAM_addr_Translated),
    .MIPS_address(MIPS_RAM_address),
    .aligment_error(aligment_error_RAM_wire),
    .dataBack_Selector_out(dataBack_Selector_wire ),
    .Data_selector_periph_or_mem(Data_selector_uart_or_mem),
    .clr_rx_flag(clr_rx_flag),
    .clr_tx_flag(clr_tx_flag),
    .Start_uart_tx(Start_uartTx_input_wire ),       /* Output from memory controller */
    .enable_StoreTxbuff(enable_StoreTxbuff_fromMem)
);


//####################     RAM  unit   #######################

Memory_RAM #(
    .DATA_WIDTH(DATA_WIDTH), 	//data length
	.ADDR_WIDTH(8)			    //bits to add
)mem_RAM(

    .addr(RAM_addr_Translated[7:0]),	    //Address for ram
	.wdata(WD_input),               //Write Data for RAM data memory
    .we(MemWrite_wire),				//Write enable signal
	.clk(clk), 							
	//output
	.q(Data_RAM_m)
);

//####################     UART controller unit   #######################

UART_controller #(
    .DATA_WIDTH(DATA_WIDTH),
    .UART_Nbit(UART_Nbit),
    .baudrate(baudrate),
    .clk_freq(clk_freq)
)uart_ctrlUnit
(
    .SerialDataIn(SerialDataIn), //it's the input data port 
    .clk(clk), 					/* clk signal */
    .reset(reset), 				/* async signal to reset */	
    .clr_rx_flag(clr_rx_flag),
    .clr_tx_flag(clr_tx_flag),
    .uart_tx(uart_tx_input),        /* Data to transmit */
    .Start_Tx( Start_uartTx_input_wire  ),            /* Input */
    .enable_StoreTxbuff(  enable_StoreTxbuff_output   ),
    /* outputs */
    .UART_data(UART_Data_m),
    .SerialDataOut(SerialDataOut),
    .Rx_flag_out(Rx_flag_m),
    .Tx_flag_out(Tx_flag_m)
);

assign enable_StoreTxbuff_output = sw_inst_detector & enable_StoreTxbuff_fromMem;

//####################     GPIO controller unit   #######################
GPIO_controller #(
    .DATA_WIDTH(8),
    .ADDR_WIDTH(32)
)GPIO
(
    .addr_ram(demux_aluout_0),	
    .wdata( Gpio_data_input[7:0] ),
    .clk(clk),
    .reset(reset),
    .enable_sw(sw_inst_detector),
    .gpio_data_out(gpio_data_out)
);


//####################     Pipeline flip flops   #######################

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline1
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(Data_RAM_m), 
    .Data_Output(Data_RAM_w) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline2
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(UART_Data_m), 
    .Data_Output(UART_Data_w) 
);


Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline3
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(Rx_flag_m), 
    .Data_Output(Rx_flag_w) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline4
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(Tx_flag_m), 
    .Data_Output(Tx_flag_w) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline5
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(PC_next_m), 
    .Data_Output(PC_next_w) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline6
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(lo_data_m), 
    .Data_Output(lo_data_w) 
);

Register#(
    .WORD_LENGTH(DATA_WIDTH)
)MemAccess_Pipeline7_demux_aluout_0
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(demux_aluout_0), 
    .Data_Output(demux_aluout_0_w) 
);


Register#(
    .WORD_LENGTH(2)
)MemAccess_Pipeline_MemtoReg
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(MemtoReg_wire_m), 
    .Data_Output(MemtoReg_wire_w) 
);


Register#(
    .WORD_LENGTH(5)
)MemAccess_Pipeline_Mux_A3out
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(mux_A3out_m), 
    .Data_Output(mux_A3out_w) 
);


Register#(
    .WORD_LENGTH(1)
)MemAccess_Pipeline_flag_bne
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(flag_bne_m), 
    .Data_Output(flag_bne_w) 
);

Register#(
    .WORD_LENGTH(1)
)MemAccess_Pipeline_flag_beq
(		
    .clk(!clk),
    .reset(reset),
    .enable(enable_memaccFF_stage),
    .Data_Input(flag_beq_m), 
    .Data_Output(flag_beq_w) 
);


 /* {{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{{

                                        W R I T E B A C K   S T A G E

 ]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]]*/

//####################     Mux to decide which flag from uart will be read #######################

mux2to1#(.Nbit(DATA_WIDTH))
MUX_UART_bitRxorTx
(
    .mux_sel( see_uartflag_wire ),
    .data1(Rx_flag_w), 		
    .data2(Tx_flag_w), 		
    .Data_out(peripheral_data) 	
);

//###############   Mux for Write data, input 2 of 4    ##################
mux2to1#(.Nbit(DATA_WIDTH))
MUX_Mem_or_Periph_to_MUXWriteData
(
    .mux_sel(Data_selector_uart_or_mem),				//@Control signal: Instruction or Data selection. 1=from ALU
    .data1(Data_RAM_w), 				//0=Comes from 'PC_Reg'	    
    .data2(UART_Data_w), 					//1=From ALUOut signal 
    .Data_out(  Mem_or_Periph_Data ) 	//this have the Address for Memory input
);


//##############  Mux from Memory to Register File ############

mux4to1 #(
    .Nbit(DATA_WIDTH)
)MUX_to_WriteData_RegFile
(
    //.mux_sel(MemtoReg_wire),			//@Control signal:  0=ALU , 1=Memory    
    .mux_sel(MemtoReg_wire_w),			//@Control signal:  0=ALU , 1=Memory    
    .data1(demux_aluout_0_w),		 			//From ALU result	
    .data2( Mem_or_Periph_Data ),				//From Memory: Read data
    //.data3(PC_current),             //for JAL instruction, write to Reg 31 ($ra)
    .data3(PC_next_w),             //for JAL instruction, write to Reg 31 ($ra)
    .data4( peripheral_data ),        //Data from peripherals such as UART
    .Data_out(datatoWD3) 				//This have the Address for Memory input
);


endmodule



