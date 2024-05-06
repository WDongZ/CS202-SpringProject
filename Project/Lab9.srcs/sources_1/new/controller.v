module controller(
    inst,MemRead,ALUOp,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite, Alu_resultHigh,MemorIOtoReg,IORead,IOWrite
    );
    input[21:0] Alu_resultHigh; 
    output reg [1:0] ALUOp;
    input [31:0]inst;
    output MemRead,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite,MemorIOtoReg,MemRead,IORead,IOWrite;
    wire R,I,lw,sw,B,J,U;
    assign R = (inst[6:0]==7'h33) ? 1'b1:1'b0;
    assign I = (inst[6:0]==7'h13 || inst[6:0]==7'h03 || inst[6:0]==7'h67 || inst[6:0]==7'h73) ? 1'b1:1'b0;
    assign lw = (inst[6:0]==7'h03) ? 1'b1:1'b0;
    assign sw = (inst[6:0]==7'h23) ? 1'b1:1'b0;
    assign B = (inst[6:0]==7'h63) ? 1'b1:1'b0;
    assign J = (inst[6:0]==7'h6f) ? 1'b1:1'b0;
    assign U = (inst[6:0]==7'h37 || inst[6:0]==7'h17) ? 1'b1:1'b0;
    assign MemRead = lw;
    assign Branch = B;
    assign ALUsrc = I;
    assign MemWrite = sw;
    assign MemtoReg = lw;
    assign RegWrite = R | I | J | U;
    assign IORead  = ((lw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0;  
    assign IOWrite = ((sw==1) && (Alu_resultHigh[21:0] == 22'h3FFFFF)) ? 1'b1:1'b0;  
    assign MemWrite = ((sw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;  
    assign MemRead = ((lw==1) && (Alu_resultHigh[21:0] != 22'h3FFFFF)) ? 1'b1:1'b0;           
     assign MemorIOtoReg = IORead || MemRead;  
    always @ *  
        case( inst[6:0])
            7'h03,7'h23: ALUOp = 2'b00;
            7'h63: ALUOp = 2'b01;
            default: ALUOp = 2'b10;
        endcase
endmodule

