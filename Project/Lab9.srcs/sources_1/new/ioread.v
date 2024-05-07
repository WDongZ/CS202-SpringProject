`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module ioread (reset,ior,switchctrl,ioread_data_switch,ioread_data);
   input			reset;				// reset, active high ��λ�ź� (�ߵ�ƽ��Ч)
   input            ior;                // from Controller, 1 means read from input device(�ӿ���������I/O��)
   input            switchctrl;            // means the switch is selected as input device (��memorio������ַ�߶��߻�õĲ��뿪��ģ��Ƭѡ)
   input    [7:0]    ioread_data_switch;    // the data from switch(���������Ķ����ݣ��˴����Բ��뿪��)
   output    [7:0]    ioread_data;         // the data to memorio (���������������͸�memorio)
    
    reg [7:0] ioread_data;
    
    always @* begin
        if (reset)
            ioread_data = 8'h00;
        else if (ior == 1) begin
            if (switchctrl == 1)
                ioread_data = ioread_data_switch;
            else
				ioread_data = ioread_data;
        end
    end
	
endmodule
