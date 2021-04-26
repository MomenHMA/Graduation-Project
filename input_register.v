`default_nettype none
module two_input_register(
  input  wire 		 clk 		 	   ,
  input  wire        reset_n   	 	   ,
  input  wire        fpu_rst_w   	   ,
  input  wire        fpu_doorbell_w	   ,
  input  wire        simd_doorbell     ,
  input  wire        enable			   ,  
  input  wire [31:0] fpu_operand_a 	   ,
  input  wire [31:0] fpu_operand_b 	   ,
  output wire [31:0] operand1		   ,
  output wire [31:0] operand2 		   ,
  output reg 		 fpu_doorbell_r_i  
    );

reg [31:0] operand_a 		      ;
reg [31:0] operand_b 		      ;


always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a 	 	 <= 32'h0000_0000;
		operand_b 	     <= 32'h0000_0000;
		fpu_doorbell_r_i <= 1'b0         ;
		
	  end
	else
	  begin
        if(fpu_rst_w && fpu_doorbell_w)
		  begin
			operand_a 	 	 <= 32'h0000_0000;
			operand_b 		 <= 32'h0000_0000;
			fpu_doorbell_r_i <= 1'b1         ;
		  end
		else
		  begin
		   if ((fpu_doorbell_w || simd_doorbell) && enable)
		     begin
			   operand_a	    <= fpu_operand_a ;
			   operand_b 		<= fpu_operand_b ;
			   fpu_doorbell_r_i <= 1'b1   	 	 ;
			 end
		   else
		     begin
			   operand_a   	    <= operand_a ;
			   operand_b   	    <= operand_b ;
			   fpu_doorbell_r_i <= 1'b0      ;  
			 end
		  end
		  
	  end
  end

assign operand1 = operand_a ;
assign operand2 = operand_b ;

endmodule
`resetall