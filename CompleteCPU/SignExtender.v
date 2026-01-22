module SignExtender(BusImm, Imm26, Ctrl); 
    output reg [63:0] BusImm; 
    input [25:0] Imm26; 
    input [2:0] Ctrl; 

    // I-type extends immediate
    // D-type extends address  

    reg extBit; 
    reg [63:0] extended;

    // if statement to grab correct bits to extend
    always @(*) begin
        if (Ctrl == 3'b000) begin // I-type
            extBit = 0; // Most significant bit
            BusImm = {{52{extBit}}, Imm26[21:10]}; // Extend only immediate part to 64, add whole immediate
        end

        else if (Ctrl == 3'b001) begin // D-type
            extBit = Imm26[20]; 
            BusImm = {{55{extBit}}, Imm26[20:12]}; 
        end

        else if (Ctrl == 3'b010) begin // B-type
            extBit = Imm26[25]; 
            BusImm = {{38{extBit}}, Imm26[25:0]}; 
        end

        else if (Ctrl == 3'b011) begin // CB-type
            extBit = Imm26[23];
            BusImm = {{45{extBit}}, Imm26[23:5]};
        end

        else if (Ctrl == 3'b111) begin // IW-type, MOVZ
            extBit = 0;
            extended = {{48{extBit}}, Imm26[20:5]};

            if (Imm26[22:21] == 2'b00) // If shift is 0, make sure not to make whole thing 0
                BusImm = extended;     // No shifting 
            else if (Imm26[22:21] == 2'b01)
                BusImm = extended << (16 * 1); // ShIft 16
            else if (Imm26[22:21] == 2'b10)
                BusImm = extended << (16 * 2); // Shift 32
            else 
                BusImm = extended << (16 * 3); // Shift 48
        end

        else 
            BusImm = 64'b0; // Default case 

    end
    // assign extBit = (Ctrl ? 1'b0 : Imm16[15]); can't do this, need if statement for each type
    // assign BusImm = {{16{extBit}}, Imm16}; Actual extension of bit, specific to type
 
endmodule