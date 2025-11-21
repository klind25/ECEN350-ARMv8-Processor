`timescale 1ns / 1ps

////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer:
//
// Create Date:   10:02:47 03/05/2009
// Design Name:   ALU
// Module Name:   E:/350/Lab8/ALU/ALUTest.v
// Project Name:  ALU
// Target Device:  
// Tool versions:  
// Description: 
//
// Verilog Test Fixture created by ISE for module: ALU
//
// Dependencies:
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
////////////////////////////////////////////////////////////////////////////////

`define STRLEN 32
module ALUTest_v;
initial
    begin
     $dumpfile("ALUTest.vcd"); // Fixed dump
     $dumpvars(0,ALUTest_v);
    end
	task passTest;
		input [64:0] actualOut, expectedOut;
		input [`STRLEN*8:0] testType;
		inout [14:0] passed;
	
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %x should be %x", testType, actualOut, expectedOut);
	endtask
	
	task allPassed;
		input [14:0] passed;
		input [14:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask

	// Inputs
	reg [63:0] BusA;
	reg [63:0] BusB;
	reg [3:0] ALUCtrl;
	reg [14:0] passed;

	// Outputs
	wire [63:0] BusW;
	wire Zero;

	// Instantiate the Unit Under Test (UUT)
	ALU uut (
		.BusW(BusW), 
		.Zero(Zero), 
		.BusA(BusA), 
		.BusB(BusB), 
		.ALUCtrl(ALUCtrl)
	);

	initial begin
		// Initialize Inputs
		BusA = 0;
		BusB = 0;
		ALUCtrl = 0;
		passed = 0;

         // Here is one example test vector, testing the ADD instruction:
        // AND
		{BusA, BusB, ALUCtrl} = {64'h21389, 64'h12398, 4'h0}; #40; passTest({Zero, BusW}, 65'h0388, "AND1", passed);
        {BusA, BusB, ALUCtrl} = {64'h0, 64'hFFFFFF, 4'h0}; #40; passTest({Zero, BusW}, {1'b1, 64'b0}, "AND2", passed);
        {BusA, BusB, ALUCtrl} = {64'h9776, 64'h54412, 4'h0}; #40; passTest({Zero, BusW}, 65'h0412, "AND3", passed);
        // OR 
        {BusA, BusB, ALUCtrl} = {64'h1921A, 64'hBC672, 4'h1}; #40; passTest({Zero, BusW}, 65'h0BD67A, "OR1", passed);
        {BusA, BusB, ALUCtrl} = {64'hF0F0F0, 64'H0F0F0F, 4'h1}; #40; passTest({Zero, BusW}, 65'h0FFFFFF, "OR2", passed);
        {BusA, BusB, ALUCtrl} = {64'hABCDEF, 64'h123456, 4'h1}; #40; passTest({Zero, BusW}, 65'h0BBFDFF, "OR3", passed);
        // ADD
        {BusA, BusB, ALUCtrl} = {64'h20, 64'h4500, 4'h2}; #40; passTest({Zero, BusW}, 65'h04520, "ADD1", passed);
        {BusA, BusB, ALUCtrl} = {64'h467, 64'h2329, 4'h2}; #40; passTest({Zero, BusW}, 65'h02790, "ADD2", passed);
        {BusA, BusB, ALUCtrl} = {64'h2387, 64'h9812, 4'h2}; #40; passTest({Zero, BusW}, 65'h0BB99, "ADD3", passed);
        // SUB
        {BusA, BusB, ALUCtrl} = {64'H9231, 64'h8128789, 4'h6}; #40; passTest({Zero, BusW}, {1'b0, 64'hFFFFFFFFF7EE0AA8}, "SUB1", passed);
        {BusA, BusB, ALUCtrl} = {64'hFFFA, 64'hFFFA, 4'h6}; #40; passTest({Zero, BusW}, {1'b1, 64'b0}, "SUB2", passed);
        {BusA, BusB, ALUCtrl} = {64'h29219A, 64'hBCD456, 4'h6}; #40; passTest({Zero, BusW}, {1'b0, 64'hFFFFFFFFFF6C4D44}, "SUB3", passed);
        // Pass B
        {BusA, BusB, ALUCtrl} = {64'h28179A, 64'h8799BC, 4'h7}; #40; passTest({Zero, BusW}, 65'h08799BC, "Pass1", passed);
        {BusA, BusB, ALUCtrl} = {64'h389DEA, 64'h7636A, 4'h7}; #40; passTest({Zero, BusW}, 65'h07636A, "Pass2", passed);
        {BusA, BusB, ALUCtrl} = {64'hFFFFFFF, 64'h127CEFF, 4'h7}; #40; passTest({Zero, BusW}, 65'h0127CEFF, "Pass3", passed);


		allPassed(passed, 15);
	end
      
endmodule

