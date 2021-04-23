`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    18:43:33 03/24/2021 
// Design Name: 
// Module Name:    significant_allignment 
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
module significant_allignment(
    input wire [7:0]  E1,
    input wire [7:0]  E2,
    input wire [23:0] M1,
    input wire [23:0] M2,
    input wire [7:0]  Difference,
    input wire        Greater,
    output reg [47:0] M1_new,
    output reg [47:0] M2_new,
	 output reg [2:0]  GRS
    );
always@(*)
  begin
    if( E1==0 && E2==0 ) //case1 2 subnormal numbers or 2 equal numbers
	    begin
		 M1_new={M1,24'b0};
		 M2_new={M2,24'b0};
		 GRS=3'b0;
		 end
   else if(E1!=0 && E2!=0)  //case 2 normal numbers not equal exponent 
		   begin
			  if(Greater==1)
			     begin
				  M2_new={M2,24'b0};
				  M2_new=M2_new>>(Difference);
              M1_new={M1,24'b0};
              GRS={M2_new[23],M2_new[22],|M2_new[21:0]};
          				  
				  end
			  
			  else 
			      begin
					M1_new={M1,24'b0};
					M1_new=M1_new>>(Difference);
               M2_new={M2,24'b0};
               GRS={M1_new[23],M1_new[22],|M1_new[21:0]};
					end
		 end
		 
		 else if(E1!=0 && E2==0) //case 3 normal + subnormal 
		      begin
				  	M2_new={M2,24'b0};
               M2_new=M2_new>>(Difference-1);
               M1_new={M1,24'b0};
				   GRS={M2_new[23],M2_new[22],|M2_new[21:0]};          				  				
				end
				
		else if(E1==0 && E2!=0) //case 3 normal + subnormal 
		      begin
				  M1_new={M1,24'b0};
              M1_new=M1_new>>(Difference-1);
              M2_new={M2,24'b0};
              GRS={M1_new[23],M1_new[22],|M1_new[21:0]};
            				  				
				end				
		else 
		     begin
			    M1_new = {M1,24'b0};
				 M2_new = {M2,24'b0};
				 GRS=3'b0;
			  end
end

endmodule
`resetall
