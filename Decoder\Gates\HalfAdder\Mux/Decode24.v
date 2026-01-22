module Decode24(out, in);
    input [1:0] in;
    output reg [3:0] out;

    always @(in) begin // Changes at in change
        case(in[1:0])
            2'b00: out = 4'b0001; // Set the outputs
            2'b01: out = 4'b0010;
            2'b10: out = 4'b0100;
            2'b11: out = 4'b1000;

            default: out = 0; // Create a default to catch other inputs with a unique output

        endcase
    end

endmodule