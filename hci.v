`default_nettype none
module hci(
  input  wire 		 clk 		 	       ,
  input  wire        reset_n   	 	       ,
  input  wire [31:0] sw_address  	       ,
  input  wire		 sw_read_en    	       ,
  input  wire		 sw_write_en   	       ,
  input  wire [31:0] sw_datain   	       ,   
  input  wire        fpu_rst_r   	       ,
  input  wire        fpu_doorbell_r        ,
  input  wire [31:0] fpu_output   	       , 
  input  wire        fpu_invalid_op_flag_0 ,
  input  wire        fpu_overflow_flag_0   ,
  input  wire        fpu_underflow_flag_0  ,
  input  wire        fpu_inexact_flag_0    ,  
  input  wire        fpu_ready             , 
  output wire [31:0] sw_dataout   	       ,
  output wire        fpu_rst_w  	       ,   
  output wire        fpu_en      	       ,
  output wire        fpu_doorbell_w        ,
  output wire [1:0 ] fpu_format   	       ,
  output wire [1:0 ] fpu_operation 	       , 
  output wire        fpu_fused_m_a         ,  
  output wire        fpu_simd     	       ,
  output wire [3:0 ] fpu_simd_no_op	       ,
  output wire [31:0] fpu_operand_a 		   ,
  output wire [31:0] fpu_operand_b 		   ,
  output wire [31:0] fpu_operand_c 		   ,
  output wire        fpu_int_en            ,
  output wire        fpu_interrupt_w       
    );
	
localparam FPU_COMMAND_REGISTER  = 32'h0000_0000 ,
		   OPERAND_A_0           = 32'h0000_0010 ,
		   OPERAND_B_0           = 32'h0000_0050 ,
		   OPERAND_C_0           = 32'h0000_0090 ,
	       FPU_STATUS_REGISTER_0 = 32'h0000_0110 ,
		   OUTPUT_0              = 32'h0000_0130 ;
		   
reg [31:0] data_w			      ;
reg [31:0] data_out			      ;
//reg [3:0]  data_r 			      ;
reg        fpu_command_reg_w_en   ;
reg        fpu_command_reg_r_en   ;
reg [31:0] fpu_command_reg_data_r ;
reg [31:0] command_reg		      ;
reg        operand_a_w_en         ;
reg [31:0] operand_a 		      ;
reg        operand_b_w_en         ;
reg [31:0] operand_b 		      ;
reg        operand_c_w_en         ;
reg [31:0] operand_c		      ;
reg        output_r_en            ;
//reg [31:0] output_data  	      ;
reg        fpu_status_reg_0_w_en  ;
reg        fpu_status_reg_0_r_en  ;
reg [31:0] fpu_status_reg_0_data  ;
reg [26:0] status_reg		      ;
reg        interrupt			  ;
reg        delayed_interrupt	  ;

always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		command_reg <= 32'h0000_0000;
	  end
	else
	  begin
        if(fpu_command_reg_w_en)
		  begin
			command_reg <= data_w ;
		  end
		else
		  begin
		   command_reg[31:3] <= command_reg[31:3] ;
		   command_reg[1]    <= command_reg[1]    ;
		   if (command_reg[0])
		     begin
		       command_reg[0] <= fpu_rst_r ;
			 end
		   else
		     begin
			   command_reg[0] <= command_reg[0] ;
			 end
		   if (command_reg[2])
		     begin
		       command_reg[2] <= fpu_doorbell_r ;
			 end
		   else
		     begin
			   command_reg[2] <= command_reg[2] ;
			 end
		   		   
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        operand_a <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_w_en)
		  begin
		    operand_a <= data_w ;
		  end
		else
		  begin
		    operand_a <= operand_a;
		  end
	  end
  end  
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        operand_b <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_w_en)
		  begin
		    operand_b <= data_w ;
		  end
		else
		  begin
		    operand_b <= operand_b;
		  end
	  end
  end  
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        operand_c <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_w_en)
		  begin
		    operand_c <= data_w ;
		  end
		else
		  begin
		    operand_c <= operand_c;
		  end
	  end
  end  
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        status_reg <= 28'h000_0000;
	  end
	else
	  begin
        if(fpu_status_reg_0_w_en)
		  begin
		    status_reg <= {data_w[31:6], data_w[2]} ;
		  end
		else
		  begin
		    status_reg <= status_reg;
		  end
		  
	  end
  end  
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        data_out <= 32'h0000_0000;
	  end
	else
	  begin
        if(fpu_command_reg_r_en)
		  begin
		    data_out <= fpu_command_reg_data_r ;
		  end
		else if (output_r_en)
		  begin
		    data_out <= fpu_output;
		  end
		else if (fpu_status_reg_0_r_en)
		  begin
		    data_out <= fpu_status_reg_0_data;
		  end
		else
		  begin
		    data_out <= data_out;
		  end
	  end
  end  
  
/*   always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
        output_data <= 32'h0000_0000;
		data_r      <= 4'b0000	  	;
		interrupt  	<= 1'b0	 		;
	  end
	else
	  begin
        if(fpu_ready)
		  begin
		    output_data <= fpu_output ;
			data_r      <= {fpu_inexact_flag_0, fpu_underflow_flag_0, fpu_overflow_flag_0, fpu_invalid_op_flag_0} ;
			if (command_reg[3])
			  begin
			    if (fpu_status_reg_0_w_en)
				  begin
				    interrupt <= data_w[0];
				  end
			    else 
				  begin
				    interrupt <= 1'b1 ;
				  end
			  end
			else
			  begin
			    interrupt <= 1'b1 ;
			  end
		  end
		else
		  begin
		    output_data <= output_data ;
			data_r      <= data_r      ;
			interrupt <= 1'b0 ;

		  end
	  end
  end  */
  
/*   always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		interrupt  	<= 1'b0	 		;
	  end
	else
	  begin
	    if (interrupt)
		  begin
		   if (command_reg[3])
			  begin
			    if (fpu_status_reg_0_w_en)
				  begin
				    interrupt <= data_w[0];
				  end
			    else 
				  begin
				    interrupt <= 1'b1 ;
				  end
			  end
		   else
		      begin
			    interrupt <= 1'b0;
			  end
			 end
		   else
		     begin
			   interrupt <= ~fpu_ready ;
			 end
	  end */
	  
always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		interrupt  	<= 1'b0	 		;
	  end
	else	  
 	  begin
        if(fpu_ready)
		  begin
		    if (delayed_interrupt && !interrupt )
			  begin
			    interrupt <= 1'b0 ;
			  end
			else
			begin
			if (command_reg[3])
			  begin
			    if (fpu_status_reg_0_w_en)
				  begin
				    interrupt <= data_w[0];
				  end
			    else 
				  begin
				    interrupt <= 1'b1 ;
				  end
			  end
			else
			  begin
			  if (fpu_status_reg_0_r_en)
				  begin
				    interrupt <= 1'b0 ;
				  end
			    else 
				  begin
				    interrupt <= 1'b1 ;
				  end
			  end
			  end
			end
		else
		  begin
			interrupt <= 1'b0 ;

		  end
	  end 
  end 
  
always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		delayed_interrupt  <= 1'b0;
	  end
	else
	  begin
		delayed_interrupt <= interrupt ;
	  end
  end  
  
  always @ (*)
  begin
    data_w 				   = 32'h0000_0000 ;
	fpu_command_reg_data_r = 32'h0000_0000 ;
	fpu_status_reg_0_data  = 32'h0000_0000 ;
	fpu_command_reg_w_en   = 1'b0   	   ;
	fpu_command_reg_r_en   = 1'b0		   ;
	operand_a_w_en         = 1'b0          ;
	operand_b_w_en         = 1'b0          ;
	operand_c_w_en         = 1'b0          ;
	output_r_en            = 1'b0          ;
	fpu_status_reg_0_w_en  = 1'b0		   ;
	fpu_status_reg_0_r_en  = 1'b0		   ;
	
	case (sw_address)
	  FPU_COMMAND_REGISTER  :  begin
							     if(sw_read_en && !sw_write_en)
								   begin
								     fpu_command_reg_r_en 	 = 1'b1       ;
								     fpu_command_reg_data_r  = command_reg;
								   end
								 else if(sw_write_en && !sw_read_en)
								   begin
								     fpu_command_reg_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_0			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_0			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end	  	
	  OPERAND_C_0			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end			
	  OUTPUT_0  			:  begin
							     if(sw_read_en && !sw_write_en)
								   begin
								     output_r_en = 1'b1;
								   end
							   end		
	  FPU_STATUS_REGISTER_0 :  begin
							     if(sw_read_en && !sw_write_en)
								   begin
								     fpu_status_reg_0_r_en = 1'b1 ;
									 fpu_status_reg_0_data = {status_reg[26:1],fpu_inexact_flag_0, fpu_underflow_flag_0, fpu_overflow_flag_0,  status_reg[0], fpu_invalid_op_flag_0, fpu_ready};
								   end
								 else if(sw_write_en && !sw_read_en)
								   begin
								     fpu_status_reg_0_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end							   
    endcase
  end
  
assign fpu_operand_a   = operand_a          			   											    		      ;  
assign fpu_operand_b   = operand_b	        			  											    		      ;
assign fpu_operand_c   = operand_c 		    			   											    		      ;
assign fpu_rst_w	   = command_reg[0]     			   											    		      ;
assign fpu_en 		   = command_reg[1]     															    		  ;	
assign fpu_doorbell_w  = command_reg[2] & command_reg[1] & (!command_reg[17] | ( command_reg[17] & command_reg[0]))   ;
assign fpu_int_en      = command_reg[3]     			   											    		      ;
assign fpu_format 	   = command_reg[6:5]   			   											    		      ;
assign fpu_operation   = command_reg[12:11]				   											    		      ;
assign fpu_fused_m_a   = command_reg[11] & command_reg[12] 											    		      ;
assign fpu_simd	       = command_reg[17]    			   											    		      ;
assign fpu_simd_no_op  = command_reg[21:18] 			   											    		      ;
assign fpu_interrupt_w = interrupt   	 				   											    		      ;
assign sw_dataout      = data_out						   											    		      ;
endmodule
`resetall
