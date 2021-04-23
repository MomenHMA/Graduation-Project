`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:05:29 02/20/2021 
// Design Name: 
// Module Name:    Tens_comp 
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
module Tens_comp(
    input [27:0] operand,
    output wire [27:0] tens_comp
    );

wire [27:0] temp ;
wire [3:0] carry;


assign temp[3:0]=4'b1001-operand[3:0];
assign temp[7:4]=4'b1001-operand[7:4];
assign temp[11:8]=4'b1001-operand[11:8];
assign temp[15:12]=4'b1001-operand[15:12];
assign temp[19:16]=4'b1001-operand[19:16];
assign temp[23:20]=4'b1001-operand[23:20];
assign temp[27:24]=4'b1001-operand[27:24];

  BCD_adder BCD_adder 
  (
		.M1(temp), 
		.M2(28'b0000_0000_0000_0000_0000_0000_0001), 
		.Mr(tens_comp), 
		.carry(carry) 
	);


endmodule
