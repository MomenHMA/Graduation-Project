`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    00:05:57 02/03/2021 
// Design Name: 
// Module Name:    Binary_subbtractor 
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
module Binary_subtractor(
    input wire [7:0] E1,
    input wire [7:0] E2,
    output reg [7:0] Er,
	 output reg       Greater,
    output reg [7:0] r
    );
	 
reg       carry;
reg [7:0] E;
	
always @(*)
 begin
   if (E1 == 8'b0000_0000)
	 begin
	   Er = E2;
		Greater = 0;
		r = E2;
	 end
	if (E2 == 8'b0000_0000)
	begin
	  Er = E1;
	  Greater = 1;
	  r = E1;
	end
	else
	 begin
     E = ~E2 + 1;
     {carry,r} = E1 + E;
     if(carry == 1)
      begin
	    Er = E1;
	    Greater = 1;
	   end
     else
      begin
	    Er = E2;
	    r = ~r + 1;
	    Greater = 0;
	   end
   end 
  end

endmodule
`resetall 