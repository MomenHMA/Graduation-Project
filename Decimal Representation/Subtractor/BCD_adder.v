`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    19:23:02 02/02/2021 
// Design Name: 
// Module Name:    BCD_adder 
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
module BCD_adder(
    input wire [27:0] M1,
    input wire [27:0] M2,
    output reg [27:0] Mr,
    output reg [3:0]  carry
    );
integer       i;
	 
always@(*)
begin

{carry,Mr[3:0]}=M1[3:0]+M2[3:0];

if( {carry,Mr[3:0]} > 4'b1001 ) 
 begin
	{carry,Mr[3:0]}={carry,Mr[3:0]}+ 3'b110;
 end
 
for (i=4;i<28 ;i=i+4)
 begin
   {carry,Mr[i+:4]}=M1[i+:4]+M2[i+:4]+carry;
   if( {carry,Mr[i+:4]} >9 ) 
    begin
     {carry,Mr[i+:4]}={carry,Mr[i+:4]}+6;
    end   
 end



end

endmodule
`resetall 