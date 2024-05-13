`timescale 1ns / 1ps

module tb_decoder();
reg clk;
reg [31:0] inst;
reg [31:0] Wdata;
wire [31:0] imm;
wire [31:0] rs1,rs2;
reg rst_n,reg_write;
decoder udcd(rst_n,reg_write,clk,Wdata,inst,rs1,rs2,imm);

initial begin
    rst_n = 0;
    reg_write = 1;
    Wdata = 32'h12345688;
    clk = 1'b0;
    forever #5 clk = ~clk;
end
initial begin
    inst = 32'h06430303;
    #10 inst = 32'h06430113;
        Wdata = -20;
    #10 inst = 32'h06630223;
    #10 $finish;
end

endmodule
