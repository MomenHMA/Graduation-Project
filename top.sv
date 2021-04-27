`include "env_pkg.sv"
`include "bfm.sv"

module top;
  
   import uvm_pkg::*;
  `include "uvm_macros.svh"
   import env_pkg::*;
  
  bfm  bfm();
  
  Top_Module DUT (.operand1(bfm.operand1), .operand2(bfm.operand2), 
                     .RESULT(bfm.Result), 
                     .flags(bfm.Flags));
  
  

  initial begin
    
    uvm_config_db #(virtual bfm)::set(null, "*", "bfm", bfm);
    run_test("random_test");  
   

  end  
    
    
endmodule
