`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:52:20 03/27/2021 
// Design Name: 
// Module Name:    single_percision_adder 
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
module single_percision_adder(
    input  wire  [31:0] operand1,
    input  wire  [31:0] operand2,
    output wire [31:0] Result,
    output wire [3:0]  flags
    );

wire [7:0]  E1;
wire [7:0]  E2;
wire [23:0] M1;
wire [23:0] M2;
wire        S1;
wire        S2;
wire        Greater;
wire [7:0]  Difference;
wire [7:0]  Er;
wire [47:0] M1_new;
wire [47:0] M2_new;
wire [2:0]  GRS;
wire [24:0] Mr;
wire [23:0] Mr_norm;
wire [7:0]  Er_norm;
wire        overflow;
wire [2:0]  GRS_norm;
wire [23:0] Mr_round;
wire [7:0]  Er_round;
wire        overflow_round;
wire        inexact;
wire [31:0] Result_converted;



	Number_Extractor Number_Extractor (
		.operand1(operand1), 
		.operand2(operand2), 
		.E1(E1), 
		.E2(E2), 
		.M1(M1), 
		.M2(M2), 
		.S1(S1), 
		.S2(S2)
	);
	
	
		binary_subtractor binary_subtractor(
		.E1(E1), 
		.E2(E2), 
		.Greater(Greater), 
		.Difference(Difference), 
		.Er(Er)
	);


	significant_allignment significant_allignment (
		.E1(E1), 
		.E2(E2), 
		.M1(M1), 
		.M2(M2), 
		.Difference(Difference), 
		.Greater(Greater), 
		.M1_new(M1_new), 
		.M2_new(M2_new),
		.GRS(GRS)
	);

   Adder Adder (
	.M1(M1_new[47:24]),
	.M2(M2_new[47:24]),
	.Mr(Mr)
   );
	
normalization normalization(
		.Mr(Mr), 
		.Er(Er), 
		.GRS(GRS), 
		.Er_norm(Er_norm), 
		.Mr_norm(Mr_norm), 
		.GRS_norm(GRS_norm), 
		.overflow(overflow)
	);


	Rounding Rounding (
		.GRS_norm(GRS_norm), 
		.Mr_norm(Mr_norm), 
		.Er_norm(Er_norm), 
		.overflow_norm(overflow), 
		.Mr_round(Mr_round), 
		.Er_round(Er_round), 
		.overflow_round(overflow_round),
		.inexact(inexact)
	);
 
  combining combining(
      .Mr_round(Mr_round[22:0]),
      .Er_round(Er_round),
      .S(S1),
		.overflow(overflow_round),
		.Result(Result_converted)
   );
	
assign flags[3]= ((operand1[30:23]==8'b1111_1111 && |operand1[22:0]==1'b1 ) || (operand2[30:23]==8'b1111_1111 && |operand2[22:0]==1'b1 ))? 1'b1 : 1'b0;
assign flags[2:0]={ overflow_round ,1'b0, (inexact||overflow_round)};
assign Result= (flags[3]==1'b1)? 32'b11111111_11111111_11111111_11111111 : Result_converted;	

endmodule
`resetall

