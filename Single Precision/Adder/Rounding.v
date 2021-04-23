`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:50:13 03/27/2021 
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
    input wire [2:0]  GRS_norm,
    input wire [23:0] Mr_norm,
    input wire [7:0]  Er_norm,
    input wire        overflow_norm,
    output reg [23:0] Mr_round,
    output reg [7:0]  Er_round,
    output reg        overflow_round,
	 output reg        inexact
    );
reg [24:0] Mr_temp;
always@(*)
     begin
       if(GRS_norm[1]==1'b1)
		    begin
			 Mr_temp=Mr_norm+1'b1;
			 inexact=1'b1;
			 end
		 else
          begin
			 Mr_temp=Mr_norm;
			 inexact=1'b0;
          end			 
     end

always@(*)
  begin
    if( Er_norm==8'b0 && overflow_norm!=1'b1)
	    begin
		   Mr_round=Mr_temp[23:0];
			overflow_round=1'b0;
			if(Mr_temp[23]==1'b1)
			   begin
				Er_round=8'b1;
				end
			else
           begin
			  Er_round=Er_norm;
           end			  
		 end
	else
      begin
		if(Mr_temp[24]==1'b1)
		    begin
			 Mr_round=Mr_temp[24:1];
			 Er_round=Er_norm+1;
			 if(Er_norm==8'b1111_1110)
			   begin
				overflow_round=1'b1;
				end
			 else 
			      begin
				overflow_round=overflow_norm;
	            end
			 end
		else
          begin
          Mr_round=Mr_temp[23:0];
			 Er_round=Er_norm;
			 overflow_round=overflow_norm;
	   end			 
      end		
  end	 	  

endmodule
`resetall

