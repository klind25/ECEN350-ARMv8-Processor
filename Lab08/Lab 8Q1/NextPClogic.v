
module NextPClogic(NextPC, CurrentPC, SignExtImm64, Branch, ALUZero, Uncondbranch); 

    output reg [63:0] NextPC;   
    input [63:0] CurrentPC, SignExtImm64; // In and out
    input Branch, ALUZero, Uncondbranch; 
    

    always @(*) begin
        if(Uncondbranch || (Branch && ALUZero)) // Mux chooses 1
            NextPC = CurrentPC + SignExtImm64 * 4; // Shift offset

        else NextPC = CurrentPC + 4; // Mux chooses 0

    end


endmodule