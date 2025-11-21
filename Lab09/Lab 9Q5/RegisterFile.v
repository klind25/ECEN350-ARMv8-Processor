module RegisterFile(BusA, BusB, BusW, RA, RB, RW, RegWr, Clk);
    output [63:0] BusA;
    output [63:0] BusB;
    input [63:0] BusW;
    input [4:0] RA, RB, RW; // 32 registers
    input RegWr;
    input Clk;

    reg [63:0] registers [31:0]; // 32 possible registers, 64 bits long

    assign #2 BusA = (RA == 5'b11111) ? 0 : registers[RA];  // Use combinational with ternary
    assign #2 BusB = (RB == 5'b11111) ? 0 : registers[RB]; 

    always @ (negedge Clk) begin // Writing on negedge
        if(RegWr) // If control logic says to write
            registers[RW] <= #3 BusW;
    end

endmodule