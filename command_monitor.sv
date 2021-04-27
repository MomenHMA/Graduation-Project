
class command_monitor extends uvm_component;
   `uvm_component_utils(command_monitor);
  
  virtual bfm bfm;
  
  uvm_analysis_port #(command_transaction) cm_port;
  
   function new (string name, uvm_component parent);
      super.new(name,parent);
   endfunction
  
   function void build_phase(uvm_phase phase);
     if(!uvm_config_db #(virtual bfm)::get(null, "*","bfm", bfm))
	`uvm_fatal("COMMAND MONITOR", "Failed to get BFM")
      bfm.command_monitor_h = this;
     cm_port  = new("cm_port",this);
   endfunction : build_phase
  
  function void write_to_monitor(real a_dec, real b_dec);
     command_transaction cmd;
     cmd = new("cmd");
     cmd.a_dec = a_dec;
     cmd.b_dec = b_dec;
   // $display(cmd.a_dec);
   // $display(cmd.b_dec);
    
     cm_port.write(cmd);
    
   endfunction : write_to_monitor
  
  /* task run_phase(uvm_phase phase);
      command_transaction  command;
      phase.raise_objection(this);

     repeat (1) begin
        command = command_transaction::type_id::create("command");
        //command.random();
        //command.dec();
       command.a_dec = ((-1.0)**$itor(0))*$itor(7654321)*(10.0**$itor(25)); 
       command.b_dec = ((-1.0)**$itor(0))*$itor(6598732)*(10.0**$itor(20));
       write_to_monitor(command.a_dec , command.b_dec); 
      end
     #500;

      phase.drop_objection(this);
   endtask : run_phase*/
  
  
endclass : command_monitor