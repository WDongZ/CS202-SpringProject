module IFetch(
    clk,branch,zero,jal,imm,PC_out
    );
    input clk,branch,zero,jal;
    input [31:0] imm;
    output [31:0] PC_out;
    reg [31:0] PC;
    initial PC <= 0;
    always @ (posedge clk) begin
        if((branch && zero)||jal) PC <= PC + {imm,1'b0};
        else PC <= PC + 4;
    end
    assign PC_out = PC;
endmodule
