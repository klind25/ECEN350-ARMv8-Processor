`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   15:06:33 03/02/2009
// Design Name:   SignExtender
// Module Name:   E:/350/Lab7/SignExtenderTest.v
// Project Name:  SignExtender
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: SignExtender
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 15
module SignExtenderTest_v;
initial //This initial block used to dump all wire/reg values to dump file
    begin
     $dumpfile("SignExtender.vcd"); // Fixed dump
     $dumpvars(0,SignExtenderTest_v);
    end
	task passTest;
		input [63:0] actualOut, expectedOut; // Output correct size, everything else copied
		input [`STRLEN*8:0] testType;
		inout [7:0] passed;
        // Checking if correct
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed; // Checking if all passed
		input [7:0] passed;
		input [7:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask
	
	task stim;
		input [25:0] newImm26; // Create new and set for inputs
		input [1:0] newCtrl;
		output [25:0] setImm26;
        output [1:0] setCtrl;
		
		begin
			#90;
			setImm26 = newImm26; // Change old to new
			setCtrl = newCtrl;
		end
	endtask
	
	// Inputs
	reg [25:0] Imm26;
	reg [1:0] Ctrl;
	reg [7:0] passed;

	// Outputs
	wire [63:0] BusImm;

	// Instantiate the Unit Under Test (UUT)
	SignExtender uut (
		.BusImm(BusImm), 
		.Imm26(Imm26), 
		.Ctrl(Ctrl)
	);

	initial begin
		// Initialize Inputs
		Imm26 = 26'b00000000000000000000000000;
		Ctrl = 2'b00;
		passed = 0;

		/* Create test cases
        stim(Imm26 input, ctrl input, input1, input2); wait a little passTest(output1, expected value, tested type, call passed)
        */

		stim(26'b10100101011010110100011010, 2'b00, Imm26, Ctrl); #10; passTest(BusImm, 64'b010101101011, "I-type pos", passed);
		stim(26'b10101101010010110101111000, 2'b00, Imm26, Ctrl); #10; passTest(BusImm, 64'b110101001011, "I-type neg", passed);
		stim(26'b01011010110101111010100101, 2'b01, Imm26, Ctrl); #10; passTest(BusImm, 64'b010110101, "D-type pos", passed);
		stim(26'b01110100110101010101010111, 2'b01, Imm26, Ctrl); #10; passTest(BusImm, 64'b1111111111111111111111111111111111111111111111111111111100110101, "D-type neg", passed);
		stim(26'b00110101011111101011010100, 2'b10, Imm26, Ctrl); #10; passTest(BusImm, 64'b00110101011111101011010100, "B-type pos", passed);
		stim(26'b10110100101000101110101001, 2'b10, Imm26, Ctrl); #10; passTest(BusImm, 64'b1111111111111111111111111111111111111110110100101000101110101001, "B-type neg", passed);
		stim(26'b11000101101011001010100011, 2'b11, Imm26, Ctrl); #10; passTest(BusImm, 64'b0001011010110010101, "CB-type pos", passed);
		stim(26'b11110100110100101001011011, 2'b11, Imm26, Ctrl); #10; passTest(BusImm, 64'b1111111111111111111111111111111111111111111111101001101001010010, "CB-type neg", passed);
		#10;
		
		allPassed(passed, 8); // Checking if everything worked
	end
      
endmodule
