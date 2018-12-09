`timescale 1ns / 1ps
// Cpoyrights @ HazoorEE 2018
//
//
//
// A, and B are 8 bit inputs.
// Loading of A, and B will be done when reset==1
// Processing of GCD and LCM will be done when reset==0.
// Output is Valid Only when ready == 1.
module COMBINED(input [7:0]A, input [7:0]B, input clk, input reset, input prompt, output ready, output [7:0]result);
wire [7:0]gcd, lcm;
wire gcd_ready, lcm_ready;
GCD MyGCD(A, B, clk, reset, gcd, gcd_ready);
LCM MyLCM(A, B, gcd, clk, reset, lcm, lcm_ready);
assign result = !prompt ? gcd : lcm;
assign ready = gcd_ready && lcm_ready;
endmodule

//GCD Module according to the given Microarchitecture and Controller FSM
module GCD (input [7:0]A, input [7:0]B, input clk, input reset, output [7:0]gcd, output gcd_ready);
wire [1:0]A_sel;
wire B_sel;
reg [7:0] A_reg, B_reg;
assign gcd_ready = ( B_reg == 0 );
assign gcd = A_reg;
assign A_sel = (A_reg < B_reg) ? 2'b10 : gcd_ready;
assign B_sel = ( A_reg < B_reg );
always@(posedge clk)
begin
if(!reset) begin
   if (A_sel==0)
	   A_reg <= A_reg - B_reg;
	else if(A_sel==2)
		A_reg <= B_reg; end
else
   A_reg <= A;
end
always@(posedge clk)
begin
if(!reset) begin
   if (B_sel)
		B_reg <= A_reg; end
else
	B_reg <= B;
end
endmodule


//LCM Module according to the given Microarchitecture and Controller FSM
module LCM(input [7:0]A, input [7:0]B, input [7:0]gcd, input clk, input reset, output [7:0]result, output reg lcm_ready);
wire [7:0]A_mul_B;
assign A_mul_B = A*B;
Division8X8 div(A_mul_B,gcd,clk,result);
always @ (posedge clk)
	if(!reset)
		lcm_ready<=1;
	else
		lcm_ready<=0;
endmodule






// 8X8 Divider 
// Downloaded from [https://github.com/srichandra/fast-division]
module Division8X8(xin,yin,clk,xyout);
input [7:0] xin;//dividend
input [7:0] yin;//divisor
input clk;// clock input
output [7:0] xyout;// final output, first 8bits correspond to integer part and next 8 bits correspond to fractional part
reg [15:0] xyouti;
reg [7:0] out;
reg [7:0] xyout;
wire [15:0] temp;
mult A(out,xin,temp);// multiplication
always @(yin)
begin
casex(yin)
//look up table
8'b00000010 : out= 8'h80;
8'b00000011 : out= 8'h55;
8'b00000100 : out= 8'h40;
8'b00000101 : out= 8'h33;
8'b00000110 : out= 8'h2B;
8'b00000111 : out= 8'h25;
//
8'b00001000 : out= 8'h20;//8
8'b00001001 : out= 8'h1C;
8'b00001010 : out= 8'h1A;
8'b00001011 : out= 8'h17;
8'b00001100 : out= 8'h15;
8'b00001101 : out= 8'h14;//13
8'b00001110 : out= 8'h12;//14
8'b00001111 : out= 8'h11;
8'b00010000 : out= 8'h10;
8'b00010001 : out= 8'h0F;
8'b00010010 : out= 8'h0E;//18
8'b00010011 : out= 8'h0D;
8'b00010100 : out= 8'h0D;
8'b00010101 : out= 8'h0C;//21
8'b00010110 : out= 8'h0C;
8'b00010111 : out= 8'h0B;
8'b00011000 : out= 8'h0B;//24
8'b00011001 : out= 8'h0A;
8'b00011010 : out= 8'h0A;//26
8'b00011011 : out= 8'h09;
8'b00011100 : out= 8'h09;//28
8'b00011101 : out= 8'h09;
8'b00011110 : out= 8'h09;
8'b00011111 : out= 8'h08;//31
8'b00100000 : out= 8'h08;
8'b00100001 : out= 8'h08;//33
8'b00100010 : out= 8'h08;
8'b00100011 : out= 8'h07;//35
8'b00100100 : out= 8'h07;
8'b00100101 : out= 8'h07;//37
8'b00100110 : out= 8'h07;
8'b00100111 : out= 8'h07;//39
8'b00101000 : out= 8'h06;//40
8'b00101001 : out= 8'h06;
8'b00101010 : out= 8'h06;//42
8'b00101011 : out= 8'h06;
8'b00101100 : out= 8'h06;
8'b00101101 : out= 8'h06;//45
8'b00101110 : out= 8'h06;
8'b00101111 : out= 8'h05;//47
8'b00110000 : out= 8'h05;
8'b00110001 : out= 8'h05;
8'b00110010 : out= 8'h05;//50
8'b00110011 : out= 8'h05;
8'b00110100 : out= 8'h05;
8'b00110101 : out= 8'h05;//53
8'b00110110 : out= 8'h05;
8'b00110111 : out= 8'h05;
8'b00111000 : out= 8'h05;//56
8'b00111001 : out= 8'h04;//57
8'b00111010 : out= 8'h04;
8'b00111011 : out= 8'h04;
8'b00111100 : out= 8'h04;//60
8'b00111101 : out= 8'h04;
8'b00111110 : out= 8'h04;
8'b00111111 : out= 8'h04;//63
8'b01000000 : out= 8'h04;
8'b01000001 : out= 8'h04;//65
8'b01000010 : out= 8'h04;
8'b01000011 : out= 8'h04;//67
8'b01000100 : out= 8'h04;
8'b01000101 : out= 8'h04;
8'b01000110 : out= 8'h04;//70
8'b01000111 : out= 8'h04;
8'b01001000 : out= 8'h04;
8'b01001001 : out= 8'h04;//73
8'b01001010 : out= 8'h03;//74
8'b01001011 : out= 8'h03;
8'b01001100 : out= 8'h03;//76
8'b01001101 : out= 8'h03;
8'b01001110 : out= 8'h03;
8'b01001111 : out= 8'h03;//79
8'b01010000 : out= 8'h03;
8'b01010001 : out= 8'h03;
8'b01010010 : out= 8'h03;//82
8'b01010011 : out= 8'h03;
8'b01010100 : out= 8'h03;
8'b01010101 : out= 8'h03;
8'b01010110 : out= 8'h03;//86
8'b01010111 : out= 8'h03;
8'b01011000 : out= 8'h03;
8'b01011001 : out= 8'h03;//89
8'b01011010 : out= 8'h03;
8'b01011011 : out= 8'h03;
8'b01011100 : out= 8'h03;//92
8'b01011101 : out= 8'h03;
8'b01011110 : out= 8'h03;
8'b01011111 : out= 8'h03;//95
8'b01100000 : out= 8'h03;
8'b01100001 : out= 8'h03;//97
8'b01100010 : out= 8'h03;
8'b01100011 : out= 8'h03;
8'b01100100 : out= 8'h03;//100
8'b01100101 : out= 8'h03;
8'b01100110 : out= 8'h03;//102
8'b01100111 : out= 8'h02;
8'b01101000 : out= 8'h02;//104
8'b01101001 : out= 8'h02;
8'b01101010 : out= 8'h02;
8'b01101011 : out= 8'h02;//107
8'b01101100 : out= 8'h02;
8'b01101101 : out= 8'h02;
8'b01101110 : out= 8'h02;//110
8'b01101111 : out= 8'h02;
8'b01110000 : out= 8'h02;
8'b01110001 : out= 8'h02;
8'b01110010 : out= 8'h02;
8'b01110011 : out= 8'h02;
8'b01110100 : out= 8'h02;
8'b01110101 : out= 8'h02;
8'b01110110 : out= 8'h02;
8'b01110111 : out= 8'h02;
8'b01111000 : out= 8'h02;//120
8'b01111001 : out= 8'h02;
8'b01111010 : out= 8'h02;
8'b01111011 : out= 8'h02;
8'b01111100 : out= 8'h02;
8'b01111101 : out= 8'h02;
8'b01111110 : out= 8'h02;
8'b01111111 : out= 8'h02;
8'b10000000 : out= 8'h02;
8'b10000001 : out= 8'h02;
8'b10000010 : out= 8'h02;//130
8'b10000011 : out= 8'h02;
8'b10000100 : out= 8'h02;
8'b10000101 : out= 8'h02;
8'b10000110 : out= 8'h02;
8'b10000111 : out= 8'h02;
8'b10001000 : out= 8'h02;
8'b10001001 : out= 8'h02;
8'b10001010 : out= 8'h02;
8'b10001011 : out= 8'h02;
8'b10001100 : out= 8'h02;//140
8'b10001101 : out= 8'h02;
8'b10001110 : out= 8'h02;
8'b10001111 : out= 8'h02;
8'b10010000 : out= 8'h02;
8'b10010001 : out= 8'h02;
8'b10010010 : out= 8'h02;
8'b10010011 : out= 8'h02;
8'b10010100 : out= 8'h02;
8'b10010101 : out= 8'h02;
8'b10010110 : out= 8'h02;//150
8'b10010111 : out= 8'h02;
8'b10011000 : out= 8'h02;
8'b10011001 : out= 8'h02;
8'b10011010 : out= 8'h02;
8'b10011011 : out= 8'h02;
8'b10011100 : out= 8'h02;
8'b10011101 : out= 8'h02;
8'b10011110 : out= 8'h02;
8'b10011111 : out= 8'h02;
8'b10100001 : out= 8'h02;//160
8'b10100010 : out= 8'h02;
8'b10100011 : out= 8'h02;
8'b10100100 : out= 8'h02;
8'b10100101 : out= 8'h02;
8'b10100110 : out= 8'h02;
8'b10100111 : out= 8'h02;
8'b10101000 : out= 8'h02;
8'b10101001 : out= 8'h02;
8'b10101010 : out= 8'h02;//170
8'b10101011 : out= 8'h01;
8'b101011?? : out= 8'h01;
8'b1011???? : out= 8'h01;
8'b11?????? : out= 8'h01;
default : out = 8'h00;
endcase
end
always @(posedge clk)
begin
   if(xin==yin)
	   xyouti<=16'h0100;// if dividend and divisor are equal then output is 1
   else 
	   if(yin==8'h01)
		   xyouti<={xin,8'h00};//if divisor is 1 then output is xin
      else 
      begin
         xyouti <= temp;//output is product of xin and 1/yin(from lookup table) 
      end
   xyout <= xyouti[15:8];
end
endmodule
module mult(multiplier,multiplicand, product); //P
   input [7:0]  multiplier, multiplicand;
   output        product;
   reg [15:0]    product;
   integer       i;
   always @( multiplier or multiplicand )
     begin
        product = 0;
        for (i=0; i<8; i=i+1)
          if ( multiplier[i] == 1'b1 )
            product = product + ( multiplicand << i );
     end
endmodule
