`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:24:09 04/05/2021 
// Design Name: 
// Module Name:    binary_multiplier 
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

module binary_multiplier(
    input  wire [23:0] M1,
    input  wire [23:0] M2,
    output wire [47:0] Mr
    );
assign Mr=M1*M2;
endmodule
`resetall

