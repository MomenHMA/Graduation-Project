`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:23:47 03/24/2021 
// Design Name: 
// Module Name:    binary_subtractor 
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
module binary_subtractor(
    input wire  [7:0] E1,
    input wire  [7:0] E2,
    output wire       Greater,
    output reg  [7:0] Difference,
    output wire [7:0] Er
    );
assign Greater = (E1>=E2) ? 1'b1  : 1'b0;
assign Er      = (E1>=E2) ? E1    : E2;


always@(*)
 begin
   if(E1>=E2)
	  begin
	  Difference=E1-E2;
	  end
   else
     begin
	  Difference=E2-E1;
     end	  
 end


endmodule
`resetall