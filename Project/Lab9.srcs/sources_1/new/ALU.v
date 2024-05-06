module ALU(
ALUsrc,ALUOp,func7,func3,ReadData1,ReadData2,imm32,ALUResult,zero
    );
    input func7,ALUsrc;
    input [2:0] func3;
    input [1:0]ALUOp;
    input [31:0] ReadData1,ReadData2,imm32;
    output reg [31:0] ALUResult;
    output zero;
    reg [3:0] ALUControl;
    wire[31:0] operand2;
    always @ *  begin
    case( ALUOp)
     2'b00,2'b01: ALUControl = { ALUOp, 2'b10};
     2'b10: begin
            case(func3)
                3'h0: ALUControl = (func7 == 1'b1) ? 4'h6 : 4'h2;
                3'h7: ALUControl = 4'h0;
                3'h6: ALUControl = 4'h1;
            endcase
         end
     endcase
     end
     assign operand2 = (ALUsrc==1'b0)? ReadData2 : imm32;
    always @ *  
        case( ALUControl)
             4'b0010: ALUResult= ReadData1 + operand2;
             4'b0110: ALUResult= ReadData1 - operand2;
             4'b0000: ALUResult= ReadData1 & operand2;
             4'b0001: ALUResult= ReadData1 | operand2;
        endcase
    assign zero = (ALUResult==1'b0)? 1'b1: 1'b0;
endmodule
