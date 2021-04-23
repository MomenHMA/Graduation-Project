`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:15:29 04/16/2021 
// Design Name: 
// Module Name:    Single_Precision_Multiplier 
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
module Single_Precision_Multiplier(
    input  wire [31:0] operand1,
    input  wire [31:0] operand2,
    output wire [31:0] Result,
    output wire [3:0]  Flags
    );
	 
wire [7:0]  E1;
wire [7:0]  E2;
wire [23:0] M1;
wire [23:0] M2;
wire        S1;
wire        S2;
wire [7:0]  Er;
wire        overflow1;
wire        underflow1;	
wire [47:0] Mr;
wire [23:0] Mr_out;
wire [7:0]  Er_norm;
wire [2:0]  GRS_out;
wire        overflow2;
wire        underflow2;
wire [23:0] Mr_round;
wire [7:0]  Er_round;
wire        overflow3;
wire [31:0] Result_converted; 
wire        inexact;
wire        overflow;
	 
Number_Extractor_mult Number_Extractor_mult (
		.operand1(operand1), 
		.operand2(operand2), 
		.E1(E1), 
		.E2(E2), 
		.M1(M1), 
		.M2(M2), 
		.S1(S1), 
		.S2(S2)
	);

Exponant_Addition Exponant_Addition (
		.E1(E1), 
		.E2(E2), 
		.Er(Er), 
		.overflow1(overflow1), 
		.underflow1(underflow1)
	);	

binary_multiplier binary_multiplier (
		.M1(M1), 
		.M2(M2), 
		.Mr(Mr)
	);	

normalization normalization (
		.Mr(Mr), 
		.Er(Er), 
		.underflow1(underflow1), 
		.Mr_out(Mr_out), 
		.Er_norm(Er_norm), 
		.GRS_out(GRS_out), 
		.overflow2(overflow2), 
		.underflow2(underflow2)
	);

Rounding Rounding (
		.Mr_norm(Mr_out), 
		.Er_norm(Er_norm), 
		.GRS(GRS_out[1]), 
		.Mr_round(Mr_round), 
		.Er_round(Er_round),
      .inexact(inexact),		
		.overflow3(overflow3)
	);

combining_MUL combining_MUL(
      .Mr_round(Mr_round[22:0]),
      .Er_round(Er_round),
      .S(S1 ^ S2),
		.overflow(overflow1 || overflow1 || overflow3),
		.Result(Result_converted)
   );	

assign overflow = overflow1 || overflow1 || overflow3;	
assign Flags[3]= ((operand1[30:23]==8'b1111_1111 && operand1[22:0] == 23'b0 && operand2 == 31'b0) || (operand2[30:23]==8'b1111_1111 && operand2[22:0] == 23'b0 && operand1 == 31'b0) || (operand1[30:23]==8'b1111_1111 || operand2[30:23]==8'b1111_1111))? 1'b1 : 1'b0;
assign Flags[2:0]={ overflow ,underflow2, (inexact||underflow2||overflow)};
assign Result= (Flags[3]==1'b1)? 32'b11111111_11111111_11111111_11111111 : Result_converted;		

endmodule
`resetall
