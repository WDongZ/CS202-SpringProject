module CPU(fpga_rst,fpga_clk,switch16,led16,start_pg,rx,tx,digit_led7,button5);
    input fpga_rst,fpga_clk,start_pg,rx;
    input[15:0] switch16;
    input[4:0] button5;
    output[15:0] led16;
    output tx;
    output [31:0] digit_led7;
    wire [31:0] PC;
    wire [15:0] ioread_data;
    wire [31:0] addr, Wdata, Rdata1, Rdata2, imm, ALUResult, write_data,ram_dat;
    wire [31:0] inst;
    wire[1:0] ALUOp;
    wire cpuclk,MemRead,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite,zero,MemorIOtoReg,IORead,IOWrite,ledcs,switchcs;
    wire upg_clk,upg_clk_o;
    wire upg_wen_o;
    wire upg_done_o;
    wire [14:0] upg_adr_o;
    wire [31:0] upg_dat_o;
    wire spg_bufg;
    BUFG U1(.I(start_pg), .O(spg_bufg));     // de-twitter
    // Generate UART Programmer reset signal
    reg upg_rst;
    always @ (posedge fpga_clk) begin
    if (spg_bufg) upg_rst <= 0;
    if (fpga_rst) upg_rst <= 1;
    end
    //used for other modules which don't relate to UART
    wire rst;      
    assign rst = fpga_rst | !upg_rst;
    cpuclk uclk( .clk_in1(fpga_clk), .clk_out1(cpuclk), .clk_out2(upg_clk));
    IFetch uif(cpuclk,Branch,zero,imm,PC);
    programrom(
        .rom_clk_i(cpuclk),
        .rom_adr_i(PC),
        .Instruction_o(inst),
        .upg_rst_i(rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(RegWrite),
        .upg_adr_i(PC),
        .upg_dat_i(Wdata),
        .upg_done_i(rx));
    controller uctrl(inst,MemRead,ALUOp,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite,ALUResult[31:10],MemorIOtoReg,IORead,IOWrite);
    decoder udcd(rst,RegWrite,cpuclk,Wdata,inst,Rdata1,Rdata2,imm);
    ALU uALU(ALUsrc,ALUOp,inst[26],inst[14:12],Rdata1,Rdata2,imm,ALUResult,zero);
    dmemory32 umem(
        .ram_clk_i(cpuclk),
        .ram_wen_i(MemWrite),
        .ram_adr_i(addr),
        .ram_dat_i(write_data),
        .ram_dat_o(ram_dat),
        .upg_rst_i(rst),
        .upg_clk_i(upg_clk),
        .upg_wen_i(tx),
        .upg_adr_i(addr),
        .upg_dat_i(write_data),
        .upg_done_i(rx));
    MemOrIO mio(MemRead, MemWrite, IORead, IOWrite,ALUResult, addr, ram_dat, ioread_data, Wdata, Rdata1, write_data, ledcs, switchcs);
    ioread uior(rst,IORead,switchcs,switch16,ioread_data);
    leds uled(rst,cpuclk,IOWrite,ledcs,ALUResult[1:0],write_data,led16,digit_led7);
endmodule
