package env_pkg ; 

import uvm_pkg ::* ; 


`include"uvm_macros.svh"
`include"sequence_item.sv"
typedef uvm_sequencer #(sequence_item) sequencer ; 
`include"random_sequence.sv"
`include"driver.sv"
`include"result_transaction.sv"
`include"result_monitor.sv"
`include"command_monitor.sv"
`include"scoreboard.sv"
`include"env.sv"
`include"base_test.sv"
`include"random_test.sv"

endpackage 
  