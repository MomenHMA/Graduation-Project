`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:25:48 02/20/2021 
// Design Name: 
// Module Name:    Decimal_subtractor 
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
module Decimal_subtractor(
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] Result,
    output [3:0] Flags
    );
wire        S1;
wire        S2;
wire [7:0]  E1;
wire [7:0]  E2;
wire [7:0]  E1_new;
wire [7:0]  E2_new;
wire [7:0]  Er;
wire [7:0]  Er_result;
wire [27:0] M1;
wire [27:0] M2;
wire [27:0] M1_new;
wire [27:0] M2_new;
wire [27:0] M1_norm;
wire [27:0] M2_norm;
wire [27:0] Mr;
wire [27:0] Mr_result;
wire [27:0] Mr_norm;
wire        Greater;
wire [7:0]  r;
wire [8:0] GRS_bits;
wire [3:0]  C;
wire        sign;
wire        Inexact1;
wire        Inexact2;
wire        overflow;
wire        underflow;
wire [31:0] RESULT_converted;
wire        Invalid_operation;

conversion_from_BCD conversion_from_BCD (
		.operand1(operand1), 
		.operand2(operand2), 
		.S1      (S1), 
		.E1      (E1), 
		.M1      (M1),
		.S2      (S2), 
		.E2      (E2), 
		.M2      (M2)
	);

Leading_zeros_sub Leading_zeros_sub (		.E1(E1), 		.E2(E2), 		.M1(M1), 		.M2(M2), 		.E1_new(E1_new), 		.E2_new(E2_new), 		.M1_new(M1_new), 		.M2_new(M2_new)	);

Binary_subtractor_subtraction Binary_subtractor_subtraction (
		.E1      (E1_new), 
		.E2      (E2_new),  
		.Er      (Er),
		.Greater (Greater),
		.r       (r)
	);

significand_allignment_subtraction significand_allignment_subtraction (
		.M1       (M1_new), 
		.M2       (M2_new), 
		.r        (r), 
		.Greater  (Greater), 
		.M1_norm  (M1_norm), 
		.M2_norm  (M2_norm), 
		.GRS_bits (GRS_bits)
	);	

	BCD_subtractor BCD_subtractor (
		.M1(M1_norm),	
		.M2(M2_norm),
      .GRS(GRS_bits),		
		.M_result(Mr), 
		.sign(sign)
	);
	
rounding_subtraction rounding_subtraction (
		.Mr        (Mr), 
		.GRS       (GRS_bits),  
		.Mr_result (Mr_result),
      .Inexact   (Inexact1),		
		.C         (C)
	);	
	
shift_and_normalization_subtraction shift_and_normalization_subtraction(
    .Mr        (Mr_result),
    .Er        (Er),
	 .carry     (C),
    .Mr_result (Mr_norm),
	 .overflow  (overflow),
	 .underflow (underflow),
	 .inexact   (Inexact2),
    .Er_result (Er_result)
    );
	

conversion_to_decimal_format_representation_subtraction conversion_to_decimal_format_representation_subtraction (
		.S      (S1^sign), 
		.E      (Er_result), 
		.M      (Mr_norm), 
		.RESULT (RESULT_converted)
	);	
	
assign Invalid_operation = (operand1[30:20] == 11'b11111_100000 || operand2[30:20] == 11'b11111_100000) ? 1'b1 : 1'b0;assign Flags = {Invalid_operation,overflow,underflow,(Inexact1 || Inexact2)};assign Result = (Invalid_operation == 1'b1) ? 32'bX_11111_000000_XXXXXXXXXX_XXXXXXXXXX : RESULT_converted;

endmodule
