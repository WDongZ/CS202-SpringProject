`timescale 1ns / 1ps

module tb_inst_mem( );
reg clk;
reg [13:0] addr;
wire [31:0] dout;
programrom prom(.rom_clk_i(clk),
. rom_adr_i(addr),
.Instruction_o(dout),
.upg_rst_i(1'b1)
);

initial begin
    clk = 1'b0;
    forever #5 clk = ~clk;
end

initial begin
    addr = 14'h0;
    repeat(20) #10 addr = addr + 1;
    #20 $finish;
end

endmodule
