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

`define STRLEN 25
module PCTest_v;
initial //This initial block used to dump all wire/reg values to dump file
    begin
     $dumpfile("PC.vcd"); // Fixed dump
     $dumpvars(0,PCTest_v);
    end
	task passTest;
		input [63:0] actualOut, expectedOut; // Output correct size, everything else copied
		input [`STRLEN*8:0] testType;
		inout [16:0] passed;
        // Checking if correct
		if(actualOut == expectedOut) begin $display ("%s passed", testType); passed = passed + 1; end
		else $display ("%s failed: %d should be %d", testType, actualOut, expectedOut);
	endtask
	
	task allPassed; // Checking if all passed
		input [16:0] passed;
		input [16:0] numTests;
		
		if(passed == numTests) $display ("All tests passed");
		else $display("Some tests failed");
	endtask
	
	task stim;
		input [63:0] newCurrentPC, newSignExtImm64; // Create new and set for inputs
		input newBranch, newALUZero, newUncondbranch;
		output [63:0] setCurrentPC, setSignExtImm64;
        output setBranch, setALUZero, setUncondbranch;
		
		begin
			#90;
			setCurrentPC = newCurrentPC; // Change old to new
			setSignExtImm64 = newSignExtImm64;
            setBranch = newBranch;
            setALUZero = newALUZero;
            setUncondbranch = newUncondbranch;
		end
	endtask
	
	// Inputs
	reg [63:0] CurrentPC, SignExtImm64;
	reg Branch, ALUZero, Uncondbranch;
	reg [16:0] passed;

	// Outputs
	wire [63:0] NextPC;

	// Instantiate the Unit Under Test (UUT)
	NextPClogic uut (
		.NextPC(NextPC), 
		.CurrentPC(CurrentPC), 
		.SignExtImm64(SignExtImm64),
        .Branch(Branch),
        .ALUZero(ALUZero),
        .Uncondbranch(Uncondbranch)
	);

	initial begin
		// Initialize Inputs
		CurrentPC = 0;
		SignExtImm64 = 0;
        Branch = 0;
        ALUZero = 0;
        Uncondbranch = 0;
		passed = 0;

        /*
        TESTS
        1 and 2. No branching, +4
        3 and 4. CBZ, one with Zero = 1 one with Zero = 0
        5 and 6. B one positive offset, one negative
        */

        /* FORMAT
        newCurrentPC, newSign, newBranch, newALUZero, newUncondbranch
        */

        // POSITIVE
        stim(64'hABCDF91891926572, 64'h0000723803738232, 0, 0, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'hABCDF91891926576, "No branch1, pos 000", passed);

        stim(64'h1287987ABCFF1120, 64'h7237778ADCDCD331, 0, 1, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h1287987ABCFF1124, "No branch2, pos 010", passed);
        



        stim(64'h12982189723AB378, 64'h0000000127868718, 1, 0, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h12982189723AB37C, "CBZ1, doesn't, pos 100", passed);

        stim(64'h8922837239181282, 64'h0000FFFFF109101B, 1, 1, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h89268371FD3C52EE, "CBZ2, does, pos, 110", passed);
    


        stim(64'h00000012345BCDE2, 64'h000000000323387B, 0, 0, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h1240E8AFCE, "B1, pos, 001", passed);

        stim(64'h0000010F3CDABFFF, 64'h0000000CDEF56124, 0, 1, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h142B8B0448F, "B2, pos, 011", passed);

        stim(64'h0000111223A38787, 64'h000005646546CDEF, 1, 0, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h26A3B8BEBF43, "B3, pos, 101", passed);

        stim(64'h0012328467BCD881, 64'h0000000872387CDE, 1, 1, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h1232A6309ECBF9, "B4, pos, 111", passed);

        // NEGATIVE
        stim(64'h0001278387374444, 64'hFFFFEFACC8728818, 0, 0, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h0001278387374448, "No branch1, pos 000", passed);

        stim(64'h2389748762387878, 64'hFFFFFFFFFE721767, 0, 1, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h238974876238787C, "No branch2, pos 010", passed);
        



        stim(64'h2723872387238723, 64'hFFFFFF9812873182, 1, 0, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h2723872387238727, "CBZ1, doesn't, pos 100", passed);

        stim(64'h0000233870187ABC, 64'hFFFFFFF812378181, 1, 1, 0, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h2318B8F680C0, "CBZ2, does, pos, 110", passed);
    


        stim(64'h000FFFF23787CDAB, 64'hFFFFFFFFFFFF1234, 0, 0, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'hFFFF23784167B, "B1, pos, 001", passed);

        stim(64'h0FFFFFFF321ABC64, 64'hFFFFFFF123879022, 0, 1, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'hFFFFFC3C038FCEC, "B2, neg, 011", passed);

        stim(64'h0000128023982998, 64'hFFFFFF38923983AB, 1, 0, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'hF626C7E3844, "B3, pos, 101", passed);

        stim(64'h00000011828827AA, 64'hFFFFFFFFFF298772, 1, 1, 1, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch);
        $display (CurrentPC," ", SignExtImm64, " ", Branch, " ", ALUZero, " ", Uncondbranch, " ", NextPC);
        #10; passTest(NextPC, 64'h117F2E4572, "B4, pos, 111", passed);
		
		allPassed(passed, 16); // Checking if everything worked
    end
      
endmodule