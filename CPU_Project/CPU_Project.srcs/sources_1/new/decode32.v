module decode32(read_data_1,read_data_2,Instruction,mem_data,ALU_result,
                 Jal,RegWrite,MemtoReg,Sign_extend,clock,reset,opcplus4);
    output[31:0] read_data_1;               // data from reg1
    output[31:0] read_data_2;               // data from reg2
    input[31:0]  Instruction;               // Instruction
    input[31:0]  mem_data;   				// DATA RAM or I/O port
    input[31:0]  ALU_result;   				// ALU result
    input        Jal;                       // if jal type inst
    input        RegWrite;                  // reg write signal from ctrler
    input        MemtoReg;                  // memtoreg signal from ctrler
    output[31:0] Sign_extend;               // imm with sign extend
    input		 clock,reset;               // clock,rst from fpga
    input[31:0]  opcplus4;                  // op+4 to jal

    reg[31:0] r[0:31];
    reg[31:0] wdata=0;
    
    wire[4:0] rreg_1;       //ins[19:15]
    wire[4:0] rreg_2;       //ins[24:20]
    wire[4:0] rd;           //ins[11:7]
    assign rreg_1=Instruction[19:15];
    assign rreg_2=Instruction[24:20];
    assign rd = Instruction[11:7];
    
    Immi imm(Instruction,Sign_extend);
    assign read_data_1 = r[rreg_1];
    assign read_data_2 = r[rreg_2];
    
    integer i;
    initial begin
        for (i=0;i<32;i=i+1)r[i] <= 0;
    end
    always @(posedge clock or posedge reset)begin
        if (reset==1)begin
            for (i=0;i<32;i=i+1)r[i] <= 0;
        end
        else if (RegWrite && rd!=5'b00000)begin
            if(Instruction[14:12]==3'b000) r[rd]<= {wdata[7]? 24'h111111:24'h000000, wdata[7:0]};
            else r[rd]<=wdata;
        end
    end
    always @* begin
        if (Jal)begin
            wdata=opcplus4;
        end
        else if(~MemtoReg)begin
            wdata=ALU_result;
        end
        else begin
            wdata = mem_data;
        end
    end
endmodule
