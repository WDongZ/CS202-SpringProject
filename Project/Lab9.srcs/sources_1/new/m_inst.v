module programrom(
    input           rom_clk_i,
    input[13:0]     rom_adr_i,
    output[31:0]    Instruction_o,
    
    input           upg_rst_i,
    input           upg_clk_i,
    input           upg_wen_i,
    input[13:0]     upg_adr_i,
    input[31:0]     upg_dat_i,
    input           upg_done_i
);  
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i );
     prgrom instmem (
            .clka (kickOff ? rom_clk_i : upg_clk_i ),
            .wea (kickOff ? 1'b0 : upg_wen_i ),
            .addra (kickOff ? rom_adr_i : upg_adr_i ),
            .dina (kickOff ? 32'h00000000 : upg_dat_i ),
            .douta (Instruction_o)
    );
endmodule

