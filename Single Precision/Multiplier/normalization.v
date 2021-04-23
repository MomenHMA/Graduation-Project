`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:18:53 04/05/2021 
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
    input  wire  [47:0] Mr,
    input  wire  [7:0]  Er,
	 input  wire         underflow1,
    output reg   [23:0] Mr_out,
    output reg   [7:0]  Er_norm,
	 output reg   [2:0]  GRS_out,
    output reg         overflow2,
    output reg         underflow2
    );
integer position;
reg underflow1_new;
reg carry;
wire [7:0] Er_comp;
reg   [23:0] Mr_norm;
reg [47:0] Mr_temp;
assign Er_comp=(~Er)+1'b1;
reg   [2:0]  GRS;	 
always @(*)
    begin
	 
	   casex(Mr)
		48'b1XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX: begin
		                                                        Mr_norm = Mr[47:24];
																				  position = 0;
																				  GRS = { Mr[23:22],|Mr[21:0] };
		                                                      end
		48'b01XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[46:23];
																				  position = 1;
																				  GRS = { Mr[22:21],|Mr[20:0] };
		                                                      end
	   48'b001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[45:22];
																				  position = 2;
																				  GRS = { Mr[21:20],|Mr[19:0] };
		                                                      end
		48'b0001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[44:21];
																				  position = 3;
																				  GRS = { Mr[20:19],|Mr[18:0] };
		                                                      end
	   48'b00001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[43:20];
																				  position = 4;
																				  GRS = { Mr[19:18],|Mr[17:0] };
		                                                      end
	   48'b000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[42:19];
																				  position = 5;
																				  GRS = { Mr[18:17],|Mr[16:0] };
		                                                      end
	   48'b0000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[41:18];
																				  position = 6;
																				  GRS = { Mr[17:16],|Mr[15:0] };
		                                                      end
	   48'b00000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[40:17];
																				  position = 7;
																				  GRS = { Mr[16:15],|Mr[14:0] };
		                                                      end
		48'b000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[39:16];
																				  position = 8;
																				  GRS = { Mr[15:14],|Mr[13:0] };
		                                                      end
		48'b0000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[38:15];
																				  position = 9;
																				  GRS = { Mr[14:13],|Mr[12:0] };
		                                                      end
		48'b00000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[37:14];
																				  position = 10;
																				  GRS = { Mr[13:12],|Mr[11:0] };
		                                                      end
		48'b000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[36:13];
																				  position = 11;
																				  GRS = { Mr[12:11],|Mr[10:0] };
		                                                      end
		48'b0000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[35:12];
																				  position = 12;
																				  GRS = { Mr[11:10],|Mr[9:0] };
		                                                      end
		48'b00000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[34:11];
																				  position = 13;
																				  GRS = { Mr[10:9],|Mr[8:0] };
		                                                      end
		48'b000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[33:10];
																				  position = 14;
																				  GRS = { Mr[9:8],|Mr[7:0] };
		                                                      end
		48'b0000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[32:9];
																				  position = 15;
																				  GRS = { Mr[8:7],|Mr[6:0] };
		                                                      end
		48'b00000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[31:8];
																				  position = 16;
																				  GRS = { Mr[7:6],|Mr[5:0] };
		                                                      end
	   48'b000000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[30:7];
																				  position = 17;
																				  GRS = { Mr[6:5],|Mr[4:0] };
		                                                      end
		48'b0000000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[29:6];
																				  position = 18;
																				  GRS = { Mr[5:4],|Mr[3:0] };
		                                                      end
		48'b00000000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[28:5];
																				  position = 19;
																				  GRS = { Mr[4:3],|Mr[2:0] };
		                                                      end
      48'b000000000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[27:4];
																				  position = 20;
																				  GRS = { Mr[3:2],|Mr[1:0] };
		                                                      end
	   48'b0000000000000000000001XXXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[26:3];
																				  position = 21;
																				  GRS = Mr[2:0];
		                                                      end
	   48'b00000000000000000000001XXXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[25:2];
																				  position = 22;
																				  GRS = {Mr[1:0], 1'b0};
		                                                      end
		48'b000000000000000000000001XXXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[24:1];
																				  position = 23;
																				  GRS = {Mr[0], 2'b0};
		                                                      end
		48'b0000000000000000000000001XXXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = Mr[23:0];
																				  position = 24;
																				  GRS = 3'b0;
		                                                      end		
		48'b00000000000000000000000001XXXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[22:0],1'b0};
																				  position = 25;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000001XXXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[21:0],2'b0};
																				  position = 26;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000001XXXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[20:0], 3'b0};
																				  position = 27;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000001XXXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[19:0], 4'b0};
																				  position = 28;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000001XXXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[18:0], 5'b0};
																				  position = 29;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000000001XXXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[17:0], 6'b0};
																				  position = 30;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000000001XXXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[16:0], 7'b0};
																				  position = 31;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000000001XXXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[15:0], 8'b0};
																				  position = 32;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000000000001XXXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[14:0], 9'b0};
																				  position = 33;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000000000001XXXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[13:0], 10'b0};
																				  position = 34;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000000000001XXXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[12:0], 11'b0};
																				  position = 35;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000000000000001XXXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[11:0], 12'b0};
																				  position = 36;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000000000000001XXXXXXXXXX:begin
		                                                        Mr_norm = {Mr[10:0], 13'b0};
																				  position = 37;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000000000000001XXXXXXXXX:begin
		                                                        Mr_norm = {Mr[9:0], 14'b0};
																				  position = 38;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000000000000000001XXXXXXXX:begin
		                                                        Mr_norm = {Mr[8:0], 15'b0};
																				  position = 39;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000000000000000001XXXXXXX:begin
		                                                        Mr_norm = {Mr[7:0], 16'b0};
																				  position = 40;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000000000000000001XXXXXX:begin
		                                                        Mr_norm = {Mr[6:0], 17'b0};
																				  position = 41;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000000000000000000001XXXXX:begin
		                                                        Mr_norm = {Mr[5:0], 18'b0};
																				  position = 42;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000000000000000000001XXXX:begin
		                                                        Mr_norm = {Mr[4:0], 19'b0};
																				  position = 43;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000000000000000000001XXX:begin
		                                                        Mr_norm = {Mr[3:0], 20'b0};
																				  position = 44;
																				  GRS = 3'b0;
		                                                      end
		48'b0000000000000000000000000000000000000000000001XX:begin
		                                                        Mr_norm = {Mr[2:0], 21'b0};
																				  position = 45;
																				  GRS = 3'b0;
		                                                      end
		48'b00000000000000000000000000000000000000000000001X:begin
		                                                        Mr_norm = {Mr[1:0], 22'b0};
																				  position = 46;
																				  GRS = 3'b0;
		                                                      end
		48'b000000000000000000000000000000000000000000000001:begin
		                                                        Mr_norm = {Mr[0], 23'b0};
																				  position = 47;
																				  GRS = 3'b0;
		                                                      end
		default                                             :begin
		                                                        Mr_norm = 24'b0;
																				  position = 48;
																				  GRS = 3'b0;
		                                                      end
		endcase
   end
 
always@(*)
  begin
   if(position == 0)
    begin
	 if(underflow1 == 1'b1)
	  begin
	    if (Er_comp > 1'b1)
		   begin
			  carry=1'b0;
			  underflow1_new = 1'b1;
			  Er_norm = 8'b0;	
			  Mr_out = Mr_norm;
			  GRS_out = 3'b0;
			  end
		 else 
		   begin
			  carry=1'b0;
		     underflow1_new = 1'b0;
			  Er_norm = 8'b0;
			  Mr_out={1'b0,Mr_norm[23:1]};
			  GRS_out = {Mr[0],GRS[2],|GRS[1:0]};
		   end
	  end
	  
	  else 
	      begin
			  carry = 1'b0;
			  underflow1_new = 1'b0;
			  {carry,Er_norm} = Er+1'b1;
			   Mr_out = Mr_norm;
			  GRS_out = GRS;	
			end
	 end
	 
	 else if (position == 1)
	 begin
	  if(underflow1 == 1'b1)
	  begin

			  carry=1'b0;
			  underflow1_new = 1'b1;
			  Er_norm = 8'b0;
			  Mr_out = Mr_norm;
			  GRS_out = 3'b0;
			
	  end
	  
	  else 
	      begin
			  underflow1_new = 1'b0;
			  carry = 1'b0;
			  if (Er_comp == 8'b0)
			  begin
			    {carry,Er_norm} = 9'b0;
			    Mr_out={1'b0,Mr_norm[23:1]};
			    GRS_out = {Mr[0],GRS[2],|GRS[1:0]};
			  end
			  else
			  begin
			    {carry,Er_norm} = {1'b0,Er};
			    Mr_out = Mr_norm;
			    GRS_out = GRS;
			  end
			end	
    end

   else
   begin
	  if(underflow1 == 1'b1)
	  begin
           carry=1'b0;
			  underflow1_new = 1'b1;
			  Er_norm = 8'b0;
			  Mr_out = Mr_norm;
			  GRS_out = 3'b0;
	  end
	  
	  else 
	  begin
	    if(Er > (position-1))
	    begin
	      Er_norm = Er-position+1;
	      Mr_out = Mr_norm;
	      GRS_out = GRS;
			carry = 1'b0;
			underflow1_new = 1'b0;
	    end
       else if(Er < (position-1))
       begin
		   carry = 1'b0;
			underflow1_new = 1'b0;
         Er_norm = 8'b0;
			Mr_temp = {Mr_norm, GRS, 21'b0};
			Mr_temp = {Mr_temp>>(position-Er-1)};
			Mr_out = Mr_temp[47:24];
			GRS_out = {Mr_temp[23:22], |Mr_temp[21:0]};
       end	
		 else
		 begin
		  carry = 1'b0;
		  underflow1_new = 1'b0;
		  Er_norm = 8'b0;
		  Mr_out = {1'b0, Mr_norm[23:1]};
		  GRS_out = {Mr_norm[0],GRS[2],|GRS[1:0]};
		 end
	  end	
	  
	end
	
	if (carry == 1'b1 || Er_norm == 8'b1111_1111)
	begin
	  overflow2 = 1'b1;
	end
	else
	begin
	  overflow2 = 1'b0;
	end
  
  if (underflow1_new == 1'b1 || (Er_norm == 8'b0 && Mr_norm == 24'b0))
  begin
    underflow2 = 1'b1;
  end
  else
  begin
    underflow2 = 1'b0; 
  end
  end

endmodule
`resetall

