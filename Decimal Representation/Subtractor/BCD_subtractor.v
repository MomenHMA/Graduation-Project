`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:02:47 02/20/2021 
// Design Name: 
// Module Name:    BCD_subtractor 
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
module BCD_subtractor(
    input   [27:0] M1,
    input   [27:0] M2,
	 input   [8:0] GRS,
    output  [27:0] M_result,
	 output         sign
    );
localparam  one = 28'b0000_0000_0000_0000_0000_0000_0001;  
 
wire [27:0] M2_tens_comp;
wire [27:0] temp;
wire [27:0] temp_tens_comp;
wire [3:0]  first_carry;
wire [27:0] one_comp;
wire [27:0] Mr;
wire [27:0] Mr_temp;
wire [27:0] Mr_temp_comp;
wire [27:0] Mr_result;
wire [3:0]  second_carry;
wire        first_sign;
	
	Tens_comp Tens_comp1 
	(
		.operand(M2), 
		.tens_comp(M2_tens_comp)
   );
	
	Tens_comp Tens_comp2 
	(
		.operand(one), 
		.tens_comp(one_comp)
   );
	
  BCD_adder BCD_adder1 
  (
		.M1(M1), 
		.M2(M2_tens_comp), 
		.Mr(temp), 
		.carry(first_carry) 
	);
	
	Tens_comp Tens_comp3 
	(
		.operand(temp), 
		.tens_comp(temp_tens_comp)
   );

assign Mr = ( (first_carry==4'b0000) && (M2 !=28'b0) )? temp_tens_comp : temp; 
assign first_sign = (M2==28'b0)? (first_carry[0]) : ~(first_carry[0]);
  
  BCD_adder BCD_adder2 
  (
		.M1(Mr), 
		.M2(one_comp), 
		.Mr(Mr_temp), 
		.carry(second_carry) 
	);
	
	Tens_comp Tens_comp4 
	(
		.operand(Mr_temp), 
		.tens_comp(Mr_temp_comp)
   );
	
assign Mr_result =  (second_carry==4'b0000)? Mr_temp_comp : Mr_temp; 	
assign M_result =  (GRS == 9'b0) ? Mr : Mr_result; 	
	
assign sign =  (Mr == 28'b0 && |GRS == 1'b1) ? 1'b1 : first_sign ; 	

endmodule
