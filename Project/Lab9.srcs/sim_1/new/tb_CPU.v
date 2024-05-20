`timescale 1ns / 1ps

module tb_CPU();
reg fpga_rst,fpga_clk,start_pg;
wire [15:0]led16;
reg [15:0]switch16;
reg [3:0] button4;
CPU_top ucpu(
.fpga_rst(fpga_rst),
.fpga_clk(fpga_clk),
.start_pg(start_pg),
.led16(led16),
.switch16(switch16),
.button4(button4));

    always  
         #5 fpga_clk = ~fpga_clk; 
    initial begin  
        // Initialize inputs  
        switch16 = 16'h1314;
        fpga_rst = 1;  
        fpga_clk = 0;  
        start_pg = 0;  
        button4 = 0;
  
        // Apply reset  
        #2500 fpga_rst = 0;
        #20 fpga_rst = 1;  
        #1000
        switch16 = 16'h5520;
        #1000
        switch16 = 16'h3300;
        button4 = 4'b1;
        #1000
        switch16 = 16'h7800;
        #2000 $finish;  
 end

endmodule
