class rand_num;
  rand int unsigned  c ;
  rand int exp;
  rand bit sign;
  constraint num_constraint { sign==0 ;c < 9999999 ; exp inside{[-101:90]};}
  
  /*function new (int seed = 1);
    srandom(seed) ;
  endfunction*/

  function real gen_num();
    $display("sign = %0d C = %0d exp = %0d",sign,c,exp);
    $display("itor sign = %0d C = %0d exp = %0f",$itor(sign),$itor(c),$itor(exp));

    return ((-1.0)**$itor(sign))*$itor(c)*(10.0**$itor(exp));
  endfunction
     
endclass
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
function bit [31:0] represent (rand_num num);
  bit [31:0] rep_num ;
  bit[7:0] exp_biased;
  int c [7] ;
  int i ;
  rep_num[31] = num.sign ;
  for( i = 0; i< 7; i = i+1)
    begin
    	c[i] = (num.c/(10**i))%10;
    end
  exp_biased = num.exp + 101;
  ///////////////////////// encoding Combination field //////////////////////////
  if(c[6] > 7)
    begin
      rep_num[30:29] = 2'b11 ;
      rep_num[28:27] = exp_biased[7:6] ;
      rep_num[25:20] = exp_biased[5:0] ;
      if(c[6] == 8)
        rep_num[26] = 0 ;
      else
        rep_num[26] = 1 ;
    end
  else
    begin
      rep_num[30:29] = exp_biased[7:6] ;
      rep_num[25:20] = exp_biased[5:0] ;
      rep_num[28:26] = c[6];
    end 
  rep_num[19:10] = densely_pack(c[5],c[4],c[3]);
  rep_num[9:0] = densely_pack(c[2],c[1],c[0]);
  

return rep_num;
  
endfunction 
///////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
///////////////////////////////// densely packed/////////////////////////////////
function bit[9:0] densely_pack(int d_1, d_2, d_3);
  bit [2:0] row ;
  bit [9:0] b ; 
  row = {d_1[3] , d_2[3] , d_3[3]};
  case (row)
    3'b000 : begin
      b[9:7] = d_1[2:0];
      b[6:4] = d_2[2:0];
      b[3] = 0 ;
      b[2:0] = d_3[2:0];
    end
    3'b001 : begin
      b[9:7] = d_1[2:0];
      b[6:4] = d_2[2:0];
      b[3] = 1 ;
      b[2:0] = {2'b00,d_3[0]};
    end
    3'b010 : begin
      b[9:7] = d_1[2:0];
      b[6:4] = {d_3[2:1] , d_2[0]};
      b[3] = 1 ;
      b[2:0] = {2'b01,d_3[0]};
    end
    3'b011 : begin
      b[9:7] = d_1[2:0];
      b[6:4] = {2'b10,d_2[0]};
      b[3] = 1 ;
      b[2:0] = {2'b11,d_3[0]};
    end
    3'b100 : begin
      b[9:7] = {d_3[2:1],d_1[0]};
      b[6:4] = d_2[2:0];
      b[3] = 1 ;
      b[2:0] = {2'b10,d_3[0]};
    end
    3'b101 : begin
      b[9:7] = {d_2[2:1],d_1[0]};
      b[6:4] = {2'b01 , d_2[0]};
      b[3] = 1 ;
      b[2:0] = {2'b11,d_3[0]};
    end
    3'b110 : begin
      b[9:7] = {d_3[2:1],d_1[0]};
      b[6:4] = {2'b00 , d_2[0]};
      b[3] = 1 ;
      b[2:0] = {2'b11,d_3[0]};
    end
    3'b111 : begin
      b[9:7] = {2'b00 ,d_1[0]};
      b[6:4] = {2'b11 ,d_2[0]};
      b[3] = 1 ;
      b[2:0] = {2'b11,d_3[0]};
    end 
  endcase
  return b ;
endfunction 
////////////////////////////////////////////////////////////////////////////////  
///////////////////////////////////decoding/////////////////////////////////////////////////////////////////////////////////////////////////////////   
function rand_num decode(bit[31:0] rep_num);
  rand_num num;
  int temp ;
  bit [7:0] exp ; 
  int c_0 ;
  num = new();
  num.sign = rep_num[31];
  if(rep_num[30:29] == 2'b11)
    begin
      exp[7:6] = rep_num[28:27];
      exp[5:0] = rep_num[25:20];
      c_0 = 8+rep_num[26];
    end
  else
    begin
      exp[7:6] = rep_num[30:29];
      exp[5:0] = rep_num[25:20];
      c_0 = rep_num[28:26];
    end
  num.exp = exp-101;
  num.c = c_0*(10**6) +
  		  densely_decode(rep_num[19:10])*1000 +
          densely_decode(rep_num[9:0]) ;
  return num ;
  
endfunction

/////////////////////////////////////////////////////////////////////////////////
//////////////////////////// densely decodeing ///////////////////////////////

function int densely_decode(bit [9:0] b);
  int c [3];
  if(b[3] == 0 )
    begin
      c[2] = b[9:7] ;
      c[1] = b[6:4] ;
      c[0] = b[2:0] ;
    end
  else if (b[3:1] == 3'b100)
    begin
      c[2] = b[9:7] ;
      c[1] = b[6:4] ;
      c[0] = 8+b[0] ;
    end
  else if (b[3:1] == 3'b101)
    begin
      c[2] = b[9:7] ;
      c[1] = 8+b[4] ;
      c[0] = 4*b[6] + 2*b[5] + b[0] ;
    end
  else if (b[3:1] == 3'b110)
    begin
      c[2] = 8+b[7] ;
      c[1] = b[6:4] ;
      c[0] = 4*b[9] + 2*b[8] + b[0] ;
    end
  else if (b[3:1] == 3'b111 && b[6:5] == 2'b00)
    begin
      c[2] = 8+b[7] ;
      c[1] = 8+b[4] ;
      c[0] = 4*b[9] + 2*b[8] + b[0] ;
    end
  else if (b[3:1] == 3'b111 && b[6:5] == 2'b01)
    begin
      c[2] = 8+b[7] ;
      c[1] = 4*b[9] + 2*b[8] + b[4] ;
      c[0] = 8+b[0] ;
    end
  else if (b[3:1] == 3'b111 && b[6:5] == 2'b10)
    begin
      c[2] = b[9:7] ;
      c[1] = 8+b[4] ; 
      c[0] = 8+b[0] ;
    end  
  else if (b[3:1] == 3'b111 && b[6:5] == 2'b11)
    begin
      c[2] = 8+b[7] ;
      c[1] = 8+b[4] ; 
      c[0] = 8+b[0] ;
    end 
  else
    begin
      c[2] = -1;
      c[1] = -1;
      c[0] = -1;
    end
  return c[0]+10*c[1]+100*c[2] ;
endfunction
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////  