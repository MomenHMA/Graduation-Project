`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:03:53 03/24/2021 
// Design Name: 
// Module Name:    Number_Extractor 
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
module Number_Extractor(
    input  wire [31:0] operand1,
    input  wire [31:0] operand2,
    output wire [7:0]  E1,
    output wire [7:0]  E2,
    output wire [23:0] M1,
    output wire [23:0] M2,
    output wire        S1,
    output wire        S2
    );
assign S1=operand1 [31];
assign S2=operand2 [31];
assign E1=operand1 [30:23];
assign E2=operand2 [30:23];
assign M1[22:0]=operand1 [22:0];
assign M1[23]= (E1==0) ? 1'b0  : 1'b1;
assign M2[22:0]=operand2 [22:0];
assign M2[23] = (E2==0) ? 1'b0  : 1'b1;
endmodule
`resetall