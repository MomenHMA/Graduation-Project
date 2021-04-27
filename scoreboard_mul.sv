class scoreboard extends uvm_subscriber #(result_transaction);
  `uvm_component_utils(scoreboard);
  
  uvm_tlm_analysis_fifo #(sequence_item) cmd_f ; 
  
  function new (string name , uvm_component parent );
    super.new (name,parent);
  endfunction
  
  function void build_phase (uvm_phase phase);
    cmd_f = new ("cmd_f",this);
  endfunction
  
  function result_transaction predict_result(sequence_item cmd);
    result_transaction predicted;
    predicted = new("predicted") ;
    predicted.result = $shortrealtobits(
      $bitstoshortreal({cmd.sign_1, cmd.exp_1, cmd.mantissa_1})*
      $bitstoshortreal({cmd.sign_2, cmd.exp_2, cmd.mantissa_2}));
    return predicted ; 
  endfunction
  
  function void write (result_transaction t);
    sequence_item cmd ; 
    result_transaction predicted ;
    bit [63:0] predicted_2 ; 
    cmd       = new ("cmd")      ;
    predicted = new ("predicted");
    
    
    cmd_f.try_get(cmd);

    predicted = predict_result(cmd) ; 
    predicted_2 = $realtobits(
      $bitstoshortreal({cmd.sign_1, cmd.exp_1, cmd.mantissa_1})*
      $bitstoshortreal({cmd.sign_2, cmd.exp_2, cmd.mantissa_2}));
    
    if(predicted.result[30:0] == 31'b11111111_00000000_00000000_0000000)
       begin
         predicted.flags[2] = 1 ;
         predicted.flags[0] = 1 ;
         if( t.flags != predicted.flags)
            `uvm_error("SELF CHECKER", "FAIL" )
         else
             `uvm_info ("SELF CHECKER", {"PASS"}, UVM_LOW)
          $display ("OVERFLOW case");      
         $display("predicted flags = %b " , predicted.flags);
         $display ("dut flags = %b" , t.flags); 
         return;
       end
    
    if(predicted.result[30:0] == 31'b0 )
       begin
         predicted.flags[1] = 1 ;
         predicted.flags[0] = 1 ;
         if( t.flags != predicted.flags)
            `uvm_error("SELF CHECKER", "FAIL" )
         else
             `uvm_info ("SELF CHECKER", {"PASS"}, UVM_LOW)
         $display ("UNDERFLOW case");      
         $display("predicted flags = %b " , predicted.flags); 
         $display ("dut flags = %b" , t.flags);  
         return;
       end
    
    if(predicted_2[27] == 1'b1)
        predicted.flags[0] = 1 ;
        
      
      
    
    if((($bitstoshortreal(predicted.result) == $bitstoshortreal(t.result))||
       (t.result[22:0]-predicted.result[22:0] == 1'b1 )||
        (predicted.result[22:0] - t.result[22:0] == 1'b1 )) &&
       predicted.flags == t.flags
      )
      `uvm_info ("SELF_CHECKER" ,"PASS" ,UVM_LOW)
    else
      begin
        `uvm_error("SELF_CHECKER","FAIL");
        $display("operand1 = " ,
             $bitstoshortreal({cmd.sign_1, cmd.exp_1, cmd.mantissa_1}));
        $display("operand2 =  " ,
             $bitstoshortreal({cmd.sign_2, cmd.exp_2, cmd.mantissa_2})); 
        $display("predicted =  ",$bitstoshortreal(predicted.result));
        $display("calculated = ",$bitstoshortreal(t.result));
        $display("predicted flags = %b " , predicted.flags); 
        $display ("dut flags = %b" , t.flags); 
        $display("%b" , predicted_2);
      end
  endfunction
  
endclass
    
    