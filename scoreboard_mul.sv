class scoreboard extends uvm_subscriber #(result_transaction);
   `uvm_component_utils(scoreboard);


   uvm_tlm_analysis_fifo #(command_transaction) cmd_f;
   
   function new (string name, uvm_component parent);
      super.new(name, parent);
   endfunction : new

   function void build_phase(uvm_phase phase);
      cmd_f = new ("cmd_f", this);
   endfunction : build_phase

function result_transaction predict_result(command_transaction cmd);
   result_transaction predicted;
      
   predicted = new("predicted");
   predicted.result_dec = cmd.a_dec * cmd.b_dec;

   return predicted;

endfunction : predict_result
   

   function void write(result_transaction t);
      command_transaction cmd;
      result_transaction predicted;
     real diff ;
     real diff_2;
     real predicted_result_2;
     //real claculated_result_2;
  
     rand_num result_num;
     //do begin
        cmd_f.try_get(cmd);
     //end
     //while (!cmd_f.try_get(cmd));

      predicted = predict_result(cmd);
     
     if(predicted.result_dec < 1e-95 && predicted.result_dec > -1e-95 
       && predicted.result_dec != 0 )
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
     
     if(predicted.result_dec > 9999999e90 || predicted.result_dec < -9999999e90)
       begin
         predicted.flags[2] = 1 ;
         predicted.flags[0] = 1 ;
         if( t.flags != predicted.flags)
            `uvm_error("SELF CHECKER", "FAIL" )
         else
             `uvm_info ("SELF CHECKER", {"PASS"}, UVM_LOW)
           $display ("OVERFLOW case") ;      
         $display("predicted flags = %b " , predicted.flags);
         $display ("dut flags = %b" , t.flags); 
         return;
       end
      
     if(t.result_dec > predicted.result_dec)
       diff = t.result_dec - predicted.result_dec ;
     else
       diff = predicted.result_dec - t.result_dec ;
     
     result_num = decode(t.Result);
     
     predicted_result_2 = predicted.result_dec;
     
     if(predicted_result_2 < 0 )
       predicted_result_2 = -1.0 * predicted_result_2 ; 
     
       
     
     if(predicted_result_2 > 1 )
       begin
         while(predicted_result_2 > 10)
           predicted_result_2 = predicted_result_2/10.0 ;
         //$display(predicted_result_2);
         
       end
     else
       begin
         while(predicted_result_2 < 1)
           predicted_result_2 = predicted_result_2*10.0 ;
         //$display(predicted_result_2);
       end
     
         predicted_result_2 = predicted_result_2*1e7;
         diff_2 = predicted_result_2 - $itor(int'(predicted_result_2)) ;
         //$display(predicted_result_2);
         //$display( $itor(int'(predicted_result_2)));
         
 
    
     //$display(diff_2);
     if( (diff_2 < 0 && diff_2 <-1e-5 ) || 
        ((diff_2>0.49999)&& (diff_2-0.49999 < 1e-5) ) ) 
       predicted.flags[0] = 1 ;
    /* $display("predicted flags = %b " , predicted.flags);
     $display ("dut flags = %b" , t.flags);
     $display("calculated result = " , t.result_dec);
     $display("differnce = " , diff);*/
     
     
       
     //result_num = decode(t.Result);
     $display("operand1 = " , cmd.a_dec) ;
         $display("operand2 = " , cmd.b_dec) ;
         $display("predicted result = " , predicted.result_dec) ;
         $display("predicted flags = %b " , predicted.flags);
         $display ("dut flags = %b" , t.flags) ;
         $display("calculated result = " , t.result_dec) ;
         $display("differnce = " , diff) ;
     
     if (diff > (10.0**$itor(result_num.exp)) || t.flags != predicted.flags)
       begin
         /*$display("operand1 = " , cmd.a_dec) ;
         $display("operand2 = " , cmd.b_dec) ;
         $display("predicted result = " , predicted.result_dec) ;
         $display("predicted flags = %b " , predicted.flags);
         $display ("dut flags = %b" , t.flags) ;
         $display("calculated result = " , t.result_dec) ;
         $display("differnce = " , diff) ;*/
         `uvm_error("SELF CHECKER", "FAIL" )
       end
       
     else
        `uvm_info ("SELF CHECKER", {"PASS"}, UVM_LOW)

   endfunction : write
endclass : scoreboard