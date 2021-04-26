`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:53:31 03/22/2021 
// Design Name: 
// Module Name:    Modified_Operation 
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
module Modified_Operation(
    input  wire       fpu_operand_a_s,
    input  wire       fpu_operand_b_s,
    input  wire [1:0] fpu_operation,
    output wire [1:0] fpu_operation_modified
    ); 

assign fpu_operation_modified[1] = (fpu_operation[1] == 1'b1) ? 1'b1 : 1'b0;
assign fpu_operation_modified[0] = (fpu_operation[1] == 1'b1) ? 1'b0 : fpu_operation[0] ^ (fpu_operand_a_s ^ fpu_operand_b_s);

endmodule
`resetall