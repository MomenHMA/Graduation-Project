`default_nettype none
module output_register(
  input  wire 		 clk 		 	   ,
  input  wire        reset_n   	 	   ,
  input  wire [31:0] result     	   ,
  input  wire [3:0]  flags      	   ,
  input  wire 		 fpu_doorbell_r_i  ,
  input  wire        fpu_interrupt_w   ,
  input  wire        fpu_int_en        ,  
  output wire        fpu_ready		   ,  
  output wire [31:0] fpu_output   	   , 
  output wire [3:0]  fpu_output_flags    
    );
	
//reg [1:0]  clk_counts    ;
reg [31:0] output_reg    ;
reg [3:0] flags_reg      ;
reg 	   ready         ;
reg 	   delayed_ready ;


always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_reg 	 	 <= 32'h0000_0000;
		flags_reg 	     <= 4'b0000	 	 ;
		ready		 	 <= 1'b0         ;	
	  end
	else
	  begin
        if(fpu_doorbell_r_i)
		  begin
			output_reg 	 	 <= result	 	     ;
			flags_reg 	     <= flags	 	  	 ;
			ready	 		 <= 1'b1 	         ;
		  end
		  else
		    begin
			  output_reg	    <= output_reg ;
			  flags_reg 		<= flags_reg  ;
			 // fpu_ready 		<= ~fpu_interrupt_w ;
			  if (ready && delayed_ready && fpu_int_en)
			    begin
			      ready <= fpu_interrupt_w ;
			    end
			  else
			    begin
				  if (ready && delayed_ready && !fpu_int_en)
				    begin
					  ready <= fpu_interrupt_w ;
					end
				  else
				    begin
					  ready <= ready;
					end
				end 
			end
		  
	  end
  end
 
always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		delayed_ready 	 	 <= 1'b0;
	  end
	else
	  begin
		delayed_ready <= ready ;
	  end
  end
  
/* always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        clk_counts <= 2'd0;
	  end
	else
	  begin
	    if (fpu_doorbell_r_i || clk_counts)
		  begin
		    if (clk_counts == 2'd1)
			  begin
			     clk_counts <= 2'd0;
			  end
			else
			  begin
			    clk_counts <= {clk_counts + 1'b1};
			  end
		  end
		else
		  begin
		    clk_counts <= 2'd0;
		  end
	  end
  end */
  
assign fpu_output 	    = output_reg ;
assign fpu_output_flags = flags_reg  ;
assign fpu_ready        = ready	  	 ;


endmodule
`resetall
