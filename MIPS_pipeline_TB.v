/*Testing MIPS_pipeline.v:

    Simulation with modelsim:
    vsim -voptargs=+acc=npr
*/
module MIPS_pipeline_TB;

    localparam DATA_WIDTH = 32;
    localparam ADDR_WIDTH = 8;
    localparam MAXIMUM_VALUE = 4'd6;
    localparam Nbit =8;

    localparam clk_freq =50;
    localparam baudrate= 5;
	reg clk=0; 				        /* clk signal */
	reg reset=0; 			        /* async signal to reset */
    reg enable=0;                   /* enable signal*/

    wire [7:0]leds;            /* output leds */    
    //UART     
    reg SerialDataIn; //it's the input data port 
    reg clr_rx_flag; //to clear the Rx signal
    wire [Nbit-1:0] DataRx; //Port where Rx information is available
    wire Rx_flag; //indicates a data was received 
    wire SerialDataOut;




MIPS_pipeline#(
    .DATA_WIDTH(DATA_WIDTH),/* length of data */
    .ADDR_WIDTH(ADDR_WIDTH),/* bits to address the elements */
    .UART_Nbit(8),
    .baudrate(baudrate),
    .clk_freq(clk_freq)
)testing_mips
(
	.clk(clk), 				        /* clk signal */
	.reset(reset), 			        /* async signal to reset */        
    //###### UART 
    .SerialDataIn(SerialDataIn),    
    .Rx_flag(Rx_flag),
    .DataRx_out(DataRx),
    .SerialDataOut(SerialDataOut),
    .gpio_data_out(leds)    
);


initial begin
    forever #(clk_freq/2) clk=!clk;
end


initial begin 
    /* Beginning of simulation */
    #0  reset=1'b0;
    #0  enable =1'b0;
    SerialDataIn=1;
	
    #15 reset =1'b1;
    #0  enable =1'b1;
        
end 


endmodule