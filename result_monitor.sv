class result_monitor extends uvm_component ;
  `uvm_component_utils (result_monitor);
  
  virtual bfm bfm ;
  uvm_analysis_port #(result_transaction) ap;
  
  function new (string name , uvm_component parent);
    super.new (name,parent);
  endfunction
  
  function void build_phase(uvm_phase phase);
    if(!uvm_config_db #(virtual bfm)::get(null,"*","bfm",bfm) )
      `uvm_fatal("result_monitor","Failed to get BFM");
    ap = new("ap",this);
  endfunction
  
  function void connect_phase (uvm_phase phase);
    bfm.result_monitor_h = this ;
  endfunction
  
  function void write_to_monitor (bit[31:0] result , bit[3:0] flags);
    result_transaction result_t ;
    result_t = new("result_t");
    result_t.result = result; 
    result_t.flags  = flags ;
    ap.write(result_t);
  endfunction
  
endclass
  
  
               
    