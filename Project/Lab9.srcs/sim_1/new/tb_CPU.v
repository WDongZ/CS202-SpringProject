`timescale 1ns / 1ps

module tb_CPU();
reg fpga_rst,fpga_clk,start_pg;
CPU ucpu(fpga_rst,fpga_clk,start_pg);

    always  
         #5 fpga_clk = ~fpga_clk; 
    initial begin  
        // Initialize inputs  
        fpga_rst = 1;  
        fpga_clk = 0;  
        start_pg = 0;  
  
        // Apply reset  
        #10 fpga_rst = 0;
        #10 fpga_rst = 1;  
        #1000 $finish;  
 end

endmodule
