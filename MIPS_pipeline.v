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

wire [3:0] PC_current_d/*synthesis keep*/;	/* Current Program counter */
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

/*****************************************************************************************************************************
                E X E C U T I O N   S I G N A L S 
*****************************************************************************************************************************/
/* Program counter */
wire [3:0] PC_current_e/*synthesis keep*/;	/* Current Program counter */
wire [DATA_WIDTH-1:0] PC_next_e;	                    /* signal from mux to PC register */
/* Decoder */
wire [4 : 0]shamt_wire_e/*synthesis keep*/;				//shamt field (R type)
wire [25: 0]address_j_wire_e/*synthesis keep*/;			//address field for (J type)
/* Register File */
wire [DATA_WIDTH-1 : 0] RD1_e/*synthesis keep*/;
wire [DATA_WIDTH-1 : 0] RD2_e/*synthesis keep*/;

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
wire [DATA_WIDTH-1:0] SrcB/*synthesis keep*/;			//input 1 of ALU
wire [DATA_WIDTH-1 : 0]ALU_result_e/*synthesis keep*/;	//Output result of ALU unit
/********************************************
Signals for Shift and concatenate jump address module 
*********************************************/
wire [DATA_WIDTH-1:0] New_JumpAddress_e;
/* Flip flop stage for Pipeline */
wire enable_executionFF_stage;

/*****************************************************************************************************************************
                M E M O R Y    A C C E S S   S I G N A L S 
*****************************************************************************************************************************/
/* Program Counter */
wire [DATA_WIDTH-1:0] PC_next_m;	                    /* signal from mux to PC register */
/* Register File */
wire [DATA_WIDTH-1 : 0] RD1_m/*synthesis keep*/;
wire [DATA_WIDTH-1 : 0] RD2_m/*synthesis keep*/;
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
wire [DATA_WIDTH-1:0]lo_data_m/*synthesis keep*/;
wire hi_data/*synthesis keep*/;
//wire enable_lo_hi/*synthesis keep*/;
/***************************************************************
Signals for Lo-Hi demux
***************************************************************/
wire [DATA_WIDTH-1:0] demux_aluout_0/*synthesis keep*/ ;
wire [DATA_WIDTH-1:0] demux_aluout_1/*synthesis keep*/;
wire demux_aluout_sel/*synthesis keep*/;
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
wire enable_fetchFF_stage;

/*****************************************************************************************************************************
                W R I T E B A C K   S I G N A L S 
*****************************************************************************************************************************/


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
/***************************************************************
Signals for Lo and Hi registers
***************************************************************/
wire [DATA_WIDTH-1:0]lo_data_w/*synthesis keep*/;
/* RAM */
wire [DATA_WIDTH-1:0]Data_RAM_w/* synthesis keep */;

/*****************************************************************************************************************************
                C O N T R O L    U N I T 
*****************************************************************************************************************************/
/* Signals for MUX ALU result / Lo Reg */
wire mflo_flag;
/* Program Counter */
wire startPC_wire;                                      /* @Control signal: for bootloader mux*/
wire PC_En_wire;                                        /* Enable signal of ProgramCounter_Reg */
/* RAM */
wire MemWrite_wire;			//@Control signal: Write enable for the memory unit
/* Register File */
wire [1:0] RegDst_wire/*synthesis keep*/;					/*@Control signal: for Write reg in Register File */
wire [1:0]MemtoReg_wire/*synthesis keep*/;					/*@Control signal: for the Mux from ALU to Register File */
wire RegWrite_wire/*synthesis keep*/;					/*@Control signal: Write enable for register file unit*/
/* ALU */
wire [3:0]ALUControl_wire/*synthesis keep*/; 			//@Control signal: Selects addition operation (010b)
wire sel_muxALU_srcB/*synthesis keep*/; 			//@Control signal: allows to select the operand for getting srcB number on mux 'Mux4_1_forALU'
/* Signals for Shift and concatenate jump address module */
wire [1:0] flag_Jtype_wire;
/* Detector of sw and lw operation */
wire sw_inst_detector/*synthesis keep*/;
wire lw_inst_detector/*synthesis keep*/;

