class driver extends uvm_component;
   `uvm_component_utils(driver)
  virtual bfm bfm;
  
  uvm_get_port #(command_transaction) command_port;
  
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
  
   function void build_phase(uvm_phase phase);     
     if(!uvm_config_db #(virtual bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM")
      command_port = new("command_port",this);
   endfunction : build_phase
  
  
   task run_phase(uvm_phase phase);
      command_transaction    command;
      forever begin : command_loop
        #50///////////////// racing on FIFO 
        command_port.get(command);
        bfm.send_op(command.a_rep, command.b_rep);
        bfm.write_to_monitor(command.a_dec , command.b_dec);
        //$display(command.a_dec);
        //$display(command.b_dec);
      end : command_loop
   endtask : run_phase
  
endclass