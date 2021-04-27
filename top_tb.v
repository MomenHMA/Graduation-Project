`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   01:03:52 02/18/2021
// Design Name:   top
// Module Name:   F:/College Stuff/Year 4/Graduation Project/System/Binary adder/decimal_adder/decimal_adder/top_tb.v
// Project Name:  
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: top
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

module top_tb;

	// Inputs
	reg clk_tb;
	reg reset_n_tb;
	reg [31:0] sw_address_tb;
	reg sw_read_en_tb;
	reg sw_write_en_tb;
	reg [31:0] sw_datain_tb;

	// Outputs
	wire [31:0] sw_dataout_tb;
	wire fpu_fused_m_a_tb;
	wire fpu_simd_tb;
	wire [2:0] fpu_simd_no_op_tb;

	// Instantiate the Unit Under Test (UUT)
	top uut (
		.clk(clk_tb), 
		.reset_n(reset_n_tb), 
		.sw_address(sw_address_tb), 
		.sw_read_en(sw_read_en_tb), 
		.sw_write_en(sw_write_en_tb), 
		.sw_datain(sw_datain_tb), 
		.sw_dataout(sw_dataout_tb),  
		.fpu_fused_m_a(fpu_fused_m_a_tb), 
		.fpu_simd(fpu_simd_tb), 
		.fpu_simd_no_op(fpu_simd_no_op_tb)
	);
	
    always
      begin
        #(10/2.0) clk_tb = 1'b0;
        #(10 - 10/2.0) clk_tb = 1'b1;
      end	
	
	initial begin
		// Initialize Inputs
		clk_tb = 0;
		reset_n_tb = 0;
		sw_address_tb = 0;
		sw_read_en_tb = 0;
		sw_write_en_tb = 0;
		sw_datain_tb = 0;

		// Wait 100 ns for global reset to finish
		#100;
		reset_n_tb = 1'b1;
        sw_write_en_tb = 1'b1;
		repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end		
		sw_address_tb     = 32'h0000_0010;
		sw_datain_tb      = 32'b00100110010001001101001011100111;
		repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		sw_address_tb     = 32'h0000_0050;
		sw_datain_tb      = 32'b1010_0110_0001_0000_0101_1111_0101_0100;		  
	    repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		sw_address_tb     = 32'h0000_0000;
		sw_datain_tb      = 32'b0000_0000_0000_0000_0000_0000_0100_0110;
	    repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_write_en_tb = 1'b0;
		  sw_read_en_tb = 1'b0;
		repeat (2)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_read_en_tb = 1'b1;
		  sw_address_tb = 32'h0000_0130; // read output (takes 4 clk cycles )
		 repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
/* 		sw_read_en_tb = 1'b0;
		sw_write_en_tb = 1'b1;		
		sw_address_tb     = 32'h0000_0000;
		sw_datain_tb      = 32'h0000_0047; */
		sw_address_tb     = 32'h0000_0110;  // read status reg
		 repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_write_en_tb = 1'b1;
		  sw_read_en_tb = 1'b0;
		  sw_address_tb     = 32'h0000_0000;
		  sw_datain_tb      = 32'b0000_0000_0000_0000_0000_0000_0100_0111; //reset
		 repeat (4)
		  begin
		    @ ( posedge clk_tb );
		  end	
		  sw_write_en_tb = 1'b0;
		 repeat (2)
		  begin
		    @ ( posedge clk_tb );
		  end	
		  sw_write_en_tb = 1'b0; // read command reg to check that reset is zero after 4 clk cycles
		  sw_read_en_tb = 1'b1;
		  sw_address_tb     = 32'h0000_0000;	
		 repeat (3)
		  begin
		    @ ( posedge clk_tb );
		  end
		 reset_n_tb = 0;
		 repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end		 
		  reset_n_tb = 1;		
		repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		 
		  sw_write_en_tb = 1'b1;
		  sw_read_en_tb = 1'b0;	
		sw_address_tb     = 32'h0000_0010;
		sw_datain_tb      = 32'b00100110010001001101001011100111;

		sw_address_tb     = 32'h0000_0050;
		sw_datain_tb      = 32'b1010_0110_0001_0000_0101_1111_0101_0101;		  
	    repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		sw_address_tb     = 32'h0000_0000;
		sw_datain_tb      = 32'b0000_0000_0000_0000_0000_0000_0100_0100; // fpu_enable = 0
	    repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_write_en_tb = 1'b0;
		  sw_read_en_tb = 1'b0;
		repeat (2)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_read_en_tb = 1'b1;
		  sw_address_tb = 32'h0000_0130; // read output (takes 4 clk cycles )		
		repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_write_en_tb = 1'b1;
		  sw_read_en_tb = 1'b0;
		sw_address_tb     = 32'h0000_0000;
		sw_datain_tb      = 32'b0000_0000_0000_0000_0000_0000_0100_1110; // interrupt_enable = 1
	    repeat (1)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_write_en_tb = 1'b0;
		  sw_read_en_tb = 1'b1;
		  sw_address_tb = 32'h0000_0110; // read status_reg
		repeat (6)
		  begin
		    @ ( posedge clk_tb );
		  end
		  sw_read_en_tb = 1'b0;
		  sw_write_en_tb = 1'b1;
		  sw_address_tb = 32'h0000_0110; // read output (takes 4 clk cycles )  
		  sw_datain_tb      = sw_dataout_tb & 32'b1111_11111_11111_1111_1111_1111_1111_1110;
		// Add stimulus here
	end
      
endmodule

