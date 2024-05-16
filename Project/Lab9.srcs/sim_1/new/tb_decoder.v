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
    Wdata = 32'h0;
    clk = 1'b0;
    forever #5 clk = ~clk;
end
initial begin
    #10 rst_n = 1;
    #10 rst_n = 0;
    inst = 32'h00108093;
        Wdata = 1;
    #10 inst = 32'hfffff337;
        Wdata = 32'hfffff000;
    #10 inst = 32'h49030313;
        Wdata = rs1 + 32'h490;
    #10 inst = 32'h3e730313;
        Wdata = rs1 + 32'h3e7;
    #10 inst = 32'h3e930313;
        Wdata = rs1 + 32'h3e9;  
    #10 inst = 32'h00132023;
        Wdata = 32'hfffffc60;
    #10 $finish;
end

endmodule
