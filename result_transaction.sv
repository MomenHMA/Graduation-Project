class result_transaction extends uvm_transaction ;
  
  bit [31:0] result ; 
  bit [3:0]  flags  ;
  
  function new (string name = "");
    super.new(name);
  endfunction
  
endclass
  