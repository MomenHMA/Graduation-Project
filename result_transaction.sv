class result_transaction extends uvm_transaction;
  `uvm_object_utils(result_transaction)
  
  bit [31:0] Result ; 
  real       result_dec;
  bit [3:0]  flags ; 
  
  function new (string name = "");
    super.new(name);
  endfunction : new
  
  function void dec ();
    rand_num num;
    num = new();
    num = decode(Result);
    result_dec = num.gen_num();
  endfunction
  
endclass
  