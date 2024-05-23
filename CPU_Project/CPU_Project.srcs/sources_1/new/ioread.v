`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread (
    input           clk,
    input			reset,				// reset, active high ��λ�ź� (�ߵ�ƽ��Ч)
	input			ior,				// from Controller, 1 means read from input device(�ӿ���������I/O��)
    input			switchctrl,			// means the switch is selected as input device (��memorio������ַ�߶��߻�õĲ��뿪��ģ��Ƭѡ)
    input	[15:0]	ioread_data_switch,	// the data from switch(���������Ķ����ݣ��˴����Բ��뿪��)
    output reg	[31:0]	ioread_data, 		// the data to memorio (���������������͸�memorio)
    input   [3:0]       ioread_data_button,
    input   [31:0] addr
);
    
    
    always @(negedge clk or negedge reset) begin
        if (!reset)
            ioread_data <= 16'h0;
        else if (ior == 1) begin
            if (switchctrl == 1)
                if (addr == 32'hfffffc70) ioread_data <= {24'h0,ioread_data_switch[15:8]};
                else if (addr == 32'hfffffc72) ioread_data <= {24'h0,ioread_data_switch[7:0]};
                else if (addr == 32'hfffffc74) ioread_data <= {31'h0,ioread_data_button[0]};
                else if (addr == 32'hfffffc78) ioread_data <= {31'h0,ioread_data_button[1]};
        end
    end
	
endmodule
