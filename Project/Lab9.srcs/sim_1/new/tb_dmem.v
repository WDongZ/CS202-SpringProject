module tb_dmem();  //part1 of tb
    reg clk, MemRead, MemWrite;
    reg [31:0] addr, din;
    wire [31:0] dout;
    DMem udmem(.clk(clk),
        .MemRead(MemRead), .MemWrite(MemWrite),
        .addr(addr), .din(din), 
        .dout(dout));
    initial begin
        clk =1'b0;
        forever #5 clk=~clk;
    end
    initial begin                
        MemWrite = 1'b0;
        MemRead = 1'b1;
        #75
        MemWrite = 1'b1;
     end
     initial begin
         din = 32'h0;
         #75  repeat(10) #12 din = din+16;
     end
     initial begin
         addr =32'h0;
         repeat(20) #12 addr = 
         addr + 4;
         #20 $finish;
     end
     endmodule