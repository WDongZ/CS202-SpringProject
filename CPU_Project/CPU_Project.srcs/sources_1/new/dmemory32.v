module dmemory32(sb,ram_clk_i,ram_wen_i,ram_adr_i,ram_dat_i,ram_dat_o, upg_rst_i, upg_clk_i, upg_wen_i, upg_adr_i, upg_dat_i, upg_done_i);
    input sb;
    input ram_clk_i; // from CPU top
    input ram_wen_i; // from Controller
    input [31:0] ram_adr_i; // from alu_result of ALU
    input [31:0] ram_dat_i; // from read_data_2 of Decoder
    output [31:0] ram_dat_o; // the data read from data-ram

    // UART Programmer Pinouts
    input upg_rst_i; // UPG reset (Active High)
    input upg_clk_i; // UPG ram_clk_i (10MHz)
    input upg_wen_i; // UPG write enable
    input [13:0] upg_adr_i; // UPG write address
    input [31:0] upg_dat_i; // UPG write data
    input upg_done_i; // 1 if programming is finished

    wire clk;
    wire ram_write_data;
    
    assign ram_write_data = sb? ({ram_dat_i[7]? 24'hffffff:24'h000000,ram_dat_i[7:0]}):ram_dat_i;

    wire ram_clk = !ram_clk_i;
/* CPU work on normal mode when kickOff is 1. CPU work on Uart communicate mode whenkickOffis0.*/
    wire kickOff = upg_rst_i | (~upg_rst_i & upg_done_i);
    // wire kickOff = 1;
    RAM ram (
        .clka (kickOff ? ram_clk : upg_clk_i),
        .wea (kickOff ? ram_wen_i : upg_wen_i),
        .addra (kickOff ? ram_adr_i[15:2] : upg_adr_i),
        .dina (kickOff ? ram_write_data : upg_dat_i),
        .douta (ram_dat_o)
    );

endmodule
