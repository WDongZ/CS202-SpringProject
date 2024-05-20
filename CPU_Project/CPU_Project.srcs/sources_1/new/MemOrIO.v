module MemOrIO( mRead, mWrite, ioRead, ioWrite,addr_in, addr_out, m_rdata, io_rdata, r_wdata, r_rdata, write_data, LEDCtrl, SwitchCtrl, TubeCtrl);
input mRead; // read memory, fromController
input mWrite; // write memory, fromController
input ioRead; // read IO, from Controll
input ioWrite; // write IO, from Controller
input[31:0] addr_in; // from alu_result in ALU
output[31:0] addr_out; // address to Data-Memory
input[31:0] m_rdata; // data read from Data-Memory
input[31:0] io_rdata; // data read from IO, 32 bits
output[31:0] r_wdata; // data to Decoder(register file)
input[31:0] r_rdata; // data read from Decoder(register file)
output reg[31:0] write_data; // data to memory or I/Oï¼ˆm_wdata, io_wdataï¼?
output SwitchCtrl; // Switch Chip Select
output LEDCtrl;
output TubeCtrl;

assign addr_out = addr_in;
// The data wirte to register file may be from memory or io. 
// While the data is from io, it should be the lower 16bit of r_wdata. 
assign r_wdata = ioRead ? io_rdata : m_rdata;

// Chip select signal of Led and Switch are all active high;
// assign LEDCtrl = ioWrite;
assign SwitchCtrl = ioRead;

always @* begin
     if((mWrite==1)||(ioWrite==1))
        //wirte_data could go to either memory or IO. where is it from?
        write_data = r_rdata;
    // else
    //     write_data = 32'hZZZZZZZZ;
end

endmodule
