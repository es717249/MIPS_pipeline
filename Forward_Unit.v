module Forward_Unit(
    input [4:0] rt_current,           /* ID/EX.RegisterRt */
    input [4:0] rs_current,           /* ID/EX.RegisterRs */
    input [4:0] RegDest_Dfw,            /* EX/MEM.RegisterRd -For data forwarding hazard */
    input [4:0] RegDest_Mfw,            /* MEM/WB.RegisterRd -For memory forwarding hazard */
    input sw_detected,
    output [1:0] ForwardA_out,
    output [1:0] ForwardB_out
);

/* adding (RegDest_Mfw!=0) at the begginig to handle I type instructions whose rs field is always 0 */
assign ForwardA_out = ((RegDest_Mfw!=0) &&(RegDest_Dfw!=0) && (RegDest_Dfw == rs_current) ) ? 2'd2 : ( (RegDest_Mfw!=0) &&(RegDest_Dfw!=rs_current )&& (RegDest_Mfw == rs_current) ) ? 2'd1 :2'd0;

assign ForwardB_out = ((sw_detected!=1) && (RegDest_Dfw!=0) && (RegDest_Dfw == rt_current) ) ? 2'd2 : ( (sw_detected!=1) && (RegDest_Mfw!=0) && (RegDest_Dfw!=rt_current ) && (RegDest_Mfw == rt_current) ) ? 2'd1 :2'd0;
//((sw_detected==1) && (RegDest_Dfw!=0) && (RegDest_Dfw == rt_current) ) ? 2'd3 : ( (sw_detected==1) && (RegDest_Mfw!=0) && (RegDest_Dfw!=rt_current ) && (RegDest_Mfw == rt_current) ) ? 3: 2'd0;

endmodule