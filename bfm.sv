interface bfm;
   import env_pkg::*;
  bit [31:0] operand1;
  bit [31:0] operand2;
  bit        E;
  bit [31:0] Result;
  bit [3:0]  Flags;
  
  task send_op (bit [31:0] a_rep , bit [31:0] b_rep);
    E = 1'b1;
    operand1 = a_rep;
    operand2 = b_rep;
    #500;
    //E = 1'b0;
  endtask
  
  command_monitor command_monitor_h;
  result_monitor  result_monitor_h;
  task write_to_monitor (real a_dec , real b_dec);
    //$display("aaa");
    command_monitor_h.write_to_monitor(a_dec,b_dec);
    
    //#1000;
    result_monitor_h.write_to_monitor(Result,Flags);
  endtask
  
endinterface
    
    