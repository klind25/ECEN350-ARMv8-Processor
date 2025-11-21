module SignExtender(BusImm, Imm26, Ctrl); 
    output reg [63:0] BusImm; 
    input [25:0] Imm26; 
    input [1:0] Ctrl; 

    // I-type extends immediate
    // D-type extends address  

    reg extBit; 

    // if statement to grab correct bits to extend
    always @(*) begin
        if (Ctrl == 2'b00) begin // I-type
            extBit = 0; // Most significant bit
            BusImm = {{52{extBit}}, Imm26[21:10]}; // Extend only immediate part to 64, add whole immediate
        end

        else if (Ctrl == 2'b01) begin // D-type
            extBit = Imm26[20]; 
            BusImm = {{55{extBit}}, Imm26[20:12]}; 
        end

        else if (Ctrl == 2'b10) begin // B-type
            extBit = Imm26[25]; 
            BusImm = {{38{extBit}}, Imm26[25:0]}; 
        end

        else begin // CB-type
            extBit = Imm26[23];
            BusImm = {{45{extBit}}, Imm26[23:5]};
        end
    end

    // assign extBit = (Ctrl ? 1'b0 : Imm16[15]); can't do this, need if statement for each type
    // assign BusImm = {{16{extBit}}, Imm16}; Actual extension of bit, specific to type

endmodule