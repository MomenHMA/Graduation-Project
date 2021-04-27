
////////////////////////////////////////////////////////////////////////////////
class command_transaction extends uvm_transaction;
   `uvm_object_utils(command_transaction)
  bit [31:0] a_rep;
  bit [31:0] b_rep;
  real a_dec;
  real b_dec;
  
  function new (string name = "");
      super.new(name);
   endfunction : new
  
  function void random ();
    rand_num num ;
    num = new();
    num.randomize();
    a_rep = represent(num);
    num.randomize();
    b_rep = represent(num);
  endfunction
  
  function void dec ();
    rand_num num;
    num = new();
    num = decode(a_rep);
    a_dec = num.gen_num();
    num = decode(b_rep);
    b_dec = num.gen_num();
  endfunction
  
endclass
  
  