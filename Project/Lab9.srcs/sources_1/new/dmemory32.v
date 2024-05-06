module dmemory32(
    input           ram_clk_i,
    input           ram_wen_i,
    input[13:0]     ram_adr_i,
    input[31:0]     ram_dat_i,
    output[31:0]    ram_dat_o,
    
    input           upg_rst_i,
    input           upg_clk_i,
    input           upg_wen_i,
    input[13:0]     upg_adr_i,
    input[31:0]     upg_dat_i,
    input           upg_done_i
);

    wire ram_clk = !ram_clk_i;
    
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    
    RAM ram (
    .clka (kickOff ?    ram_clk     : upg_clk_i),
    .wea (kickOff ?     ram_wen_i   : upg_wen_i),
    .addra (kickOff ?   ram_adr_i   : upg_adr_i),
    .dina (kickOff ?    ram_dat_i   : upg_dat_i),
    .douta (ram_dat_o)
    );
 endmodule
