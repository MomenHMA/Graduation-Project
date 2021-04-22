`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:11:51 02/03/2021 
// Design Name: 
// Module Name:    conversion 
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
module operand_conversion(
    input wire [31:0] operand1,
	 input wire [31:0] operand2,
    output wire       S1,
    output reg [7:0]  E1,
    output reg [27:0] M1,
	 output wire       S2,
    output reg [7:0]  E2,
    output reg [27:0] M2
    );
	 
assign S1 = operand1[31];
assign S2 = operand2[31];

always@(*)
 begin
  if (operand1[30:29] == 2'b11)
    begin
	   E1 = {operand1[28:27],operand1[25:20]};
		M1[27:24] = {3'b100,operand1[26]}; 
	 end
  else
    begin
	   E1 = {operand1[30:29],operand1[25:20]};
		M1[27:24] = {1'b0,operand1[28:26]}; 
	 end
 end
 
always@(*)
 begin
   casex(operand1[19:10])
	10'bXXX_XXX_0_XXX : M1[23:12]={1'b0,operand1[19:17], 1'b0,operand1[16:14], 1'b0,operand1[12:10]};
	10'bXXX_XXX_1_00X : M1[23:12]={1'b0,operand1[19:17], 1'b0,operand1[16:14], 3'b100,operand1[10]};
	10'bXXX_XXX_1_01X : M1[23:12]={1'b0,operand1[19:17], 3'b100,operand1[14], 1'b0,operand1[16:15],operand1[10]};
	10'bXXX_XXX_1_10X : M1[23:12]={3'b100,operand1[17], 1'b0,operand1[16:14], 1'b0,operand1[19:18],operand1[10]};
	10'bXXX_00X_1_11X : M1[23:12]={3'b100,operand1[17], 3'b100,operand1[14], 1'b0,operand1[19:18],operand1[10]};
	10'bXXX_01X_1_11X : M1[23:12]={3'b100,operand1[17], 1'b0,operand1[19:18],operand1[14], 3'b100,operand1[10]};
	10'bXXX_10X_1_11X : M1[23:12]={1'b0,operand1[19:17], 3'b100,operand1[14], 3'b100,operand1[10]};
	10'bXXX_11X_1_11X : M1[23:12]={3'b100,operand1[17], 3'b100,operand1[14], 3'b100,operand1[10]};
	endcase
 end 
 
always@(*)
 begin
   casex(operand1[9:0])
	10'bXXX_XXX_0_XXX : M1[11:0]={1'b0,operand1[9:7], 1'b0,operand1[6:4], 1'b0,operand1[2:0]};
	10'bXXX_XXX_1_00X : M1[11:0]={1'b0,operand1[9:7], 1'b0,operand1[6:4], 3'b100,operand1[0]};
	10'bXXX_XXX_1_01X : M1[11:0]={1'b0,operand1[9:7], 3'b100,operand1[4], 1'b0,operand1[6:5],operand1[0]};
	10'bXXX_XXX_1_10X : M1[11:0]={3'b100,operand1[7], 1'b0,operand1[6:4], 1'b0,operand1[9:8],operand1[0]};
	10'bXXX_00X_1_11X : M1[11:0]={3'b100,operand1[7], 3'b100,operand1[4], 1'b0,operand1[9:8],operand1[0]};
	10'bXXX_01X_1_11X : M1[11:0]={3'b100,operand1[7], 1'b0,operand1[9:8],operand1[4], 3'b100,operand1[0]};
	10'bXXX_10X_1_11X : M1[11:0]={1'b0,operand1[9:7], 3'b100,operand1[4], 3'b100,operand1[0]};
	10'bXXX_11X_1_11X : M1[11:0]={3'b100,operand1[7], 3'b100,operand1[4], 3'b100,operand1[0]};
	endcase
 end 
 
always@(*)
 begin
  if (operand2[30:29] == 2'b11)
    begin
	   E2 = {operand2[28:27],operand2[25:20]};
		M2[27:24] = {3'b100,operand2[26]}; 
	 end
  else
    begin
	   E2 = {operand2[30:29],operand2[25:20]};
		M2[27:24] = {1'b0,operand2[28:26]}; 
	 end
 end
 
always@(*)
 begin
   casex(operand2[19:10])
	10'bXXX_XXX_0_XXX : M2[23:12]={1'b0,operand2[19:17], 1'b0,operand2[16:14], 1'b0,operand2[12:10]};
	10'bXXX_XXX_1_00X : M2[23:12]={1'b0,operand2[19:17], 1'b0,operand2[16:14], 3'b100,operand2[10]};
	10'bXXX_XXX_1_01X : M2[23:12]={1'b0,operand2[19:17], 3'b100,operand2[14], 1'b0,operand2[16:15],operand2[10]};
	10'bXXX_XXX_1_10X : M2[23:12]={3'b100,operand2[17], 1'b0,operand2[16:14], 1'b0,operand2[19:18],operand2[10]};
	10'bXXX_00X_1_11X : M2[23:12]={3'b100,operand2[17], 3'b100,operand2[14], 1'b0,operand2[19:18],operand2[10]};
	10'bXXX_01X_1_11X : M2[23:12]={3'b100,operand2[17], 1'b0,operand2[19:18],operand2[14], 3'b100,operand2[10]};
	10'bXXX_10X_1_11X : M2[23:12]={1'b0,operand2[19:17], 3'b100,operand2[14], 3'b100,operand2[10]};
	10'bXXX_11X_1_11X : M2[23:12]={3'b100,operand2[17], 3'b100,operand2[14], 3'b100,operand2[10]};
	endcase
 end 
 
always@(*)
 begin
   casex(operand2[9:0])
	10'bXXX_XXX_0_XXX : M2[11:0]={1'b0,operand2[9:7], 1'b0,operand2[6:4], 1'b0,operand2[2:0]};
	10'bXXX_XXX_1_00X : M2[11:0]={1'b0,operand2[9:7], 1'b0,operand2[6:4], 3'b100,operand2[0]};
	10'bXXX_XXX_1_01X : M2[11:0]={1'b0,operand2[9:7], 3'b100,operand2[4], 1'b0,operand2[6:5],operand2[0]};
	10'bXXX_XXX_1_10X : M2[11:0]={3'b100,operand2[7], 1'b0,operand2[6:4], 1'b0,operand2[9:8],operand2[0]};
	10'bXXX_00X_1_11X : M2[11:0]={3'b100,operand2[7], 3'b100,operand2[4], 1'b0,operand2[9:8],operand2[0]};
	10'bXXX_01X_1_11X : M2[11:0]={3'b100,operand2[7], 1'b0,operand2[9:8],operand2[4], 3'b100,operand2[0]};
	10'bXXX_10X_1_11X : M2[11:0]={1'b0,operand2[9:7], 3'b100,operand2[4], 3'b100,operand2[0]};
	10'bXXX_11X_1_11X : M2[11:0]={3'b100,operand2[7], 3'b100,operand2[4], 3'b100,operand2[0]};
	endcase
 end  



endmodule
`resetall 