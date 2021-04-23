`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:50:48 02/05/2021 
// Design Name: 
// Module Name:    rounding 
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
module rounding_subtraction(
    input  wire [27:0] Mr,
    input  wire [8:0] GRS,
    output reg  [27:0] Mr_result,
	 output reg         Inexact,
	 output reg  [3:0]  C
    );
	 
parameter  [27:0] one=28'b0000_0000_0000_0000_0000_0000_0001;	 
wire [3:0] carry;
wire [27:0] result;

BCD_adder BCD_adder (		.M1(Mr), 		.M2(one), 		.Mr(result), 		.carry(carry) 	                   );							 
	 
always@(*)     
begin
	 
	 if(((GRS[0] != 1'b0  && GRS[4:1] <= 4) || (GRS[0] == 1'b0  && GRS[4:1] <= 5)) && GRS[4:0] != 5'b0)//round bit
       begin
         Mr_result=result;
         C=carry;	
         Inexact = 1'b1;			
       end
	 else
	    begin
         Mr_result=Mr;
		   C=4'b0;
		   Inexact = 1'b0;
       end	
 end
  
endmodule
`resetall 