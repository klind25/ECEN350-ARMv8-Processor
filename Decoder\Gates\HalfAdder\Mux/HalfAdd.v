module HalfAdd(
        output Cout, // Get inputs and outputs
        output  Sum,
        input A,
        input B);

        wire xor1, xor2, xor3; // Get wires for the NAND = XOR

        nand nand1(xor1, A, B); // S logic = XOR
        nand nand2(xor2, xor1, A);
        nand nand3(xor3, xor1, B);
        nand nand4(Sum, xor2, xor3);

        nand nand5(Cout, xor1, xor1); // Carry out logic = AND

endmodule