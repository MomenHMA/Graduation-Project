class command_monitor extends uvm_component;
  `uvm_component_utils (command_monitor);
  
  virtual bfm bfm ; 
  uvm_analysis_port #(sequence_item) ap ;
  
  function new (string name , uvm_component parent);
    super.new(name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    if(!uvm_config_db #(virtual bfm)::get(null,"*","bfm",bfm) )
      `uvm_fatal("COMMAND MONITOR", "Failed to get BFM");
    
    ap = new("ap",this) ;
  endfunction
  
  function void connect_phase(uvm_phase phase);
    bfm.command_monitor_h = this ; 
  endfunction
  
  function void write_to_monitor (bit[31:0] operand1 , bit[31:0] operand2);
    sequence_item cmd;
    cmd = new("cmd");
    cmd.sign_1     = operand1 [31]    ;
    cmd.exp_1      = operand1 [30:23] ;
    cmd.mantissa_1 = operand1 [22:0]  ;
    cmd.sign_2     = operand2 [31]    ;
    cmd.exp_2      = operand2 [30:23] ;
    cmd.mantissa_2 = operand2 [22:0]  ;
    
    ap.write(cmd);
  endfunction
  
endclass
    