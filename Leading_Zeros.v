`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    22:10:54 03/22/2021 
// Design Name: 
// Module Name:    Leading_Zeros 
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
module Leading_Zeros(
    input  wire [7:0]  E1,
    input  wire [7:0]  E2,
    input  wire [27:0] M1,
    input  wire [27:0] M2,
    output reg  [7:0]  E1_new,
    output reg  [7:0]  E2_new,
    output reg  [27:0] M1_new,
    output reg  [27:0] M2_new
    );

integer count1;
integer count2;

always@(*)
 begin
   casex(M1)
	28'b0000_0000_0000_0000_0000_0000_XXXX: count1 = 6;
	28'b0000_0000_0000_0000_0000_XXXX_XXXX: count1 = 5;
   28'b0000_0000_0000_0000_XXXX_XXXX_XXXX: count1 = 4;
   28'b0000_0000_0000_XXXX_XXXX_XXXX_XXXX: count1 = 3;
   28'b0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX: count1 = 2;	
	28'b0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: count1 = 1;
	default                               : count1 = 0;
	endcase
 end
 
always@(*) 
 begin
   if (E1 >= count1)
	  begin
	    M1_new = M1<<count1*4;
		 E1_new = E1 - count1;
	  end
	else
	 begin
	   M1_new = M1<<E1*4;
	   E1_new = 7'b0;
	 end
 end
 
 always@(*)
 begin
   casex(M2)
	28'b0000_0000_0000_0000_0000_0000_XXXX: count2 = 6;
	28'b0000_0000_0000_0000_0000_XXXX_XXXX: count2 = 5;
   28'b0000_0000_0000_0000_XXXX_XXXX_XXXX: count2 = 4;
   28'b0000_0000_0000_XXXX_XXXX_XXXX_XXXX: count2 = 3;
   28'b0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX: count2 = 2;	
	28'b0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: count2 = 1;
	default                               : count2 = 0;
	endcase
 end
 
always@(*) 
 begin
   if (E2 >= count2)
	  begin
	    M2_new = M2<<count2*4;
		 E2_new = E2 - count2;
	  end
	else
	 begin
	   M2_new = M2<<E2*4;
	   E2_new = 7'b0;
	 end
 end
endmodule
`resetall