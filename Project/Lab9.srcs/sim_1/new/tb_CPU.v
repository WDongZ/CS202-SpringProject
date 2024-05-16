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
        #2000 fpga_rst = 0;
        #2010 fpga_rst = 1;  
        #2500 $finish;  
 end

endmodule
