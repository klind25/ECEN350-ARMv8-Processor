`define AND   4'b0000 // Defining operations
`define OR    4'b0001
`define ADD   4'b0010
`define SUB   4'b0110
`define PassB 4'b0111


module ALU(BusW, Zero, BusA, BusB, ALUCtrl);
    
    parameter n = 64;

    output reg [n-1:0] BusW; // Inputs and outputs
    input      [n-1:0] BusA, BusB;
    input      [3:0]   ALUCtrl;
    output reg Zero;
    
    always @(ALUCtrl or BusA or BusB) begin
        case(ALUCtrl)
            `AND: BusW = BusA & BusB;

            `OR:  BusW = BusA | BusB;

            `ADD: BusW = BusA + BusB;

            `SUB: BusW = BusA - BusB;

            `PassB: BusW = BusB;
            
        endcase

        if (BusW == 0) Zero = 1;
        else Zero = 0;
    end

endmodule