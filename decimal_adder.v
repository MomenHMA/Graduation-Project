`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:12:46 02/06/2021 
// Design Name: 
// Module Name:    decimal_adder 
// Project Name: 
// Target Devices: 
// Tool versions: 
// Description: 
//
// Dependencies: 
//
// Revision: 
// Revision 0.01 - File Created
// Additional Comments: 
//
//////////////////////////////////////////////////////////////////////////////////
`default_nettype none
module decimal_adder(
    input wire [31:0]  operand1,
    input wire [31:0]  operand2,
    output wire  [31:0] Result,
    output wire  [3:0]  Flags
    );

wire        S1;
wire        S2;
wire [7:0]  E1;
wire [7:0]  E2;
wire [7:0]  Er;
wire [7:0]  Er_result;
wire [27:0] M1;
wire [27:0] M2;
wire [27:0] M1_norm;
wire [27:0] M2_norm;
wire [27:0] Mr;
wire [27:0] Mr_result;
wire [27:0] Mr_norm;
wire        Greater;
wire [7:0]  r;
wire [11:0] GRS_bits;
wire [3:0]  carry;
wire [3:0]  C;
wire        Inexact1;
wire        Inexact2;
wire        overflow;
wire        underflow;
wire [31:0] RESULT_converted;
wire        Invalid_operation;

operand_conversion operand_conversion (
		.operand1(operand1), 
		.operand2(operand2), 
		.S1      (S1), 
		.E1      (E1), 
		.M1      (M1),
		.S2      (S2), 
		.E2      (E2), 
		.M2      (M2)
	);
	
Binary_subtractor Binary_subtractor (
		.E1      (E1), 
		.E2      (E2),  
		.Er      (Er),
		.Greater (Greater),
		.r       (r)
	);

significand_allignment significand_allignment (
		.M1       (M1), 
		.M2       (M2), 
		.r        (r), 
		.Greater  (Greater), 
		.M1_norm  (M1_norm), 
		.M2_norm  (M2_norm), 
		.GRS_bits (GRS_bits)
	);
 
BCD_adder BCD_adder (
		.M1    (M1_norm), 
		.M2    (M2_norm), 
		.Mr    (Mr), 
		.carry (carry) 
	);
	
rounding rounding (
		.Mr        (Mr), 
		.GRS       (GRS_bits), 
		.cout      (carry), 
		.Mr_result (Mr_result),
      .Inexact   (Inexact1),		
		.C         (C)
	);	
	
shift_and_normalization shift_and_normalization(
    .Mr        (Mr_result),
    .Er        (Er),
	 .carry     (C),
    .Mr_result (Mr_norm),
	 .overflow  (overflow),
	 .underflow (underflow),
	 .inexact   (Inexact2),
    .Er_result (Er_result)
    );
	 
conversion_to_decimal_format_representation conversion_to_decimal_format_representation (
		.S      (S1), 
		.E      (Er_result), 
		.M      (Mr_norm), 
		.RESULT (RESULT_converted)
	);

assign Invalid_operation = (operand1[30:20] == 11'b11111_100000 || operand2[30:20] == 11'b11111_100000) ? 1'b1 : 1'b0;
assign Flags = {Invalid_operation,overflow,underflow,(Inexact1 || Inexact2)};
assign Result = (Invalid_operation == 1'b1) ? 32'bX_11111_000000_XXXXXXXXXX_XXXXXXXXXX : RESULT_converted;	
	
/*  always @(*)	    
    begin
	   Result = RESULT_converted;
		Flags = {1'b0,overflow,underflow,(Inexact1 || Inexact2)};
	 end*/

endmodule
`resetall 