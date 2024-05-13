module decoder(
rst_n,reg_write,clk,Wdata,inst,rs1,rs2,imm
    );
    input rst_n,reg_write,clk;
    input [31:0] Wdata;
    input [31:0] inst;
    output [31:0] rs1, rs2,imm;
    reg [31:0] Rdata1,Rdata2;
    reg [31:0] register [0:31];
    initial begin
    register [0] = 0;
    end
    Immi uImmi(
        .inst(inst),
        .imm(imm)
    );
    always @ * begin
        case (inst[6:0])
            7'b0110011:begin 
                Rdata1 = register[inst[19:15]];  //R
                Rdata2 = register[inst[24:20]];
            end
            7'b0010011:begin //I
                Rdata1 = register[inst[19:15]];
                Rdata2 = 0;
            end
            7'b0000011:begin //Load Type
                Rdata1 = register[inst[19:15]]; 
                Rdata2 = 0;
            end
            7'b0100011:begin  //Store Type
                Rdata1 = register[inst[19:15]];
                Rdata2 = (inst[14:12] == 3'h0) ? {24'b0,register[inst[24:20]][7:0]} : register[inst[24:20]];
            end
            7'b1100011:begin  //B
                Rdata1 = register[inst[19:15]];
                Rdata2 = register[inst[24:20]];
            end
            7'b1100111:begin  //I
                Rdata1 = register[inst[19:15]];
                Rdata2 = 0;
            end
            default:begin
                Rdata1 = 0;
                Rdata2 = 0;
            end
        endcase
    end
    always @(negedge clk) begin
        if(reg_write == 1 && inst[11:7] != 5'b00000) begin
             case (inst[6:0])
                7'b0110011,7'b0010011,7'b1100111,7'b0110111,7'b0010111,7'b1101111, 7'b0110111:begin 
                    register[inst[11:7]] <= Wdata;
                end
                7'b0000011: begin
                    register[inst[11:7]] <= (inst[14:12] == 3'h0) ? $signed(Wdata[7:0]) : Wdata;
                end
                default:begin
                    register[inst[11:7]] <= register[inst[11:7]];
                end
            endcase
        end
    end
    assign rs1 = Rdata1;
    assign rs2 = Rdata2;
endmodule
