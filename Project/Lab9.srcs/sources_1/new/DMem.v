module DMem(clk,MemRead,MemWrite,addr,din,dout);
    input clk; 
    input MemRead,MemWrite;
    input [31:0] addr; 
    input [31:0] din;
    output[31:0] dout;
    RAM udram(.clka(clk), .wea(MemWrite), 
        .addra(addr[15:2]), .dina(din), 
        .douta(dout));
endmodule