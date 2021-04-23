`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:25:13 02/13/2021 
// Design Name: 
// Module Name:    Top_Module 
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
module Top_Module(
    input [31:0] operand1,
    input [31:0] operand2,
    output [31:0] RESULT,
	 output [3:0] flags //invalid,overflow,underflow,inexact 
    );
	 
wire S1;
wire S2;
wire [27:0] M1;
wire [27:0] M2;
wire [27:0] M1_new;
wire [27:0] M2_new;
wire [7:0] E1;
wire [7:0] E2;
wire [7:0] E1_new;
wire [7:0] E2_new;
wire [7:0] Er;
wire [55:0] Mr;
wire carry;
wire underflow;
wire underflow_r;
wire [11:0] GRS;
wire [8:0] Er_result;
wire [27:0] Mr_result;
wire [27:0] Mr_final_result;
wire [8:0] Er_final_result;
wire underflow_final_result;
wire overflow;
wire Inexact;
wire S;
reg Invalid_operation;
wire [31:0] RESULT_converted;

assign S=(S1^S2);

conversion conversion (
		.operand1(operand1), 
		.operand2(operand2), 
		.S1      (S1), 
		.E1      (E1), 
		.M1      (M1),
		.S2      (S2), 
		.E2      (E2), 
		.M2      (M2)
	);

Leading_zeros_mult Leading_zeros_mult (		.E1(E1), 		.E2(E2), 		.M1(M1), 		.M2(M2), 		.E1_new(E1_new), 		.E2_new(E2_new), 		.M1_new(M1_new), 		.M2_new(M2_new)	);

binary_adder binary_adder (
		.E1(E1_new), 
		.E2(E2_new), 
		.Er(Er),
		.carry(carry),
		.underflow(underflow)
	);


	BCD_multiplier BCD_multiplier (
		.M1(M1_new), 
		.M2(M2_new), 
		.Mr(Mr)
	);


Normalization Normalization (
		.Mr(Mr), 
		.Er(Er), 
		.carry(carry),
      .underflow(underflow),		
		.Er_result(Er_result), 
		.Mr_result(Mr_result), 
		.GRS(GRS),
		.underflow_r(underflow_r)
	);

rounding rounding (
		.Mr(Mr_result), 
		.GRS(GRS), 
		.Er(Er_result),
      .underflow(underflow_r),
      .underflow_r(underflow_final_result),		
		.Mr_result(Mr_final_result), 
		.Inexact(Inexact), 
		.overflow(overflow), 
		.Er_result(Er_final_result)
	);

conversion_to_decimal_format_representation conversion_to_decimal_format_representation (
		.S      (S), 
		.E      (Er_final_result[7:0]), 
		.M      (Mr_final_result), 
		.RESULT (RESULT_converted)
	);

assign flags={Invalid_operation,overflow,underflow_final_result,Inexact}; 
assign RESULT = (Invalid_operation == 1'b1) ? 32'bX_11111_000000_XXXXXXXXXX_XXXXXXXXXX : RESULT_converted;

always@(*)
 begin
   if (operand1[30:20] == 11'b11110000000 && operand2[28:26] == 3'b000 && operand2[19:0] == 20'b0)
   begin
      Invalid_operation = 1'b1;
   end
   else if (operand2[30:20] == 11'b11110000000 && operand1[28:26] == 3'b000 && operand1[19:0] == 20'b0)
   begin
      Invalid_operation = 1'b1;
    end
   else if (operand1[30:20] == 11'b11111_100000 || operand2[30:20] == 11'b11111_100000)
   begin
      Invalid_operation = 1'b1;
    end
   else
   begin
     Invalid_operation = 1'b0;
   end	
 end

endmodule
