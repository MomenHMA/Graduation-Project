`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date:    21:36:29 02/09/2021 
// Design Name: 
// Module Name:    BCD_multiplier 
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
module BCD_multiplier(
    input  wire [27:0] M1,
    input  wire [27:0] M2,
    output wire [55:0] Mr
    );
//parameter ten=0110,
  //        twenty=0110,
	//		 thirty=00010,
		//	 fourty
			 
reg [7:0] temp;
reg [31:0] temp2;
reg [55:0]rows[6:0];
reg [3:0] carry;
wire [3:0] C1;
wire [3:0] C2;
wire [3:0] C3;
wire [3:0] C4;
wire [3:0] C5;
wire [3:0] C6;
wire [55:0] out1;
wire [55:0] out2;
wire [55:0] out3;
wire [55:0] out4;
wire [55:0] out5;
integer i;
integer j;	 
always@(*)
 begin
    //carry=4'b0;
    for(j=0;j<28;j=j+4)
      begin
		carry=4'b0;
        for(i=0;i<28;i=i+4)
           begin
              temp= (M2[j+:4] * M1[i+:4])+carry;
				    if(temp<10)
					   begin
						carry=4'b0;
						temp2[i+:4]=temp;
                  end
					  
					  else if((temp>=10) &&(temp<20))
					  begin
					  carry=4'b0001;
					  temp2[i+:4]=temp+4'b0110;
					  end
					  
					  else if((temp>=20) && (temp<30))
					  begin
					  carry=4'b0010;
					  temp2[i+:4]=temp+5'b01100;
					  end
					  
					  else if((temp>=30) &&(temp<40))
					  begin
					  carry=4'b0011;
					  temp2[i+:4]=temp+5'b00010;
					  end
					  
					  else if((temp>=40) &&(temp<50))
					  begin
					  carry=4'b0100;
					  temp2[i+:4]=temp+6'b011000;
					  end					  
					  
					  else if((temp>=50) &&(temp<60))
					  begin
					  carry=4'b0101;
					  temp2[i+:4]=temp+6'b001110;
					  end
					  
					  else if((temp>=60) &&(temp<70))
					  begin
					  carry=4'b0110;
					  temp2[i+:4]=temp+6'b000100;
					  end					  

					  else if((temp>=70) &&(temp<80))
					  begin
					  carry=4'b0111;
					  temp2[i+:4]=temp+7'b0111010;
					  end					  

					  else if((temp>=80) &&(temp<90))
					  begin
					  carry=4'b1000;
					  temp2[i+:4]=temp+7'b0110000;
					  end					  
					  
					  else 
					  begin
					  carry=4'b1001;
					  temp2[i+:4]=temp+7'b0100110;
					  end			  
    end
		 temp2[i+:4]=carry;
		 temp2 = {24'b0,temp2};
		 rows[j/4]=temp2<<(j);			  
     end
end 
	 	 
BCD_adder BCD_adder1 (
		.M1(rows[0]), 
		.M2(rows[1]), 
		.Mr(out1),
		.carry(C1)
	);

BCD_adder BCD_adder2 (
		.M1(out1), 
		.M2(rows[2]), 
		.Mr(out2),
		.carry(C2)
	);
	
BCD_adder BCD_adder3 (
		.M1(out2), 
		.M2(rows[3]), 
		.Mr(out3),
		.carry(C3)
	);
	
BCD_adder BCD_adder4 (
		.M1(out3), 
		.M2(rows[4]), 
		.Mr(out4),
		.carry(C4)
	);

BCD_adder BCD_adder5 (
		.M1(out4), 
		.M2(rows[5]), 
		.Mr(out5),
		.carry(C5)
	);

BCD_adder BCD_adder6 (
		.M1(out5), 
		.M2(rows[6]), 
		.Mr(Mr),
		.carry(C6)
	);

endmodule
`resetall 