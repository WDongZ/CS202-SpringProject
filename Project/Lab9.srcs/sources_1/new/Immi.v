
module Immi(
input [31:0] inst,
output signed [31:0] imm
    ); 
    reg signed [31:0] data;
        always @* 
            case (inst[6:0])
            7'b0010011: 
            begin 
                if (inst[14:12]==3'b011) data = inst[31:20];
                else data = $signed(inst[31:20]);
            end
            7'b0000011: data = $signed(inst[31:20]); 
            7'b0100011: data = $signed({inst[31:25],inst[11:7]});
            7'b1100011: 
            begin 
                if (inst[14:12]==3'b110 || inst[14:12] == 3'b111) data = {inst[31],inst[7],inst[30:25],inst[11:8],1'b0};
                else data = $signed({inst[31],inst[7],inst[30:25],inst[11:8],1'b0});
            end
            7'b1101111: data = $signed({inst[31],inst[19:12],inst[20],inst[30:21],1'b0});
            7'b1100111: data = $signed(inst[31:20]);
            7'b0110111: data = $signed(inst[31:12]);
            7'b0010111: data = $signed(inst[31:12]);
            default: data = 0;
            endcase
        assign imm = data;
endmodule
