module control32(Opcode,addr,Jr,ALUSrc,MemtoReg,RegWrite,
                    MemWrite,Branch,Jal,I_format,ALUOp,IOwrite,IOread,Memread);
    input[6:0]   Opcode;            //Opcode from inst[6:0]
    input[21:0]  addr;             //Address[31:10]
    output       Jr;         	 // inst jr type signal
    output       ALUSrc;          //ALU sorce
    output       MemtoReg;     // Memory to reg signal
    output       RegWrite;   	  // reg write signal
    output       MemWrite;       //  memory write signal
    output       Branch;        //  branch signal
    output       Jal;            //  jal signal
    output       I_format;      // I coumpute operator inst signal
    output[1:0]  ALUOp;        // ALU operator
    output       IOwrite;
    output       IOread;
    output       Memread;
    wire R;
    wire I;
    wire sw;
    wire lw;

    assign R=(Opcode==7'h33);
    assign I=(I_format || lw || Jr);
    assign MemtoReg = (lw);    
    assign MemWrite= (sw)&&(addr!=22'h3fffff);
    assign Branch=(Opcode==7'h63);
    assign Jal = (Opcode == 7'h6f);
    assign Jr = (Opcode==7'h67);
    assign sw = (Opcode == 7'h23);
    assign lw = (Opcode == 7'h03);
    
    assign RegWrite=(R||I_format||MemtoReg||Jal)&&(~(Branch||sw));//sw beq  bne
    assign ALUSrc = I&&(~Branch);
    assign I_format= (Opcode == 7'h13);
    
    assign ALUOp[1] = (R||I_format);
    assign ALUOp[0] = Branch;
    assign IOwrite=(sw)&&(addr==22'h3fffff);
    assign IOread=(lw)&&(addr==22'h3fffff);
    assign Memread=(lw)&&(addr!=22'h3fffff);


endmodule

