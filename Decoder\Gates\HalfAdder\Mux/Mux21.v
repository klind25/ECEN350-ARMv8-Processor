module Mux21(
    output out,
    input [1:0] in, // Setup inputs and output 
    input sel);

    wire notS, sn0, sn1; // Setup internal wires

    not not1(notS, sel); // Initial computation

    and and1(sn0, notS, in[0]); // Intermediate calculations
    and and2(sn1, sel, in[1]);

    or or1(out, sn0, sn1); // Get output 

endmodule