module CPU_top(
    input fpga_rst, //Active Low
    input fpga_clk, input[15:0] switch16,input[3:0] button4, output[15:0] led16,
    output [7:0] en_tube, output [7:0] tub_control1,output [7:0] tub_control2,
    // UART Programmer Pinouts
    // start Uart communicate at high level
    input start_pg,
    input rx,
    output tx
);

// UART Programmer Pinouts
wire upg_clk, upg_clk_o;
wire upg_wen_o; //Uart write out enable
wire upg_done_o; //Uart rx data have done
//data to which memory unit of program_rom/dmemory32
wire [14:0] upg_adr_o;
//data to program_rom or dmemory32
wire [31:0] upg_dat_o;

wire spg_bufg;
BUFG U1(.I(start_pg), .O(spg_bufg)); // de-twitter// Generate UART Programmer reset signal
reg upg_rst;
always @ (posedge fpga_clk) begin
    if (spg_bufg) upg_rst = 0;
    if (!fpga_rst) upg_rst = 1;
end
//used for other modules which don't relatetoUARTwire rst;
wire rst;
assign rst = (!fpga_rst | (!upg_rst));
wire clk;
wire tube_clk;

clock clock1 (
    .in(fpga_clk),
    .out(clk),
    .upg_out(upg_clk),
    .tube_clk(tube_clk)
);

 uart_bmpg_0 uart_bmpg_1
    (
        .upg_clk_i  (upg_clk),
        .upg_rst_i  (upg_rst),
        .upg_rx_i   (rx),
        .upg_clk_o  (upg_clk_o),
        .upg_wen_o  (upg_wen_o),
        .upg_adr_o  (upg_adr_o),
        .upg_dat_o  (upg_dat_o),
        .upg_done_o (upg_done_o),
        .upg_tx_o   (tx)
    );
wire[31:0] Instruction;
wire[31:0] PC;
wire[31:0] opcplus4;
wire[31:0] ALU_Result;
wire[31:0] Addr_Result;
wire[31:0] write_data;
wire[31:0] mread_data;
wire[31:0] read_data;
wire[31:0] address;
wire[31:0] ioread_data;

wire[31:0] Read_data_1;
wire[31:0] Read_data_2;
wire[31:0] Sign_extend;

wire Jr,ALUSrc,MemtoReg,RegWrite,MemWrite,Branch,Jal,I_format;
wire[1:0] ALUOp;
wire Zero,MemRead;
Ifetc32 Ifetc32_1(
    .Instruction(Instruction),
    .branch_base_addr(PC),
    .link_addr(opcplus4),
    .clock(clk),
    .reset(fpga_rst),
    .Addr_result(Addr_Result),
    .Zero(Zero),
    .Read_data_1(Read_data_1),

    .Branch(Branch),
    .Jal(Jal),
    .Jr(Jr),

    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & !upg_adr_o[14]),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
);
executs32 executs32_1(
    .Read_data_1(Read_data_1),
    .Read_data_2(Read_data_2),
    .Sign_extend(Sign_extend),
    .opcode(Instruction[6:0]),
    .funct3(Instruction[14:12]),
    .ALUOp(ALUOp),
    .funct7(Instruction[31:25]),
    .ALUSrc(ALUSrc),
    .I_format(I_format),
    .Jr(Jr),
    .Zero(Zero),
    .ALU_Result(ALU_Result),
    .Addr_Result(Addr_Result),
    .PC(PC)
); 

wire ioRead,ioWrite;
control32 control32_1(
    .Opcode(Instruction[6:0]),
    .Jr(Jr),
    .ALUSrc(ALUSrc),
    .MemtoReg(MemtoReg),
    .RegWrite(RegWrite),
    .MemWrite(MemWrite),
    .Branch(Branch),
    .Jal(Jal),
    .I_format(I_format),
    .ALUOp(ALUOp),
    .IOwrite(ioWrite),
    .IOread(ioRead),
    .Memread(MemRead),
    .addr(address[31:10])
);
wire sb;
decode32 decode32_1(
    .read_data_1(Read_data_1),
    .read_data_2(Read_data_2),
    .Instruction(Instruction),
    .mem_data(read_data),
    .ALU_result(ALU_Result),
    .Jal(Jal),
    .RegWrite(RegWrite),
    .MemtoReg(MemtoReg),
    .Sign_extend(Sign_extend),
    .clock(clk),
    .reset(~fpga_rst),
    .opcplus4(opcplus4),
    .sb(sb)
);

dmemory32 dmemory32_1(
    .sb(sb),
    .ram_clk_i(clk),
    .ram_wen_i(MemWrite),
    .ram_adr_i(address),
    .ram_dat_i(Read_data_2),
    .ram_dat_o(mread_data),

    .upg_rst_i(upg_rst),
    .upg_clk_i(upg_clk_o),
    .upg_wen_i(upg_wen_o & (!upg_adr_o[14])),
    .upg_adr_i(upg_adr_o[13:0]),
    .upg_dat_i(upg_dat_o),
    .upg_done_i(upg_done_o)
);

wire SwitchCtrl, LEDCtrl, TubeCtrl;
MemOrIO MemOrIO_1(
    .mRead(MemRead),
    .mWrite(MemWrite),
    .ioRead(ioRead),
    .ioWrite(ioWrite),
    .addr_in(ALU_Result),
    .addr_out(address),
    .m_rdata(mread_data),
    .io_rdata(ioread_data),
    .r_wdata(read_data),
    .r_rdata(Read_data_2),
    .write_data(write_data),
    .SwitchCtrl(SwitchCtrl),
    .LEDCtrl(LEDCtrl),
    .TubeCtrl(TubeCtrl)
);

ioread switch (
    .clk(clk),
    .reset(fpga_rst),				
	.ior(ioRead),				
    .switchctrl(SwitchCtrl),			
    .ioread_data_switch(switch16),	
    .ioread_data(ioread_data),
    .addr(ALU_Result),
    .ioread_data_button(button4) 		
);

leds LED (
    .ledrst(fpga_rst),		
    .led_clk(clk),	
    .ledcs(ioWrite),		
    .ledaddr(ALU_Result),	
    .ledwdata(write_data),	
    .ledout(led16)
);

seven_segment_tube tube (
        .rst(~fpga_rst),
        .tubeCtrl(ioWrite),
        .code(write_data),
        .addr(ALU_Result),
        .clk(tube_clk),
        .tub_sel1(en_tube[7:4]),
        .tub_sel2(en_tube[3:0]),
        .tub_control1(tub_control1),
        .tub_control2(tub_control2)
);

endmodule
