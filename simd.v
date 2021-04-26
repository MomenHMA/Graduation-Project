`default_nettype none
module simd(
  input  wire 		 clk 		 	       ,
  input  wire        reset_n   	 	       ,
  input  wire [31:0] sw_address  	       ,
  input  wire		 sw_read_en    	       ,
  input  wire		 sw_write_en   	       ,
  input  wire [31:0] sw_datain   	       ,
  input  wire        fpu_simd     	       ,
  //input  wire        fpu_ready 	 	       ,
  input  wire [31:0] fpu_output   	       ,
  input  wire [3:0]  fpu_flags   	       ,  
  input  wire        fpu_interrupt_w       ,
  input  wire        fpu_int_en            ,   
  input  wire [3:0 ] fpu_simd_no_op	       ,
  output reg  [31:0] simd_operand_a 	   ,
  output reg  [31:0] simd_operand_b 	   ,
  output reg  [31:0] simd_operand_c 	   ,
  output reg  [31:0] simd_output    	   ,
  output wire [3:0]  simd_flags      	   ,  
 // output reg         fpu_ready_read 	   ,
  output reg          simd_doorbell 	   ,
  output wire         simd_ready 	 	    
    );
	
localparam OPERAND_A_0           = 32'h0000_0010 ,
		   OPERAND_A_1           = 32'h0000_0014 ,
		   OPERAND_A_2           = 32'h0000_0018 ,
		   OPERAND_A_3           = 32'h0000_001C ,
		   OPERAND_A_4           = 32'h0000_0020 ,
		   OPERAND_A_5           = 32'h0000_0024 ,
		   OPERAND_A_6           = 32'h0000_0028 ,
		   OPERAND_A_7           = 32'h0000_002C ,
		   OPERAND_A_8           = 32'h0000_0030 ,
		   OPERAND_A_9           = 32'h0000_0034 ,
		   OPERAND_A_10          = 32'h0000_0038 ,
		   OPERAND_A_11          = 32'h0000_003C ,
		   OPERAND_A_12          = 32'h0000_0040 ,
		   OPERAND_A_13          = 32'h0000_0044 ,
		   OPERAND_A_14          = 32'h0000_0048 ,
		   OPERAND_A_15          = 32'h0000_004C ,
		   OPERAND_B_0           = 32'h0000_0050 ,
		   OPERAND_B_1           = 32'h0000_0054 ,
		   OPERAND_B_2           = 32'h0000_0058 ,
		   OPERAND_B_3           = 32'h0000_005C ,
		   OPERAND_B_4           = 32'h0000_0060 ,
		   OPERAND_B_5           = 32'h0000_0064 ,
		   OPERAND_B_6           = 32'h0000_0068 ,
		   OPERAND_B_7           = 32'h0000_006C ,
		   OPERAND_B_8           = 32'h0000_0070 ,
		   OPERAND_B_9           = 32'h0000_0074 ,
		   OPERAND_B_10          = 32'h0000_0078 ,
		   OPERAND_B_11          = 32'h0000_007C ,
		   OPERAND_B_12          = 32'h0000_0080 ,
		   OPERAND_B_13          = 32'h0000_0084 ,
		   OPERAND_B_14          = 32'h0000_0088 ,
		   OPERAND_B_15          = 32'h0000_008C ,
		   OPERAND_C_0           = 32'h0000_0090 ,
		   OPERAND_C_1           = 32'h0000_0094 ,
		   OPERAND_C_2           = 32'h0000_0098 ,
		   OPERAND_C_3           = 32'h0000_009C ,
		   OPERAND_C_4           = 32'h0000_00A0 ,
		   OPERAND_C_5           = 32'h0000_00A4 ,
		   OPERAND_C_6           = 32'h0000_00A8 ,
		   OPERAND_C_7           = 32'h0000_00AC ,
		   OPERAND_C_8           = 32'h0000_00B0 ,
		   OPERAND_C_9           = 32'h0000_00B4 ,
		   OPERAND_C_10          = 32'h0000_00B8 ,
		   OPERAND_C_11          = 32'h0000_00BC ,
		   OPERAND_C_12          = 32'h0000_00C0 ,
		   OPERAND_C_13          = 32'h0000_00C4 ,
		   OPERAND_C_14          = 32'h0000_00C8 ,
		   OPERAND_C_15          = 32'h0000_00CC ,
		   OUTPUT_0      	     = 32'h0000_0130 ,
		   OUTPUT_1      	     = 32'h0000_0134 ,
		   OUTPUT_2      	     = 32'h0000_0138 ,
		   OUTPUT_3      	     = 32'h0000_013C ,
		   OUTPUT_4      	     = 32'h0000_0140 ,
		   OUTPUT_5      	     = 32'h0000_0144 ,
		   OUTPUT_6      	     = 32'h0000_0148 ,
		   OUTPUT_7      	     = 32'h0000_014C ,
		   OUTPUT_8      	     = 32'h0000_0150 ,
		   OUTPUT_9      	     = 32'h0000_0154 ,
		   OUTPUT_10      	     = 32'h0000_0158 ,
		   OUTPUT_11      	     = 32'h0000_015C ,
		   OUTPUT_12      	     = 32'h0000_0160 ,
		   OUTPUT_13      	     = 32'h0000_0164 ,
		   OUTPUT_14      	     = 32'h0000_0168 ,
		   OUTPUT_15      	     = 32'h0000_016C ,
		   FLAGS_1				 = 32'h0000_0114 ,
		   FLAGS_2				 = 32'h0000_0118 ,
		   FLAGS_3				 = 32'h0000_011C ;
		   
 	
reg [31:0] data_w			      ;
reg [31:0] operand_a_0 		      ;
reg [31:0] operand_a_1 		      ;
reg [31:0] operand_a_2 		      ;
reg [31:0] operand_a_3 		      ;
reg [31:0] operand_a_4 		      ;
reg [31:0] operand_a_5 		      ;
reg [31:0] operand_a_6		      ;
reg [31:0] operand_a_7 		      ;
reg [31:0] operand_a_8 		      ;
reg [31:0] operand_a_9 		      ;
reg [31:0] operand_a_10 		  ;
reg [31:0] operand_a_11 		  ;
reg [31:0] operand_a_12 	      ;
reg [31:0] operand_a_13		      ;
reg [31:0] operand_a_14		      ;
reg [31:0] operand_a_15		      ;
reg [31:0] operand_b_0 		      ;
reg [31:0] operand_b_1 		      ;
reg [31:0] operand_b_2 		      ;
reg [31:0] operand_b_3 		      ;
reg [31:0] operand_b_4 		      ;
reg [31:0] operand_b_5 		      ;
reg [31:0] operand_b_6		      ;
reg [31:0] operand_b_7 		      ;
reg [31:0] operand_b_8 		      ;
reg [31:0] operand_b_9 		      ;
reg [31:0] operand_b_10 		  ;
reg [31:0] operand_b_11 		  ;
reg [31:0] operand_b_12 	      ;
reg [31:0] operand_b_13		      ;
reg [31:0] operand_b_14		      ;
reg [31:0] operand_b_15		      ;
reg [31:0] operand_c_0 		      ;
reg [31:0] operand_c_1 		      ;
reg [31:0] operand_c_2 		      ;
reg [31:0] operand_c_3 		      ;
reg [31:0] operand_c_4 		      ;
reg [31:0] operand_c_5 		      ;
reg [31:0] operand_c_6		      ;
reg [31:0] operand_c_7 		      ;
reg [31:0] operand_c_8 		      ;
reg [31:0] operand_c_9 		      ;
reg [31:0] operand_c_10 		  ;
reg [31:0] operand_c_11 		  ;
reg [31:0] operand_c_12 	      ;
reg [31:0] operand_c_13		      ;
reg [31:0] operand_c_14		      ;
reg [31:0] operand_c_15		      ;
reg [31:0] output_0 		      ;
reg [31:0] output_1 		      ;
reg [31:0] output_2 		      ;
reg [31:0] output_3 		      ;
reg [31:0] output_4 		      ;
reg [31:0] output_5 		      ;
reg [31:0] output_6 		      ;
reg [31:0] output_7 		      ;
reg [31:0] output_8 		      ;
reg [31:0] output_9 		      ;
reg [31:0] output_10    		  ;
reg [31:0] output_11    		  ;
reg [31:0] output_12    	      ;
reg [31:0] output_13		      ;
reg [31:0] output_14		      ;
reg [31:0] output_15		      ;
reg [3:0]  flags_0 		     	  ;
reg [3:0]  flags_1 		     	  ;
reg [3:0]  flags_2 		     	  ;
reg [3:0]  flags_3 		     	  ;
reg [3:0]  flags_4 		      	  ;
reg [3:0]  flags_5 		      	  ;
reg [3:0]  flags_6 		     	  ;
reg [3:0]  flags_7 		     	  ;
reg [3:0]  flags_8 		     	  ;
reg [3:0]  flags_9 		      	  ;
reg [3:0]  flags_10    		  	  ;
reg [3:0]  flags_11    		  	  ;
reg [3:0]  flags_12    	      	  ;
reg [3:0]  flags_13		      	  ;
reg [3:0]  flags_14		  	      ;
reg [3:0]  flags_15	    	      ;
reg		   operand_a_0_w_en       ;
reg		   operand_a_1_w_en       ;
reg		   operand_a_2_w_en       ;
reg		   operand_a_3_w_en       ;
reg		   operand_a_4_w_en       ;
reg		   operand_a_5_w_en       ;
reg		   operand_a_6_w_en       ;
reg		   operand_a_7_w_en       ;
reg		   operand_a_8_w_en       ;
reg		   operand_a_9_w_en       ;
reg		   operand_a_10_w_en      ;
reg		   operand_a_11_w_en      ;
reg		   operand_a_12_w_en      ;
reg		   operand_a_13_w_en      ;
reg		   operand_a_14_w_en      ;	
reg		   operand_a_15_w_en      ;
reg		   operand_b_0_w_en       ;
reg		   operand_b_1_w_en       ;
reg		   operand_b_2_w_en       ;
reg		   operand_b_3_w_en       ;
reg		   operand_b_4_w_en       ;
reg		   operand_b_5_w_en       ;
reg		   operand_b_6_w_en       ;
reg		   operand_b_7_w_en       ;
reg		   operand_b_8_w_en       ;
reg		   operand_b_9_w_en       ;
reg		   operand_b_10_w_en      ;
reg		   operand_b_11_w_en      ;
reg		   operand_b_12_w_en      ;
reg		   operand_b_13_w_en      ;
reg		   operand_b_14_w_en      ;	
reg		   operand_b_15_w_en      ;
reg		   operand_c_0_w_en       ;
reg		   operand_c_1_w_en       ;
reg		   operand_c_2_w_en       ;
reg		   operand_c_3_w_en       ;
reg		   operand_c_4_w_en       ;
reg		   operand_c_5_w_en       ;
reg		   operand_c_6_w_en       ;
reg		   operand_c_7_w_en       ;
reg		   operand_c_8_w_en       ;
reg		   operand_c_9_w_en       ;
reg		   operand_c_10_w_en      ;
reg		   operand_c_11_w_en      ;
reg		   operand_c_12_w_en      ;
reg		   operand_c_13_w_en      ;
reg		   operand_c_14_w_en      ;	
reg		   operand_c_15_w_en      ;
reg [4:0]  count			 	  ;
reg [4:0]  count_out		 	  ;
reg        ready 				  ; 
reg        ready_out 			  ;
reg        delayed_ready 		  ; 

always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_0 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_0_w_en)
		  begin
			operand_a_0 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_0     <= operand_a_0 ;
		  end
		  
	  end
  end

always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_1 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_1_w_en)
		  begin
			operand_a_1 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_1     <= operand_a_1 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_2 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_2_w_en)
		  begin
			operand_a_2 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_2     <= operand_a_2 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_3 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_3_w_en)
		  begin
			operand_a_3 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_3     <= operand_a_3 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_4 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_4_w_en)
		  begin
			operand_a_4 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_4     <= operand_a_4 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_5 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_5_w_en)
		  begin
			operand_a_5 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_5     <= operand_a_5 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_6 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_6_w_en)
		  begin
			operand_a_6 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_6     <= operand_a_6 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_7 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_7_w_en)
		  begin
			operand_a_7 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_7     <= operand_a_7 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_8 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_8_w_en)
		  begin
			operand_a_8 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_8     <= operand_a_8 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_9 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_9_w_en)
		  begin
			operand_a_9 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_9     <= operand_a_9 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_10 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_10_w_en)
		  begin
			operand_a_10 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_10     <= operand_a_10 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_11 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_11_w_en)
		  begin
			operand_a_11 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_11     <= operand_a_11 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_12 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_12_w_en)
		  begin
			operand_a_12 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_12     <= operand_a_12 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_13 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_13_w_en)
		  begin
			operand_a_13 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_13     <= operand_a_13 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_14 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_14_w_en)
		  begin
			operand_a_14 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_14     <= operand_a_14 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_a_15 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_a_15_w_en)
		  begin
			operand_a_15 	 <= data_w  ;
		  end
		else
		  begin
			operand_a_15     <= operand_a_15 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_0 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_0_w_en)
		  begin
			operand_b_0 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_0     <= operand_b_0 ;
		  end
		  
	  end
  end

always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_1 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_1_w_en)
		  begin
			operand_b_1 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_1     <= operand_b_1 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_2 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_2_w_en)
		  begin
			operand_b_2 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_2     <= operand_b_2 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_3 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_3_w_en)
		  begin
			operand_b_3 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_3     <= operand_b_3 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_4 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_4_w_en)
		  begin
			operand_b_4 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_4     <= operand_b_4 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_5 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_5_w_en)
		  begin
			operand_b_5 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_5     <= operand_b_5 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_6 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_6_w_en)
		  begin
			operand_b_6 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_6     <= operand_b_6 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_7 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_7_w_en)
		  begin
			operand_b_7 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_7     <= operand_b_7 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_8 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_8_w_en)
		  begin
			operand_b_8 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_8     <= operand_b_8 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_9 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_9_w_en)
		  begin
			operand_b_9 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_9     <= operand_b_9 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_10 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_10_w_en)
		  begin
			operand_b_10 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_10     <= operand_b_10 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_11 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_11_w_en)
		  begin
			operand_b_11 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_11     <= operand_b_11 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_12 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_12_w_en)
		  begin
			operand_b_12 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_12     <= operand_b_12 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_13 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_13_w_en)
		  begin
			operand_b_13 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_13     <= operand_b_13 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_14 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_14_w_en)
		  begin
			operand_b_14 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_14     <= operand_b_14 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_b_15 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_b_15_w_en)
		  begin
			operand_b_15 	 <= data_w  ;
		  end
		else
		  begin
			operand_b_15     <= operand_b_15 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_0 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_0_w_en)
		  begin
			operand_c_0 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_0     <= operand_c_0 ;
		  end
		  
	  end
  end

always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_1 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_1_w_en)
		  begin
			operand_c_1 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_1     <= operand_c_1 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_2 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_2_w_en)
		  begin
			operand_c_2 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_2     <= operand_c_2 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_3 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_3_w_en)
		  begin
			operand_c_3 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_3     <= operand_c_3 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_4 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_4_w_en)
		  begin
			operand_c_4 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_4     <= operand_c_4 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_5 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_5_w_en)
		  begin
			operand_c_5 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_5     <= operand_c_5 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_6 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_6_w_en)
		  begin
			operand_c_6 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_6     <= operand_c_6 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_7 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_7_w_en)
		  begin
			operand_c_7 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_7     <= operand_c_7 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_8 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_8_w_en)
		  begin
			operand_c_8 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_8     <= operand_c_8 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_9 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_9_w_en)
		  begin
			operand_c_9 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_9     <= operand_c_9 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_10 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_10_w_en)
		  begin
			operand_c_10 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_10     <= operand_c_10 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_11 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_11_w_en)
		  begin
			operand_c_11 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_11     <= operand_c_11 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_12 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_12_w_en)
		  begin
			operand_c_12 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_12     <= operand_c_12 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_13 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_13_w_en)
		  begin
			operand_c_13 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_13     <= operand_c_13 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_14 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_14_w_en)
		  begin
			operand_c_14 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_14     <= operand_c_14 ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		operand_c_15 	 	 <= 32'h0000_0000;
	  end
	else
	  begin
        if(operand_c_15_w_en)
		  begin
			operand_c_15 	 <= data_w  ;
		  end
		else
		  begin
			operand_c_15     <= operand_c_15 ;
		  end
		  
	  end
  end
  
    always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_0 	 	 <= 32'h0000_0000;
		flags_0 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b00011)
		  begin
			output_0 	 <= fpu_output  ;
			flags_0 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_0     <= output_0 ;
			flags_0		 <= flags_0  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_1 	 	 <= 32'h0000_0000;
		flags_1 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b00100)
		  begin
			output_1 	 <= fpu_output  ;
			flags_1 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_1     <= output_1 ;
			flags_1 	 <= flags_1  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_2 	 	 <= 32'h0000_0000;
		flags_2 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b00101)
		  begin
			output_2 	 <= fpu_output  ;
			flags_2 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_2     <= output_2 ;
			flags_2 	 <= flags_2  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_3 	 	 <= 32'h0000_0000;
		flags_3 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b00110)
		  begin
			output_3 	 <= fpu_output  ;
			flags_3 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_3     <= output_3 ;
			flags_3 	 <= flags_3  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_4 	 	 <= 32'h0000_0000;
		flags_4 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b00111)
		  begin
			output_4 	 <= fpu_output  ;
			flags_4 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_4     <= output_4 ;
			flags_4 	 <= flags_4  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_5 	 	 <= 32'h0000_0000;
		flags_5 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01000)
		  begin
			output_5 	 <= fpu_output  ;
			flags_5 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_5     <= output_5 ;
			flags_5 	 <= flags_5  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_6 	 	 <= 32'h0000_0000;
		flags_6 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01001)
		  begin
			output_6 	 <= fpu_output  ;
			flags_6 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_6     <= output_6 ;
			flags_6 	 <= flags_6  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_7 	 	 <= 32'h0000_0000;
		flags_7 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01010)
		  begin
			output_7 	 <= fpu_output  ;
			flags_7 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_7     <= output_7 ;
			flags_7 	 <= flags_7  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_8 	 	 <= 32'h0000_0000;
		flags_8 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01011)
		  begin
			output_8 	 <= fpu_output  ;
			flags_8 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_8     <= output_8 ;
			flags_8 	 <= flags_8  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_9 	 	 <= 32'h0000_0000;
		flags_9 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01100)
		  begin
			output_9 	 <= fpu_output  ;
			flags_9 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_9     <= output_9 ;
			flags_9 	 <= flags_9  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_10 	 	 <= 32'h0000_0000;
		flags_10 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01101)
		  begin
			output_10 	 <= fpu_output  ;
			flags_10 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_10     <= output_10 ;
			flags_10 	  <= flags_10  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_11 	 	 <= 32'h0000_0000;
		flags_11 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01110)
		  begin
			output_11 	 <= fpu_output  ;
			flags_11 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_11     <= output_11 ;
			flags_11      <= flags_11  ;
		  end
		  
	  end
  end
  
      always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_12 	 	 <= 32'h0000_0000;
		flags_12 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b01111)
		  begin
			output_12 	 <= fpu_output  ;
			flags_12 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_12     <= output_12 ;
			flags_12      <= flags_12  ;
		  end
		  
	  end
  end
  
 always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_13 	 	 <= 32'h0000_0000;
		flags_13 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b10000)
		  begin
			output_13 	 <= fpu_output  ;
			flags_13 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_13     <= output_13 ;
			flags_13 	  <= flags_13  ;
		  end
		  
	  end
  end
  
  always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_14 	 	 <= 32'h0000_0000;
		flags_14 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b10001)
		  begin
			output_14 	 <= fpu_output  ;
			flags_14 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_14     <= output_14 ;
			flags_14  	  <= flags_14  ;
		  end
		  
	  end
  end
  
 always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		output_15 	 	 <= 32'h0000_0000;
		flags_15 	 	 <= 4'b0000 	 ;
	  end
	else
	  begin
        if(count_out == 5'b10010)
		  begin
			output_15 	 <= fpu_output  ;
			flags_15 	 <= fpu_flags  ;
		  end
		else
		  begin
			output_15     <= output_15 ;
			flags_15 	  <= flags_15  ;
		  end
		  
	  end
  end
  
  
    always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
			count      		<= 5'b00000  ;
		//	fpu_ready_read  <= 1'b0 	 ;
			ready 	        <= 1'b0      ;
			simd_doorbell   <= 1'b0      ;
	  end
	else
	  begin
        if(fpu_simd)
		  begin
/* 		    if(fpu_ready)
			  begin */
			    if (count < ({1'b0,fpu_simd_no_op} + 1'b1 ) && (count || ~ready))
				  begin
    			    count 		    <= count + 1'b1  ;
				    //fpu_ready_read  <= 1'b1 	     ;
					ready	        <= 1'b0          ;
					simd_doorbell   <= 1'b1          ;
				  end
				else
				  begin
				    if (count == ({1'b0,fpu_simd_no_op} + 1'b1 ))
				      begin
    			        count 		      <= ( {1'b0,fpu_simd_no_op} + 1'b1 )     ;
				        //fpu_ready_read  <= 1'b1                  			      ;
				        ready	          <= 1'b1                  			      ;
						simd_doorbell     <= 1'b0                                 ;
				    end
					else
					  begin
    			        count 		      <= 5'b00000 ;
				        //fpu_ready_read  <= 1'b1     ;
				        ready	          <= 1'b1     ;
						simd_doorbell     <= 1'b0     ;
				    end
				  end
/* 			  end
			else
              begin
			     count 	 <= count ;
				 //fpu_ready_read  <= 1'b0    ;
				 simd_doorbell   <= 1'b0    ;
				 simd_ready      <= 1'b0    ;
              end	 */		  
		  end
		else
		  begin 
			count           <= 5'b00000  ;
			//fpu_ready_read  <= 1'b0    ;
			ready	        <= 1'b0      ;			
			simd_doorbell   <= 1'b0      ;
		  end
		  
	  end
  end
  
always @(posedge clk or negedge reset_n)
  begin
    if (!reset_n)
	  begin
		count_out 	 	 <= 5'b00000;
		ready_out   	 <= 1'b0	;
	  end
	else
	  begin
        if(fpu_simd )
		  begin
		    if(count == 5'b00001 )
			  begin
			    count_out 	 <= count + 1'b1  ;
				ready_out	 <= 1'b0 		  ;
			  end
			else
			  begin
			    if(count_out < ({1'b0,fpu_simd_no_op} + 2'b11 ))
				 begin
				   count_out   <= count_out + 1'b1 ;
				   if (count_out == ({1'b0,fpu_simd_no_op} + 2'b10 ))
				     begin
					   ready_out  <= 1'b1 	       	   ;
					 end
					else
					 begin
					   ready_out  <= 1'b0 	       	   ;
					 end
				 end
				else
				 begin
				   count_out <= count_out ;
				   if (ready_out && delayed_ready && fpu_int_en)
			         begin
			           ready_out <= fpu_interrupt_w ;
			         end
                   else
			         begin
				       if (ready_out && delayed_ready && !fpu_int_en)
				         begin
					       ready_out <= fpu_interrupt_w ;
					     end
				       else
				         begin
					       ready_out <= ready_out;
					     end
				     end 
			     end
		      end
	end
		else
		  begin
			count_out 	 	 <= 5'b00000;
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
		delayed_ready <= ready_out ;
	  end
  end
  
  
 always @ (*)
  begin
    data_w 				   = 32'h0000_0000 ;
	simd_output 		   = 32'h0000_0000 ;
	operand_a_0_w_en       = 1'b0		   ;
	operand_a_1_w_en       = 1'b0		   ;
	operand_a_2_w_en       = 1'b0		   ;
	operand_a_3_w_en       = 1'b0		   ;
	operand_a_4_w_en       = 1'b0		   ;
	operand_a_5_w_en       = 1'b0		   ;
	operand_a_6_w_en       = 1'b0		   ;
	operand_a_7_w_en       = 1'b0		   ;
	operand_a_8_w_en       = 1'b0		   ;
	operand_a_9_w_en       = 1'b0		   ;
	operand_a_10_w_en      = 1'b0		   ;
	operand_a_11_w_en      = 1'b0		   ;
	operand_a_12_w_en      = 1'b0		   ;
	operand_a_13_w_en      = 1'b0		   ;
	operand_a_14_w_en      = 1'b0		   ;
	operand_a_15_w_en      = 1'b0		   ;
	operand_b_0_w_en       = 1'b0		   ;
	operand_b_1_w_en       = 1'b0		   ;
	operand_b_2_w_en       = 1'b0		   ;
	operand_b_3_w_en       = 1'b0		   ;
	operand_b_4_w_en       = 1'b0		   ;
	operand_b_5_w_en       = 1'b0		   ;
	operand_b_6_w_en       = 1'b0		   ;
	operand_b_7_w_en       = 1'b0		   ;
	operand_b_8_w_en       = 1'b0		   ;
	operand_b_9_w_en       = 1'b0		   ;
	operand_b_10_w_en      = 1'b0		   ;
	operand_b_11_w_en      = 1'b0		   ;
	operand_b_12_w_en      = 1'b0		   ;
	operand_b_13_w_en      = 1'b0		   ;
	operand_b_14_w_en      = 1'b0		   ;
	operand_b_15_w_en      = 1'b0		   ;
	operand_c_0_w_en       = 1'b0		   ;
	operand_c_1_w_en       = 1'b0		   ;
	operand_c_2_w_en       = 1'b0		   ;
	operand_c_3_w_en       = 1'b0		   ;
	operand_c_4_w_en       = 1'b0		   ;
	operand_c_5_w_en       = 1'b0		   ;
	operand_c_6_w_en       = 1'b0		   ;
	operand_c_7_w_en       = 1'b0		   ;
	operand_c_8_w_en       = 1'b0		   ;
	operand_c_9_w_en       = 1'b0		   ;
	operand_c_10_w_en      = 1'b0		   ;
	operand_c_11_w_en      = 1'b0		   ;
	operand_c_12_w_en      = 1'b0		   ;
	operand_c_13_w_en      = 1'b0		   ;
	operand_c_14_w_en      = 1'b0		   ;
	operand_c_15_w_en      = 1'b0		   ;
	
	case (sw_address)
	  OPERAND_A_0			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_0_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_1			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_1_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_2			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_2_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_3			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_3_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_4			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_4_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_5			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_5_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_6			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_6_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_7			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_7_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_8			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_8_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_9			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_9_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_10			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_10_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_11			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_11_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end	
	  OPERAND_A_12			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_12_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_13			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_13_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_14			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_14_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_A_15			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_a_15_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end							   
	  OPERAND_B_0			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_0_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_1			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_1_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_2			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_2_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_3			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_3_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_4			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_4_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_5			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_5_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_6			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_6_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_7			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_7_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_8			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_8_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_9			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_9_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_10			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_10_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_11			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_11_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end	
	  OPERAND_B_12			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_12_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_13			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_13_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_14			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_14_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_B_15			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_b_15_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end  
	  OPERAND_C_0			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_0_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_1			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_1_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_2			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_2_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_3			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_3_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_4			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_4_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_5			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_5_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_6			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_6_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_7			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_7_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_8			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_8_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_9			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_9_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_10			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_10_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_11			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_11_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end	
	  OPERAND_C_12			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_12_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_13			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_13_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_14			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_14_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end
	  OPERAND_C_15			:  begin
							     if(sw_write_en && !sw_read_en)
								   begin
								     operand_c_15_w_en = 1'b1 ;
								     data_w = sw_datain ;
								   end
							   end		
	  OUTPUT_0	 			:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_0 ;
								   end
							   end
	  OUTPUT_1		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_1 ;
								   end
							   end
	  OUTPUT_2		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_2 ;
								   end
							   end
	  OUTPUT_3		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_3 ;
								   end
							   end
	  OUTPUT_4		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_4 ;
								   end
							   end
	  OUTPUT_5		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_5 ;
								   end
							   end
	  OUTPUT_6		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_6 ;
								   end
							   end
	  OUTPUT_7		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_7 ;
								   end
							   end
	  OUTPUT_8		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_8 ;
								   end
							   end
	  OUTPUT_9		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_9 ;
								   end
							   end
	  OUTPUT_10		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_10 ;
								   end
							   end
	  OUTPUT_11		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_11 ;
								   end
							   end
	  OUTPUT_12		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_12 ;
								   end
							   end
	  OUTPUT_13		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_13 ;
								   end
							   end
	  OUTPUT_14		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_14 ;
								   end
							   end
	  OUTPUT_15		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = output_15 ;
								   end
							   end							   
	  FLAGS_1		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = { 16'h0000 , 1'b0 , flags_15[3] , flags_14[3] , flags_13[3] , flags_12[3] ,flags_11[3]
																	 , flags_10[3] , flags_9[3]  , flags_8[3]  , flags_7[3]  ,flags_6[3]
																	 , flags_5[3]  , flags_4[3]  , flags_3[3]  , flags_2[3]  ,flags_1[3] };
								   end
							   end		
	  FLAGS_2		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = { 1'b0 , flags_15[1] , flags_14[1] , flags_13[1] , flags_12[1] ,flags_11[1]
													      , flags_10[1] , flags_9[1]  , flags_8[1]  , flags_7[1]  ,flags_6[1]
														  , flags_5[1]  , flags_4[1]  , flags_3[1]  , flags_2[1]  ,flags_1[1] 
												   , 1'b0 , flags_15[2] , flags_14[2] , flags_13[2] , flags_12[2] ,flags_11[2]
														  , flags_10[2] , flags_9[2]  , flags_8[2]  , flags_7[2]  ,flags_6[2]
														  , flags_5[2]  , flags_4[2]  , flags_3[2]  , flags_2[2]  ,flags_1[2] };														  
								   end
							   end	
	  FLAGS_3		    	:  begin
							     if(!sw_write_en && sw_read_en)
								   begin
								     simd_output = { 16'h0000 , 1'b0 , flags_15[0] , flags_14[0] , flags_13[0] , flags_12[0] ,flags_11[0]
																	 , flags_10[0] , flags_9[0]  , flags_8[0]  , flags_7[0]  ,flags_6[0]
																	 , flags_5[0]  , flags_4[0]  , flags_3[0]  , flags_2[0]  ,flags_1[0] };
								   end
							   end								   
    endcase
  end

always @(*)
  begin
	simd_operand_a = operand_a_0 ;
	simd_operand_b = operand_b_0 ;
    simd_operand_c = operand_c_0 ;  
    case (count)
	  5'h01  :  begin
				  simd_operand_a = operand_a_0 ;
				  simd_operand_b = operand_b_0 ;
				  simd_operand_c = operand_c_0 ;
	            end
	  5'h02   :  begin
				  simd_operand_a = operand_a_1 ;
				  simd_operand_b = operand_b_1 ;
				  simd_operand_c = operand_c_1 ;
	            end				
	  5'h03   :  begin
				  simd_operand_a = operand_a_2 ;
				  simd_operand_b = operand_b_2 ;
				  simd_operand_c = operand_c_2 ;
	            end	
	  5'h04   :  begin
				  simd_operand_a = operand_a_3 ;
				  simd_operand_b = operand_b_3 ;
				  simd_operand_c = operand_c_3 ;
	            end
	  5'h05   :  begin
				  simd_operand_a = operand_a_4 ;
				  simd_operand_b = operand_b_4 ;
				  simd_operand_c = operand_c_4 ;
	            end				
	  5'h06   :  begin
				  simd_operand_a = operand_a_5 ;
				  simd_operand_b = operand_b_5 ;
				  simd_operand_c = operand_c_5 ;
	            end
	  5'h07   :  begin
				  simd_operand_a = operand_a_6 ;
				  simd_operand_b = operand_b_6 ;
				  simd_operand_c = operand_c_6 ;
	            end
	  5'h08   :  begin
				  simd_operand_a = operand_a_7 ;
				  simd_operand_b = operand_b_7 ;
				  simd_operand_c = operand_c_7 ;
	            end
	  5'h09   :  begin
				  simd_operand_a = operand_a_8 ;
				  simd_operand_b = operand_b_8 ;
				  simd_operand_c = operand_c_8 ;
	            end
	  5'h0A   :  begin
				  simd_operand_a = operand_a_9 ;
				  simd_operand_b = operand_b_9 ;
				  simd_operand_c = operand_c_9 ;
	            end	
	  5'h0B   :  begin
				  simd_operand_a = operand_a_10 ;
				  simd_operand_b = operand_b_10 ;
				  simd_operand_c = operand_c_10 ;
	            end	
	  5'h0C   :  begin
				  simd_operand_a = operand_a_11 ;
				  simd_operand_b = operand_b_11 ;
				  simd_operand_c = operand_c_11 ;
	            end	
	  5'h0D   :  begin
				  simd_operand_a = operand_a_12 ;
				  simd_operand_b = operand_b_12 ;
				  simd_operand_c = operand_c_12 ;
	            end	
	  5'h0E   :  begin
				  simd_operand_a = operand_a_13 ;
				  simd_operand_b = operand_b_13 ;
				  simd_operand_c = operand_c_13 ;
	            end	
	  5'h0F   :  begin
				  simd_operand_a = operand_a_14 ;
				  simd_operand_b = operand_b_14 ;
				  simd_operand_c = operand_c_14 ;
	            end	
	  5'h10   :  begin
				  simd_operand_a = operand_a_15 ;
				  simd_operand_b = operand_b_15 ;
				  simd_operand_c = operand_c_15 ;
	            end					
				
	endcase

  end  

 assign simd_ready    = ready_out ;
 assign simd_flags    = flags_0   ;
endmodule
`resetall