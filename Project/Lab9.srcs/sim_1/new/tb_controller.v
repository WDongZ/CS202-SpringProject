`timescale 1ns / 1ps

module tb_controller( );
reg [31:0] inst;
wire MemRead,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite;
wire [1:0]ALUOp;
controller usctrl(inst,MemRead,ALUOp,Branch,ALUsrc,MemWrite,MemtoReg,RegWrite);

initial begin
inst[6:0] = 7'h67;
#10 inst[6:0] = 7'h33;
#10 inst[6:0] = 7'h33;
#10 inst[6:0] = 7'h33;
#10 inst[6:0] = 7'h03;
#10 inst[6:0] = 7'h23;
#10 inst[6:0] = 7'h63;
#10 $finish;
end

endmodule
