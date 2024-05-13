`timescale 1ns / 1ps
module tb_ALU();
reg func7,ALUsrc;
reg [2:0] func3;
reg [1:0]ALUOp;
reg [31:0] ReadData1,ReadData2,imm32;
wire [31:0] ALUResult;
wire zero;

ALU uALU (ALUsrc,ALUOp,func7,func3,ReadData1,ReadData2,imm32,ALUResult,zero);

initial begin
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b0,1'b1,3'h0,2'h3,32'd100,32'd100,32'd123456789};
    #10
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b1,1'b0,3'h0,2'h2,32'd300,32'd100,32'd200};
    #10
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b0,1'b0,3'h7,2'h2,32'd1024,32'd2047,32'd200};
    #10
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b0,1'b0,3'h6,2'h2,32'd1023,32'd2047,32'd200};
    #10
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b0,1'b1,3'h0,2'h0,32'd50,32'd150,32'd200};
    #10
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b0,1'b1,3'h0,2'h0,-200,32'd350,32'd200};
    #10
    {func7,ALUsrc,func3,ALUOp,ReadData1,ReadData2,imm32} = 
    {1'b0,1'b1,3'h0,2'h1,32'd200,32'd150,32'd200};
    #10
    $finish;
end

endmodule
