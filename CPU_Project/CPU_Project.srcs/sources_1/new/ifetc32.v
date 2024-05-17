module Ifetc32(Instruction, branch_base_addr, link_addr, clock, reset, Addr_result, Read_data_1, Branch, nBranch, Jmp, Jal, Jr, Zero, 
    upg_rst_i, upg_clk_i, upg_wen_i, upg_adr_i, upg_dat_i, upg_done_i);
    output[31:0] Instruction; // the instruction fetched from this module
    output[31:0] branch_base_addr; // (pc+4) to ALU which is used by branch type instruction
    output reg [31:0] link_addr; // (pc+4) to Decoder which is used by jal instruction
    input clock, reset; // Clock and reset
    // from ALU
    input[31:0] Addr_result; // the calculated address from ALU
    input Zero; // while Zero is 1, it means the ALUresult is zero

    // from Decoder
    input[31:0] Read_data_1; // the address of instruction used by jr instruction

    // from Controller
    input Branch; // while Branch is 1,it means current instruction is beq
    input nBranch; // while nBranch is 1,it means current instruction is bnq
    input Jmp; // while Jmp 1, it means current instruction is jump
    input Jal; // while Jal is 1, it means current instruction is jal
    input Jr; // while Jr is 1, it means current instruction is jr
    // UART Programmer Pinouts
    input upg_rst_i; // UPG reset (Active High)
    input upg_clk_i; // UPG clock (10MHz)
    input upg_wen_i; // UPG write enable
    input[13:0] upg_adr_i; // UPG write address
    input[31:0] upg_dat_i; // UPG write data
    input upg_done_i; // 1 if program finished

    reg[31:0] PC=0, Next_PC=0;  

    assign branch_base_addr = PC + 4;

    always @(Branch or nBranch or Zero or Addr_result or Read_data_1 or Jr or Jmp or Jal or PC or Instruction) 
    begin
        if((Branch == 1 && Zero == 1) || (nBranch == 1 && Zero == 0))
            Next_PC = Addr_result;
        else if(Jr == 1)
            Next_PC = Read_data_1;
        else if(Jal == 1 || Jmp == 1)
            Next_PC = {PC[31:28], Instruction[25:0], 2'b00};
        else
            Next_PC = PC + 4;
    end

    always @( negedge clock)
    begin 
        if(reset == 1) PC <= 32'h0000_0000; 
        else PC <= Next_PC; 
    end

    always @(negedge clock)
    begin
        if ((Jmp == 1) || (Jal == 1)) 
            link_addr <= (PC + 4);
        else
            link_addr <= link_addr;
    end

    assign branch_base_addr = PC + 4;

    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    // wire kickOff = 1;
    prgrom instmem(
        .clka (kickOff ? clock : upg_clk_i),
        .wea (kickOff ? 1'b0 : upg_wen_i),
        .addra (kickOff ? PC[15:2] : upg_adr_i),
        .dina (kickOff ? 32'h00000000 : upg_dat_i),
        .douta (Instruction)
    );

endmodule
