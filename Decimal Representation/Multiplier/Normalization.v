`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:31:44 02/10/2021 
// Design Name: 
// Module Name:    Normalization 
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
module Normalization(
    input wire [55:0] Mr,
    input wire [7:0]  Er,
	 input wire        carry,
	 input wire        underflow,
    output reg [8:0]  Er_result,
    output reg [27:0] Mr_result,
    output reg [11:0] GRS,
	 output reg  underflow_r
    );
wire [7:0] E_comp;	 
assign E_comp=(~Er)+1'b1;

always @(*)
begin
  casex(Mr)
  56'b0000_0000_0000_0000_0000_0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											    begin
                                                                                     Mr_result = Mr[27:0]; 
																											    GRS = 12'b0;
																											    Er_result = {carry,Er};
																												 underflow_r=1'b0;
																											    end
																											  else
																											    begin
																												 Mr_result = Mr[27:0];
																												 GRS = 12'b0;
																												 Er_result=Er;
																												 underflow_r=1'b1;
																											    end
																									  end
  56'b0000_0000_0000_0000_0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											     begin
                                                                                      Mr_result = Mr[31:4]; 
																											     GRS[11:8] = Mr[3:0];
																												  GRS[7:0]=8'b0;
																											     Er_result = {carry,Er} + 3'b001;
																												  underflow_r=1'b0;
																												  end
																											  else
																											     begin
																												  if(E_comp >1)
																												     begin       
																												     Mr_result = Mr[31:4]; 
																											        GRS[11:8] = Mr[3:0];
																													  GRS[7:0]=8'b0;
																											        Er_result[7:0] = Er + 1'b1 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[31:4]; 
																											        GRS[11:8] = Mr[3:0];
																													  GRS[7:0]=8'b0;
																											        Er_result = 9'b0_0000_0000;
																													  underflow_r=1'b0;
																								                 end
																													end
																												

																									  end
  56'b0000_0000_0000_0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											    begin
                                                                                     Mr_result = Mr[35:8]; 
																											    GRS[11:4] = Mr[7:0];
																												 GRS[3:0]=4'b0;
																											    Er_result = {carry,Er} + 3'b010;
																												 underflow_r=1'b0;
																												 end 
																											 else  
																											 begin 
																												   if( E_comp > 2)
																												     begin       
																												     Mr_result = Mr[35:8]; 
																											        GRS[11:4] = Mr[7:0];
																													  GRS[3:0]=4'b0;
																											        Er_result[7:0] = Er + 2'b10 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[35:8]; 
																											        GRS[11:4] = Mr[7:0];
																													  GRS[3:0]=4'b0;
																											        Er_result[7:0] = Er + 2'b10 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b0;
																								                 end
																												 
                                                                                     end																												 
																									  end
  56'b0000_0000_0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											    begin
                                                                                     Mr_result = Mr[39:12]; 
																											    GRS = Mr[11:0];
																											    Er_result = {carry,Er} + 3'b011; 
                                                                                     underflow_r=1'b0;																												 
																												 end 
																											 else 
                                                                                     begin
                                                                                       if(E_comp > 3)
																												     begin       
																												     Mr_result = Mr[39:12]; 
																											        GRS= Mr[11:0];
																											        Er_result[7:0] = Er + 2'b11 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[39:12]; 
																											        GRS = Mr[11:0];
																											        Er_result[7:0] = Er + 2'b11 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b0;
																								                 end																												 
                                                                                     end																												 
																									  end
  56'b0000_0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											    begin
                                                                                     Mr_result = Mr[43:16]; 
																											    GRS = Mr[15:4];
																											    Er_result = {carry,Er} + 3'b100; 
																											    underflow_r=1'b0;
																												 end
																												else 
                                                                                     begin
                                                                                       if(E_comp >4)
																												     begin       
																												     Mr_result = Mr[43:16]; 
																											        GRS = Mr[15:4];
																											        Er_result[7:0] = Er + 3'b100 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[43:16]; 
																											        GRS = Mr[15:4];
																											        Er_result[7:0] = Er + 3'b100 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b0;
																								                 end																												 
                                                                                     end			
																									  end
  56'b0000_0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											    begin
                                                                                       Mr_result = Mr[47:20]; 
																											      GRS = Mr[19:8];
																											      Er_result = {carry,Er} + 3'b101;
																												   underflow_r=1'b0;
																												 end
                                                                                    else 
                                                                                     begin
                                                                                       if( E_comp > 5)
																												     begin       
																												     Mr_result = Mr[47:20]; 
																											        GRS= Mr[19:8];
																											        Er_result[7:0] = Er + 3'b101 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[47:20]; 
																											        GRS = Mr[19:8];
																											        Er_result[7:0] = Er + 3'b101 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b0;
																								                 end																												 
                                                                                     end																															
																									  end
  56'b0000_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX_XXXX: begin
                                                                                   if(underflow==1'b0)
																											    begin
                                                                                       Mr_result = Mr[51:24]; 
																											      GRS = Mr[23:12];
																											      Er_result = {carry,Er} + 3'b110;
																												   underflow_r=1'b0;
																												 end
																												else 
                                                                                     begin
                                                                                       if(E_comp > 6)
																												     begin       
																												     Mr_result = Mr[51:24]; 
																											        GRS= Mr[23:12];
																											        Er_result[7:0] = Er + 3'b110 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[51:24]; 
																											        GRS =       Mr[23:12];
																											        Er_result[7:0] = Er + 3'b110 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b0;
																								                 end																												 
                                                                                     end			
																									  end	
  default                                                                  : begin
                                                                                   if(underflow==1'b0)
																											   begin
                                                                                     Mr_result = Mr[55:28]; 
																											    GRS = Mr[27:16];
																											    Er_result = {carry,Er} + 3'b111;
																											    underflow_r=1'b0;
																												end
																												 else 
                                                                                     begin
                                                                                       if(E_comp > 7)
																												     begin       
																												     Mr_result = Mr[55:28]; 
																											        GRS = Mr[27:16];
																											    	  Er_result[7:0] = Er + 3'b111 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b1;
																												     end
																													else 
																													  begin
																													  Mr_result = Mr[55:28]; 
																											        GRS= Mr[27:16];
																											        Er_result[7:0] = Er + 3'b111 ;
																													  Er_result[8]=1'b0;
																													  underflow_r=1'b0;
																								                 end																												 
                                                                                     end			
																									  end																									  
  endcase

  
end

endmodule
`resetall 