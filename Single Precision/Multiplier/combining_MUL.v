`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:41:42 03/27/2021 
// Design Name: 
// Module Name:    combining 
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
module combining_MUL(
    input wire [22:0]  Mr_round,
    input wire [7:0]   Er_round,
    input wire         S,
	 input wire         overflow,
    output wire [31:0] Result
    );


assign Result[31]=S;
assign Result[30:23]=  (overflow==1'b1)? 8'b1111_1111 : Er_round;
assign Result[22:0]= (overflow==1'b1)?   22'b0 : Mr_round;
endmodule
`resetall


