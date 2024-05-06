`timescale 1ns / 1ps
 module MemOrIO_tb( );
     reg mRead,mWrite,ioRead,ioWrite;
     reg[31:0] addr_in,m_rdata,r_rdata;
     reg[15:0] io_rdata;
     wire LEDCtrl,SwitchCtrl;
     wire [31:0] addr_out,r_wdata,write_data;
     MemOrIO umio( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, 
    m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl);
     initial begin    // r_rdata -> m_wdata(write_data)
         m_rdata = 32'hffff_0001;   
         io_rdata = 16'hffff;   
         r_rdata = 32'h0f0f_0f0f;     
         addr_in = 32'h4;
         {mRead,mWrite,ioRead,ioWrite}= 4'b01_00;  
         #10    addr_in = 32'hffff_fc60;    {mRead,mWrite,ioRead,ioWrite}= 4'b00_01;               
         #10   addr_in = 32'h0000_0004;     {mRead,mWrite,ioRead,ioWrite}= 4'b10_00;        
         #10   addr_in = 32'hffff_fc70;      {mRead,mWrite,ioRead,ioWrite}= 4'b00_10;             
         #10 $finish;
     end
 endmodule
