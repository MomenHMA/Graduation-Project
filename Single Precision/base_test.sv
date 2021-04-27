
class base_test extends uvm_test;

  
  env       env_h       ; 
  sequencer sequencer_h ; 
  
  function new (string name , uvm_component parent ) ;
    super.new (name , parent) ;
  endfunction
  
  function void build_phase (uvm_phase phase);
    env_h       = new("env_h" , this)       ;
  endfunction 
  
  function void end_of_elaboration_phase (uvm_phase phase) ; 
    sequencer_h = env_h.sequencer_h ; 
  endfunction
  
endclass
    
    
