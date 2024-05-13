<<<<<<< HEAD
module CPU(fpga_rst,fpga_clk,switch16,led16,start_pg,rx,tx,digit_led7,button5);
    input fpga_rst,fpga_clk,start_pg,rx;
    input[15:0] switch16;
    input[4:0] button5;
=======
module CPU(fpga_rst,fpga_clk,switch16,button4,led16,tub_sel1,tub_sel2,tub_control1,tub_control2,start_pg,rx,tx);
    input fpga_rst,fpga_clk,start_pg,rx;
    input[15:0] switch16;
    input [3:0]button4;
>>>>>>> 8e1cc1c496420132d21f5dc538ad41cf0bd83b78
    output[15:0] led16;
    output [3:0] tub_sel1;
    output [3:0] tub_sel2;
    output [7:0] tub_control1;
    output [7:0] tub_control2;
    output tx;
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
    wire [15:0]switchData;
    wire tube_clk;
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
    clock_divider tube_clock (upg_clk,tube_clk);
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
    MemOrIO mio(MemRead, MemWrite, IORead, IOWrite,ram_dat, ioread_data, Wdata, Rdata1, write_data, ledcs, switchcs);
    ioread uior(rst,IORead,switchcs,switch16,ioread_data);
    leds uled(rst,cpuclk,IOWrite,ledcs,ALUResult[1:0],write_data,led16);
    seven_segment_tube tube_tb(1'b1,32'b0011_0010_0011_0100_0101_0110_0111_1100,tube_clk,tub_sel1,tub_sel2,tub_control1,tub_control2);//test
    switches uswitch(cpuclk,rst,IORead,button4,ALUResult[1:0],switch16,switchData);
endmodule
