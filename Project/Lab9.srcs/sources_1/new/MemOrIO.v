module MemOrIO(MemtoReg, mRead, mWrite, ioRead, ioWrite, addr_in, addr_out,
m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl);
input MemtoReg;
 input mRead; 
input mWrite; 
input ioRead; 
input ioWrite;
input[31:0] addr_in;
output[31:0] addr_out;
input[31:0] m_rdata; 
input[15:0] io_rdata; 
output[31:0] r_wdata; 
input[31:0] r_rdata; 
 output reg[31:0] write_data; // data to memory or I/O��m_wdata, io_wdata��
output LEDCtrl; 
// LED Chip Select
 output SwitchCtrl; 
// Switch Chip Select
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit of r_wdata.
assign addr_out= addr_in;
assign r_wdata = ioRead ? io_rdata : (MemtoReg ? m_rdata : addr_in);
always @*
$monitor("r_wdata = %h, write_data = %h", r_wdata, write_data);            
// Chip select signal of  Led and Switch  are all active high;
assign LEDCtrl=  ioWrite;  
assign SwitchCtrl= ioRead;
always @* begin
if((mWrite==1)||(ioWrite==1)) write_data = r_rdata;  
//wirte_data could go to either memory or IO. where is it from? 
//else 
//write_data = 32'hZZZZZZZZ;
end
endmodule