`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    17:35:44 04/04/2021 
// Design Name: 
// Module Name:    Exponant_Addition 
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
module Exponant_Addition(
    input  wire [7:0] E1,
    input  wire [7:0] E2,
    output wire [7:0] Er,
	 output wire overflow1, //hy2ollak en el exponant ya2emma ba2a 9 bits aw enno wasal 8'b1111_1111 
	 output wire underflow1 //hy2ollak en el exponant bl -ve m7tag ta5odlo el 2's complement
    );
wire carry;	 
assign {carry,Er}=( E1!=8'b0 && E2!=8'b0  )?  E1+E2-127 : (E1==0 && E2==0)? E1+E2-125 : E1+E2-126 ;
assign overflow1=  ( ( (carry==1'b1)   || (Er ==8'b1111_1111) ) && (E1+E2>127) )? 1'b1:1'b0;//the second condition because Er is unsigne number so we can have overflow and underflow which is not correct;
assign underflow1= ( (E1+E2 <127) || ((E1+E2 <126)&&( (E1!=0 &&E2==0 )|| (E1==0 &&E2!=0 )))   )?    1'b1:1'b0;  
endmodule
`resetall
