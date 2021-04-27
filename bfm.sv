interface bfm ;
     import env_pkg::*;
  bit [31:0] operand1 ;
  bit [31:0] operand2 ;
 // bit        E        ;
  bit [31:0] Result   ;
  bit [3:0]  Flags    ;
  
  task send_op (bit[31:0] op1 , bit[31:0] op2);
    //E = 1'b1;
    operand1 = op1;
    operand2 = op2;
    #500;
    //E = 1'b0;
  endtask
  
  command_monitor command_monitor_h;
  result_monitor  result_monitor_h;
  
  task write_to_monitor ();
    command_monitor_h.write_to_monitor(operand1,operand2);
    result_monitor_h.write_to_monitor(Result,Flags);
  endtask
  
endinterface