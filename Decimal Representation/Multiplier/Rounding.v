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
	 input  wire [8:0]  Er,
    input  wire underflow,	 
    output reg  [27:0] Mr_result,
	 output reg         Inexact,
	 output reg         overflow,
	 output reg         underflow_r,
	 output reg  [8:0]  Er_result
    );
	 
parameter  [27:0] one=28'b0000_0000_0000_0000_0000_0000_0001;	 
wire [3:0] carry;
wire [55:0] result;
wire [8:0] E_comp;						 
	 
BCD_adder BCD_adder (		.M1({28'b0, Mr}), 		.M2({28'b0, one}), 		.Mr(result), 		.carry(carry) 	                   );
							 
assign E_comp=(~Er)+1'b1;


always@(*)     
begin
	 if(GRS[7:4]>=5)//round bit
       begin
		   if (result[31:28] == 1)
			begin
           Mr_result=result[31:4];
			  if(underflow==1'b1)
			    begin
				   if(E_comp >1)
					  begin
					  Er_result=8'b0;
					  underflow_r=1'b1;
                 end
				   else
					  begin
					  Er_result=8'b0;
					  underflow_r=1'b0;
                 end						  					  
			     end
			  else
			    begin
			      Er_result = Er + 1'b1;
			      underflow_r=1'b0;
					end
			end
			else
			begin
			 Mr_result = result[27:0];
			 if (underflow == 1'b1)
          begin
             Er_result = 8'b0;
			 end
			 else
			 begin
			    Er_result = Er;
			 end
			 underflow_r=underflow;
			end
         Inexact = 1'b1;			
       end
	 else
	    begin
         Mr_result = Mr;
			 if (underflow == 1'b1)
          begin
             Er_result = 8'b0;
			 end
			 else
			 begin
			    Er_result = Er;
			 end
		   Inexact = 1'b0;
			underflow_r=underflow;

       end	
		 
if (Er_result >= 8'b1100_0000)
begin
 overflow = 1'b1;
 Inexact = 1'b1;
 Er_result = 9'b01100_0000;
end
else
begin
 overflow = 1'b0;
end

if(underflow==1'b1)
begin
Inexact=1'b1;
end

end   
endmodule
`resetall 