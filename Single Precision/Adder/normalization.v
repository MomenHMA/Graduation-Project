`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    20:15:49 03/27/2021 
// Design Name: 
// Module Name:    normalization 
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
module normalization(
    input wire [24:0] Mr,
    input wire [7:0] Er,
    input wire [2:0] GRS,
    output reg [7:0] Er_norm,
    output reg [23:0] Mr_norm,
    output reg [2:0] GRS_norm,
	 output reg overflow
    );
	 
	 
always@(*)
  begin
    if(Er==8'b0)
	    begin
		   Mr_norm=Mr[23:0];
			GRS_norm=GRS;
			overflow=1'b0;
		   if(Mr[23]==1'b1)
			   begin
				Er_norm=8'b1;
				end
			else
           begin
			  Er_norm=Er;
           end			  
		 end
	else
      begin
		if(Mr[24]==1'b1)
		    begin
			 Mr_norm=Mr[24:1];
			 Er_norm=Er+1;
			 if(Er==8'b1111_1110)
			   begin
				overflow=1'b1;
				end
			 else 
			      begin
				overflow=1'b0;
	            end
			 GRS_norm={Mr[0],GRS[2],|GRS[1:0]};
			 end
		else
          begin
          Mr_norm=Mr[23:0];
			 Er_norm=Er;
			 GRS_norm=GRS;
			 overflow=1'b0;
	   end			 
      end		
  end	 
endmodule
`resetall
