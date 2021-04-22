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
module rounding(
    input  wire [27:0] Mr,
    input  wire [11:0] GRS,
	 input  wire [3:0]  cout,
    output reg  [27:0] Mr_result,
	 output reg         Inexact,
	 output reg  [3:0]  C
    );
	 
parameter  [27:0] one=28'b0000_0000_0000_0000_0000_0000_0001;	 
wire [3:0] carry;
wire [27:0] result;
reg [11:0] GRS_norm;

BCD_adder BCD_adder (		.M1(Mr), 		.M2(one), 		.Mr(result), 		.carry(carry) 	                   );							 
	 
always@(*)     
begin
    if (cout == 4'b0001)
	 begin
		GRS_norm = {Mr[3:0],GRS[11:4]};
	 end
	 else
	 begin
	   GRS_norm = GRS;
	 end
	 if(GRS_norm[7:4]>=5)//round bit
       begin
         Mr_result=result;
         C=carry+cout;	
         Inexact = 1'b1;			
       end
	 else
	    begin
         Mr_result=Mr;
		   C=cout;
		   Inexact = 1'b0;
       end	
 end
  
endmodule
`resetall 