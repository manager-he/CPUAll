`timescale 1ns / 1ps
module poster_tb;

	// Inputs
    reg clk_in;
    reg enable;
    reg reset;
    reg start;

	// Outputs
	// wire [7:0] pc;
	// wire [15:0] inst;
	// Instantiate the Unit Under Test (UUT)
    top top_inst(clk_in, enable, reset, start);
	
initial begin
		// Initialize Inputs
		clk_in = 0;
		enable = 1;
        reset = 1;
        start = 1;		

		// Wait 200 ns for global reset to finish
		#200;  reset = 0;		
	end
   
	always begin		
        #50;	
        clk_in = ~clk_in;	
	end
endmodule
