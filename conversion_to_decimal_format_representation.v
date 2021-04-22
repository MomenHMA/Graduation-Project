`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    23:13:23 02/03/2021 
// Design Name: 
// Module Name:    conversion_to_decimal_format_representation 
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
module conversion_to_decimal_format_representation(
    input wire        S,//sign
    input wire [7:0]  E,//exponent
    input wire [27:0] M,//mantessa
    output reg [31:0] RESULT
    );
reg [9:0]T1;//last 10 bits significand field
reg [9:0]T2;//first 10 bits significand field
reg [4:0]C; //combinational field	 
always@(*)
     begin	 
	     if(  (M[11:8]<=7) &&   (M[7:4]<=7) &&  (M[3:0]<=7)       )
		    begin
			 T1={ M[10:8] , M[6:4] , 1'b0 , M[2:0]   };
			 end
        
		  else if(  (M[11:8]<=7) &&   (M[7:4]<=7) &&  (M[3:0]>7)       )
            begin
				   T1={ M[10:8] , M[6:4] ,3'b100, M[0]   };
			  end  
        
		  else if(  (M[11:8]<=7) &&   (M[7:4]>7) &&  (M[3:0]<=7)       )
            begin
				   T1={ M[10:8] , M[2:1] , M[4] , 3'b101 , M[0]   };
			   end
        
		  else if(  (M[11:8]>7) &&   (M[7:4]<=7) &&  (M[3:0]<=7)       )
            begin
				   T1={ M[2:1] , M[8] , M[6:4] , 3'b110 , M[0]   };
			   end
				
        else if(  (M[11:8]>7) &&   (M[7:4]>7) &&  (M[3:0]<=7)       )
            begin
				   T1={ M[2:1] , M[8] , 2'b00 , M[4] , 3'b111 , M[0]   };
			   end
        
		  else if(  (M[11:8]>7) &&   (M[7:4]<=7) &&  (M[3:0]>7)       )
            begin
				   T1={ M[6:5] , M[8] , 2'b01 , M[4] , 3'b111 , M[0]   };
			   end
		  
		  else if(  (M[11:8]<=7) &&   (M[7:4]>7) &&  (M[3:0]>7)       )
            begin
				   T1={ M[11:8] , 2'b10 , M[4] , 3'b111 , M[0]   };
			   end
		  
		  else //if(  (M[11:8]>7) &&   (M[7:4]>7) &&  (M[3:0]>7)       )
            begin
				   T1={ 2'bXX , M[8] , 2'b11 , M[4] , 3'b111 , M[0]   };
			   end
				
    RESULT[9:0]=T1;				
     end
always@(*)
     begin	 
	     if(  (M[23:20]<=7) &&   (M[19:16]<=7) &&  (M[15:12]<=7)       )
		    begin
			 T2={ M[22:20] , M[18:16] , 1'b0 , M[14:12]   };
			 end
        
		  else if(  (M[23:20]<=7) &&   (M[19:16]<=7) &&  (M[15:12]>7)       )
            begin
				   T2={ M[22:20] , M[18:16] ,3'b100, M[12]   };
			  end  
        
		  else if(  (M[23:20]<=7) &&   (M[19:16]>7) &&  (M[15:12]<=7)       )
            begin
				   T2={ M[22:20] , M[14:13] , M[16] , 3'b101 , M[12]   };
			   end
        
		  else if(  (M[23:20]>7) &&   (M[19:16]<=7) &&  (M[15:12]<=7)       )
            begin
				   T2={ M[14:13] , M[20] , M[18:16] , 3'b110 , M[12]   };
			   end
				
        else if(  (M[23:20]>7) &&   (M[19:16]>7) &&  (M[15:12]<=7)       )
            begin
				   T2={ M[14:13] , M[20] , 2'b00 , M[16] , 3'b111 , M[12]   };
			   end
        
		  else if(  (M[23:20]>7) &&   (M[19:16]<=7) &&  (M[15:12]>7)       )
            begin
				   T2={ M[18:17] , M[20] , 2'b01 , M[16] , 3'b111 , M[12]   };
			   end
		  
		  else if(  (M[23:20]<=7) &&   (M[19:16]>7) &&  (M[15:12]>7)       )
            begin
				   T2={ M[22:20] , 2'b10 , M[16] , 3'b111 , M[12]   };
			   end
		  
		  else //if(  (M[23:20]>7) &&   (M[19:16]>7) &&  (M[15:12]>7)       )
            begin
				   T2={ 2'bXX , M[20] , 2'b11 , M[16] , 3'b111 , M[12]   };
			   end				
    RESULT[19:10]=T2;				
     end	  
	  
always @(*) //EXPONENT part	  
       begin
		    if(M[27:24]<=7)
			   begin
				  if(E[7:6]==2'b00)
				    begin
					 C={2'b00,M[26:24]};
				    end
				  
				  else if(E[7:6]==2'b01)
				    begin
					 C={2'b01,M[26:24]};
				    end
				  
				  else if(E[7:6]==2'b10)
				    begin
					 C={2'b10,M[26:24]};
				    end
				  
				  else
				    begin
					 C=5'b11110;
				    end
			 end

		    else//(M[27:24]>7)
			   begin
				  if(E[7:6]==2'b00)
				    begin
					 C={4'b1100,M[24]};
				    end
				  
				  else if(E[7:6]==2'b01)
				    begin
					 C={4'b1101,M[24]};
				    end
				  
				  else if(E[7:6]==2'b10)
				    begin
					 C={4'b1110,M[24]};
				    end
				  
				  else 
				    begin
					 C=5'b11110;
				    end
			 end
			 if (C == 5'b11110)
			 begin
			    RESULT[31:20]={S,C,6'b111111};
			 end
			 else
			 begin
			   RESULT[31:20]={S,C,E[5:0]};
			 end
			 
end
endmodule
`resetall 