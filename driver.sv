class driver extends uvm_driver #(sequence_item);
  `uvm_component_utils(driver) 
  
   virtual bfm bfm;
 
   function void build_phase(uvm_phase phase);
      if(!uvm_config_db #(virtual bfm)::get(null, "*","bfm", bfm))
        `uvm_fatal("DRIVER", "Failed to get BFM")
   endfunction : build_phase

   task run_phase(uvm_phase phase);
      sequence_item cmd;

      forever begin : cmd_loop
        seq_item_port.get_next_item(cmd) ;
        bfm.send_op({cmd.sign_1,cmd.exp_1,cmd.mantissa_1} ,
                    {cmd.sign_2,cmd.exp_2,cmd.mantissa_2});
        bfm.write_to_monitor ();
        seq_item_port.item_done()        ;
      end : cmd_loop
   endtask : run_phase
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new
   
endclass : driver
