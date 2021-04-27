`default_nettype none
module interrupt_mux(
  input  wire 	    simd_ready 		   ,
  input  wire [3:0] simd_flags         ,
  input  wire       fpu_simd 		   ,
  input  wire       fpu_ready          ,  
  input  wire [3:0] fpu_flags          ,  
  output reg        fpu_ready_hci	   ,
  output reg  [3:0] fpu_flags_hci        
    );
	

always @ (*)
  begin
    case(fpu_simd)
	  1'b1   :  begin
				  fpu_ready_hci      = simd_ready     ;
				  fpu_flags_hci      = simd_flags     ;
	            end
	  1'b0   :  begin
				  fpu_ready_hci      = fpu_ready      ;
				  fpu_flags_hci      = fpu_flags      ;
	            end			
    endcase				
  end


endmodule
`resetall
