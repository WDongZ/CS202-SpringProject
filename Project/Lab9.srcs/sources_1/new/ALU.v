module ALU(
ALUSrc,ALUOp,funct7,funct3,ReadData1,ReadData2,imm32,ALUResult,zero
    );
    input funct7,ALUSrc;
    input [2:0] funct3;
    input [1:0]ALUOp;
    input [31:0] ReadData1,ReadData2,imm32;
    output reg [31:0] ALUResult;
    output zero;
    reg [3:0] ALUControl;
    wire[31:0] operand2;
    wire blt;
    wire bge;
    wire bltu;
    wire bgeu;
    wire signed [31:0] SReadData1;
    wire signed [31:0] Soperand2;
    always @ *  begin
    case(ALUOp)
     2'b00,2'b01,2'b11: ALUControl = { ALUOp, 2'b10};
     2'b10: begin
            case(funct3)
                3'h0: ALUControl = (funct7 == 1'b1) ? 4'h6 : 4'h2;
                3'h7: ALUControl = 4'h0;
                3'h6: ALUControl = 4'h1;
            endcase
         end
     endcase
     end
     assign operand2 = (ALUSrc==1'b0)? ReadData2 : imm32;
     assign Soperand2 = operand2;
     assign SReadData1 = ReadData1;
     assign blt = (SReadData1 < Soperand2)? 1'b1:1'b0;
     assign bge = (SReadData1 >= Soperand2)? 1'b1:1'b0;
     assign bltu = (ReadData1 < operand2)? 1'b1:1'b0;
     assign bgeu = (ReadData1 >= operand2)? 1'b1:1'b0;
    always @ *  
        case( ALUControl)
             4'b0010: ALUResult= ReadData1 + operand2;
             4'b0110: ALUResult= ReadData1 - operand2;
             4'b0000: ALUResult= ReadData1 & operand2;
             4'b0001: ALUResult= ReadData1 | operand2;
             4'b1110: ALUResult= ReadData1 << 12;
        endcase
    assign zero = ((ALUResult==32'b0 && funct3==3'b000)||(ALUResult!=32'b0 && funct3==3'b001)||(blt && funct3==3'b100)||(bge && funct3==3'b101)||(bltu && funct3==3'b110)||(bgeu && funct3==3'b111))? 1'b1: 1'b0; // beq,bne,blt,bge,bltu,bgeu
endmodule
