
`default_nettype none
module sw_dataout_mux(
  input  wire        fpu_simd 		   	    ,
  input  wire [31:0] sw_address  	        ,
  input  wire [31:0] simd_output            , 
  input  wire [31:0] sw_dataout_fpu         , 
  output reg  [31:0] sw_dataout		        
    );
	
localparam FPU_COMMAND_REGISTER  = 32'h0000_0000 ,
		   FPU_STATUS_REGISTER_0 = 32'h0000_0110 ,
		   OUTPUT_0              = 32'h0000_0130 ;

always @ (*)
  begin
   sw_dataout =  simd_output;
    case(sw_address)
	  FPU_COMMAND_REGISTER     :  begin
									sw_dataout =  sw_dataout_fpu; 
								  end
	  FPU_STATUS_REGISTER_0    :  begin
									sw_dataout =  sw_dataout_fpu;
								  end	
	  OUTPUT_0 			       :  begin
									if (fpu_simd)
									  begin
									    sw_dataout =  simd_output;
									  end
									else
									  begin
									    sw_dataout = sw_dataout_fpu;
									  end
								  end									  
								  
    endcase				
  end


endmodule
`resetall
