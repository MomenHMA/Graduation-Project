`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    15:37:18 04/14/2021 
// Design Name: 
// Module Name:    Rounding 
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
module Rounding(
    input  wire [23:0] Mr_norm,
    input  wire [7:0]  Er_norm,
    input  wire        GRS,
    output reg  [23:0] Mr_round,
    output reg  [7:0]  Er_round,
	 output reg         inexact,
    output reg         overflow3
    );

reg [24:0] Mr_temp; 	 
	 
always@(*)
begin
  if (GRS == 1'b1)
  begin
   Mr_temp = {1'b0, Mr_norm} + 1'b1;
	inexact = 1'b1;
  end
  else
  begin
   Mr_temp = {1'b0, Mr_norm};
	inexact = 1'b0;
  end
end

always@(*)
begin
  if (Er_norm == 8'b0)
  begin
    if(Mr_temp[23] == 1'b1)
	 begin
	   Mr_round = Mr_temp[23:0];
		Er_round = 8'b0000_0001;
	 end
	 else
	 begin
	   Mr_round = Mr_temp[23:0];
		Er_round = 8'b0000_0000;
	 end
   end
  else
  begin
   if (Mr_temp[24] == 1'b1)
   begin
      Mr_round = Mr_temp[24:1];
      Er_round = Er_norm + 1'b1;
   end
   else
   begin
     Mr_round = Mr_temp[23:0];
	  Er_round = Er_norm;
   end
  end
  
  if (Er_round > 8'b1111_1110)
  begin
    overflow3 = 1'b1;
  end
  else
  begin
    overflow3 = 1'b0;
  end
end


endmodule
`resetall