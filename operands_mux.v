`default_nettype none
module operands_mux(
  input  wire        fpu_simd 		   	    ,
  input  wire [31:0] simd_operand_a         , 
  input  wire [31:0] simd_operand_b         , 
  input  wire [31:0] simd_operand_c         , 
  input  wire [31:0] fpu_operand_a_hci      ,
  input  wire [31:0] fpu_operand_b_hci      ,
  input  wire [31:0] fpu_operand_c_hci      ,  
  output reg  [31:0] fpu_operand_a		    ,  
  output reg  [31:0] fpu_operand_b		    ,  
  output reg  [31:0] fpu_operand_c		        
    );
	

always @ (*)
  begin
    case(fpu_simd)
	  1'b1   :  begin
				  fpu_operand_a     = simd_operand_a     ;
				  fpu_operand_b     = simd_operand_b     ;
				  fpu_operand_c     = simd_operand_c     ; 
	            end
	  1'b0   :  begin
				  fpu_operand_a     = fpu_operand_a_hci  ;
				  fpu_operand_b     = fpu_operand_b_hci  ;		
				  fpu_operand_c     = fpu_operand_c_hci  ;				  
	            end			
    endcase				
  end


endmodule
`resetall
