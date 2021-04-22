`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:39:18 02/06/2021 
// Design Name: 
// Module Name:    shift_and_normalization 
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
module shift_and_normalization(
    input  wire [27:0] Mr,
    input  wire [7:0]  Er,
	 input  wire [3:0]  carry,
    output reg  [27:0] Mr_result,
	 output reg         overflow,
	 output reg         underflow,
	 output reg         inexact,
    output reg  [7:0]  Er_result
    );

always@(*)
begin
  if(carry==4'b0001)
      begin
		 Mr_result={carry,Mr[27:4]};
		 Er_result=Er+1;
		end
	else
      begin
		 Mr_result=Mr;
		 Er_result=Er;
      end
  if (Er_result >= 8'b1100_0000)	
  begin
    overflow = 1'b1;
	 inexact = 1'b1;
	 underflow = 1'b0;
	 //Er_result = 8'b11111111;
  end
  else
  begin
    overflow = 1'b0;
	 inexact = 1'b0;
	 underflow = 1'b0;
  end
end
endmodule
`resetall 