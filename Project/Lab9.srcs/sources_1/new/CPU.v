module CPU(fpga_rst,fpga_clk,switch16,button4,led16,tub_sel1,tub_sel2,tub_control1,tub_control2,start_pg,rx,tx);
    input               fpga_rst,fpga_clk,start_pg,rx;
    input[15:0]         switch16;
    input [3:0]         button4;
    output[15:0]        led16;
    output [3:0]        tub_sel1;
    output [3:0]        tub_sel2;
    output [7:0]        tub_control1;
    output [7:0]        tub_control2;
    output              tx; //UART output T4
    wire [31:0]         PC; //Program Counter
    wire [15:0]         ioread_data; //IO read data
    wire [16:0]         addr; //RAM address
    wire [31:0]         Wdata; //Write back data to decoder
    wire [31:0]         Rdata1, Rdata2; //Read data from decoder
    wire [31:0]         imm; //Immediate data
    wire [31:0]         ALUResult; //ALU result
    wire [31:0]         write_data; //Data to be written to RAM or IO
    wire [31:0]         ram_dat; //Data read from RAM
    wire [31:0]         inst;   //Instruction
    wire [1:0]          ALUOp; //ALU operation
    wire cpuclk,MemRead,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite,zero,MemorIOtoReg,IORead,IOWrite,ledcs,switchcs; //Control signals
    wire                jal; // jal inst from conroller
    wire                upg_clk;  //UART Programmer clock
    wire                upg_clk_o; //UART Programmer clock output
    wire                upg_wen; //UART Programmer write enable
    wire                upg_wen_o; //UART Programmer write enable output
    wire                upg_done_o; //UART Programmer done signal
    wire                [13:0] upg_adr_o; //UART Programmer address output
    wire                [31:0] upg_dat_o;   //UART Programmer data output
    wire                spg_bufg; //UART Programmer reset signal
    wire                [15:0]switchData; //Switch data
    wire                tube_clk; //Tube clock
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
    uart_bmpg_0 uart(
        .upg_clk_i(upg_clk),
        .upg_rst_i(rst),
        .upg_rx_i(rx),
        .upg_clk_o(upg_clk_o),
        .upg_wen_o(upg_wen),
        .upg_adr_o(upg_adr_o),
        .upg_dat_o(upg_dat_o),
        .upg_done_o(upg_done_o),
        .upg_tx_o(tx)
    );
    IFetch uif(cpuclk,Branch,zero,jal,imm,PC);
    programrom uprog(
        .rom_clk_i(cpuclk),
        .rom_adr_i(PC[13:0]),
        .Instruction_o(inst),
        .upg_rst_i(rst),
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o));
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
        .upg_clk_i(upg_clk_o),
        .upg_wen_i(upg_wen),
        .upg_adr_i(upg_adr_o),
        .upg_dat_i(upg_dat_o),
        .upg_done_i(upg_done_o));
    MemOrIO mio(MemRead, MemWrite, IORead, IOWrite,ALUResult,addr,ram_dat, ioread_data, Wdata, Rdata1, write_data, ledcs, switchcs);
    ioread uior(rst,IORead,switchcs,switch16,ioread_data);
    leds uled(rst,cpuclk,IOWrite,ledcs,ALUResult[1:0],switch16,led16);
    seven_segment_tube tube_tb(IORead,switchData,tube_clk,tub_sel1,tub_sel2,tub_control1,tub_control2);//test
    switches uswitch(cpuclk,rst,IORead,button4,ALUResult[4:0],switch16,switchData);
endmodule
