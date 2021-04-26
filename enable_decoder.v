`default_nettype none
module enable_decoder(
  input  wire [1:0 ] fpu_format   	       ,
  input  wire [1:0 ] fpu_operation 	       ,
  input  wire        fpu_en				   ,  
  input  wire        fpu_rst_w			   ,
  input  wire        fpu_doorbell_w	       ,
  input  wire        simd_doorbell         ,
  output reg  [11:0] enable    
    );
	
localparam SINGLE_PREC_ADD     = 4'b0000 ,
		   BINARY_FORMAT_ADD   = 4'b0001 ,
		   DECIMAL_FORMAT_ADD  = 4'b0010 ,
		   SINGLE_PREC_SUB     = 4'b0100 ,
		   BINARY_FORMAT_SUB   = 4'b0101 ,
		   DECIMAL_FORMAT_SUB  = 4'b0110 ,
		   SINGLE_PREC_MUL     = 4'b1000 ,
		   BINARY_FORMAT_MUL   = 4'b1001 ,
		   DECIMAL_FORMAT_MUL  = 4'b1010 ,
		   SINGLE_PREC_FMA     = 4'b1100 ,
		   BINARY_FORMAT_FMA   = 4'b1101 ,
		   DECIMAL_FORMAT_FMA  = 4'b1110 ;
		   
		   
always @ (*)
 begin
  if (fpu_rst_w)
   begin
     enable 				   = 12'hFFF ;
   end
   else
    begin
	 
     if (fpu_en &&(fpu_doorbell_w || simd_doorbell))
	   begin
        enable 				   = 12'h000 ;
	
  	    case ({fpu_operation, fpu_format})
	        SINGLE_PREC_ADD     :  begin
									enable[11] = 1'b1;      
				      		       end
	        BINARY_FORMAT_ADD   :  begin
									enable[10] = 1'b1;      
								   end
			DECIMAL_FORMAT_ADD  :  begin
									enable[9] = 1'b1;      
								   end
			SINGLE_PREC_SUB     :  begin
									enable[8] = 1'b1;      
								   end							 
			BINARY_FORMAT_SUB   :  begin
									enable[7] = 1'b1;      
								   end
			DECIMAL_FORMAT_SUB  :  begin
									enable[6] = 1'b1;      
								   end
			SINGLE_PREC_MUL     :  begin
									enable[5] = 1'b1;      
								   end
			BINARY_FORMAT_MUL   :  begin
									enable[4] = 1'b1;      
								   end
			DECIMAL_FORMAT_MUL  :  begin
									enable[3] = 1'b1;      
								   end
			SINGLE_PREC_FMA     :  begin
									enable[2] = 1'b1;      
								   end
			BINARY_FORMAT_FMA   :  begin
									enable[1] = 1'b1;      
								   end
			DECIMAL_FORMAT_FMA  :  begin
									enable[0] = 1'b1;      
								   end							 
		endcase
	 end 
	 else 
	   begin
	     enable 				   = 12'h000 ;
	   end
  end
 end 
endmodule
`resetall
