module IFetch(Instruction, clock, reset, imm, Branch, Jal, Zero, PC_out,
    upg_rst_i, upg_clk_i, upg_wen_i, upg_adr_i, upg_dat_i, upg_done_i);
    output[31:0] PC_out;
    output[31:0] Instruction; // the instruction fetched from this module
    input clock, reset; // Clock and reset
    // from ALU
    input[31:0] imm; // the imm address from ALU
    input Zero; // while Zero is 1, it means the ALUresult is zero

    // from Controller
    input Branch; // while Branch is 1,it means current instruction is beq
    input Jal; // while Jal is 1, it means current instruction is jal
    // UART Programmer Pinouts
    input upg_rst_i; // UPG reset (Active High)
    input upg_clk_i; // UPG clock (10MHz)
    input upg_wen_i; // UPG write enable
    input[13:0] upg_adr_i; // UPG write address
    input[31:0] upg_dat_i; // UPG write data
    input upg_done_i; // 1 if program finished

    reg[31:0] PC=0, Next_PC=0;  

    always @(Branch or Zero or imm or Jal or PC or Instruction) 
    begin
        $monitor("PC = %h, inst = %h",PC,Instruction);
        if(Branch == 1 && Zero == 1)
            Next_PC = PC + {imm,1'b0};
        else if(Jal == 1)
            Next_PC = PC + {imm,1'b0};
        else
            Next_PC = PC + 4;
    end

    always @( negedge clock)
    begin 
        if(reset == 1) PC <= 32'h0000_0000; 
        else PC <= Next_PC; 
    end
    
    assign PC_out = PC;

//    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
     wire kickOff = 1;
    prgrom instmem(
        .clka (kickOff ? clock : upg_clk_i),
        .wea (kickOff ? 1'b0 : upg_wen_i),
        .addra (kickOff ? PC[15:2] : upg_adr_i),
        .dina (kickOff ? 32'h00000000 : upg_dat_i),
        .douta (Instruction)
    );

endmodule