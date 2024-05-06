`timescale 1ns / 1ps

module tb_decoder();
reg clk;
reg [31:0] inst;
reg [31:0] Wdata;
wire [31:0] rs1,rs2,imm;
decoder udcd(.clk(clk),.Wdata(Wdata),.inst(inst),.rs1(rs1),.rs2(rs2),.imm(imm));

initial begin
    Wdata = 100;
    clk = 1'b0;
    forever #5 clk = ~clk;
end
initial begin
    inst = 32'h06400093;
    #10 inst = 32'h06408113;
        Wdata = 200;
    #10 inst = 32'b00000000000000010000000110110011;
    #10 $finish;
end

endmodule
