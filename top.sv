
`include"env_pkg.sv" 
`include "bfm.sv"

module top ();
  import uvm_pkg::*;
   import env_pkg::*;
  `include "uvm_macros.svh"
  
  bfm bfm() ;

  single_percision_adder DUT(.operand1(bfm.operand1) , .operand2(bfm.operand2) ,
                             .Result(bfm.Result) , .flags(bfm.Flags)) ;
  
  initial begin 
    uvm_config_db#(virtual bfm) :: set(null,"*","bfm",bfm) ;
    run_test("random_test");
  end
endmodule
