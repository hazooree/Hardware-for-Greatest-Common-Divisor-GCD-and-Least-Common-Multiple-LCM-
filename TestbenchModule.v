`timescale 1ns / 1ps
// Cpoyrights @ HazoorEE 2018

module COMBINED_TEST;

	// Inputs
	reg [7:0] A;
	reg [7:0] B;
	reg clk;
	reg reset;
	reg prompt;

	// Outputs
	wire ready;
	wire [7:0] result;

	// Instantiate the Unit Under Test (UUT)
	COMBINED uut (
		.A(A), 
		.B(B), 
		.clk(clk), 
		.reset(reset), 
		.prompt(prompt), 
		.ready(ready), 
		.result(result)
	);
initial 
forever #10 clk=~clk;


initial begin
		// Initialize Inputs
		clk = 0;
		reset = 1;
		A = 20;
		B = 12;
		#30;
		reset = 0;
		prompt = 0;
		#300;
		reset = 1;
		#30;
		reset = 0;
		prompt = 1;

        
		// Add stimulus here

	end
      
endmodule

