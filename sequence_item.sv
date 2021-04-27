class sequence_item extends uvm_sequence_item;
   `uvm_object_utils(sequence_item);

  function new(string name = "") ;
    super.new(name) ;
  endfunction : new 
  
  rand bit [22:0]  mantissa_1 ;
  rand bit [7:0]   exp_1      ;
  rand bit         sign_1     ;
  rand bit [22:0]  mantissa_2 ;
  rand bit [7:0]   exp_2      ;
  rand bit         sign_2     ;
  
  
  constraint normal_num_1 { sign_1==0               ;
                            exp_1 inside{ [1:254] } ; 
                          }
  constraint normal_num_2 { sign_2==0               ;
                            exp_2 inside{ [1:254] } ; 
                          }
  constraint subnormal_num_1 { sign_1== 0           ;
                               exp_1 == 0           ; 
                             }
  constraint subnormal_num_2 { sign_2==0            ;
                               exp_2 == 0           ;
                             } 
  
  
endclass