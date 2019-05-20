module Hazard_Detection_Unit(
    input lw_detected,          /* Is the instruction a LW? */
    input [4:0] ID_EX_rt,       /* destination of LW instruction */
    input [4:0] IF_ID_rs,       /* first possible operand */
    input [4:0] IF_ID_rt,       /* second possible operand */
    input sw_detected,
    output PC_En,               /* to control PC counter update */
    output IFID_ctrl,           /* to control IF/ID registers write enable */
    output stall_ctrl           /* to contro Stall Mux  */
);


/* PC_En = 0 if stall;  otherwise = 1 */
/* assign PC_En = ( ((lw_detected==1'b1)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1)&&(ID_EX_rt==IF_ID_rt)) ) ? 1'd0 : 1'd1  ; */
assign PC_En = ( ((lw_detected==1'b1&&sw_detected==1'b0)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1&&sw_detected==1'b0)&&(ID_EX_rt==IF_ID_rt)) ) ? 1'd0 : 
     ( ((lw_detected==1'b1&& sw_detected==1'b1)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1&&sw_detected==1'b1)&&(ID_EX_rt==IF_ID_rt)) ) ?1'd1 : 1'd1  ;
/* IFID_ctrl = 0 if stall;  otherwise = 1 */
assign IFID_ctrl = ( ((lw_detected==1'b1&&sw_detected==1'b0)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1&&sw_detected==1'b0)&&(ID_EX_rt==IF_ID_rt)) ) ? 1'd0 : 
     ( ((lw_detected==1'b1&& sw_detected==1'b1)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1&&sw_detected==1'b1)&&(ID_EX_rt==IF_ID_rt)) ) ?1'd1 : 1'd1  ;

/* stall_ctrl=1 if stall */
assign stall_ctrl = ( ((lw_detected==1'b1&&sw_detected==1'b0)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1&&sw_detected==1'b0)&&(ID_EX_rt==IF_ID_rt)) ) ? 1'd0 : 
    ( ((lw_detected==1'b1&& sw_detected==1'b1)&&(ID_EX_rt==IF_ID_rs)) || ((lw_detected==1'b1&&sw_detected==1'b1)&&(ID_EX_rt==IF_ID_rt)) ) ?1'd1 : 1'd1  ;


endmodule