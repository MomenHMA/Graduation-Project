class env extends uvm_env ;
  `uvm_component_utils(env)
  
  sequencer   sequencer_h           ;
  driver      driver_h              ; 
  command_monitor command_monitor_h ;
  result_monitor  result_monitor_h  ;
  scoreboard      scoreboard_h      ;
  
  
  function new (string name , uvm_component parent) ;
    super.new (name,parent) ;
  endfunction
  
  function void build_phase (uvm_phase phase) ;
    
    sequencer_h       = new("sequencer_h" , this )                  ;
    driver_h          = driver::type_id::create("driver_h" , this ) ;
    command_monitor_h = new("command_monitor_h" , this)             ;
    result_monitor_h  = new("result_monitor_h" , this)              ;
    scoreboard_h      = new("scoreboard_h" , this)                  ;
    
  endfunction
  
  function void connect_phase (uvm_phase phase);
    
    driver_h.seq_item_port.connect(sequencer_h.seq_item_export) ;
    command_monitor_h.ap.connect (scoreboard_h.cmd_f.analysis_export);
    result_monitor_h.ap.connect ( scoreboard_h.analysis_export);
    
  endfunction 
  
endclass
    
    