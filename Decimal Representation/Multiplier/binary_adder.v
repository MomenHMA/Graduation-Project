`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:19:14 02/10/2021 
// Design Name: 
// Module Name:    binary_adder 
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
module binary_adder(
    input  wire [7:0] E1,
    input  wire [7:0] E2,
    output wire [7:0] Er,
	 output wire       carry,
	 output wire       underflow
    );

	 
assign {carry,Er} = E1 + E2 - 8'd101;
assign underflow = E1+E2 >= 8'd101 ? 1'b0 : 1'b1;	 


endmodule
`resetall 
