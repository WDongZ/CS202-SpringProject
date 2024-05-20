`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread (
    input			reset,				// reset, active high ��λ�ź� (�ߵ�ƽ��Ч)
	input			ior,				// from Controller, 1 means read from input device(�ӿ���������I/O��)
    input			switchctrl,			// means the switch is selected as input device (��memorio������ַ�߶��߻�õĲ��뿪��ģ��Ƭѡ)
    input	[15:0]	ioread_data_switch,	// the data from switch(���������Ķ����ݣ��˴����Բ��뿪��)
    output reg	[31:0]	ioread_data, 		// the data to memorio (���������������͸�memorio)
    input   [3:0]   ioread_data_button,
    input   [2:0] addr
);
    
    
    always @* begin
        if (reset)
            ioread_data = 16'h0;
        else if (ior == 1) begin
            if (switchctrl == 1)
                if (addr == 3'h0) ioread_data = {16'h0,ioread_data_switch};
                else if (addr == 3'h4) ioread_data = {28'h0,ioread_data_button};
            else
				ioread_data = ioread_data;
        end
    end
	
endmodule
