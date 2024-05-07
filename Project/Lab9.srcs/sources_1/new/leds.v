`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (ledrst,led_clk,ledwrite,ledcs,ledaddr,ledwdata,ledout,digit_led7);
    input			ledrst;		// reset, active high (��λ�ź�,�ߵ�ƽ��Ч)
    input            led_clk;    // clk for led (ʱ���ź�)
    input            ledwrite;    // led write enable, active high (д�ź�,�ߵ�ƽ��Ч)
    input            ledcs;        // 1 means the leds are selected as output (��memorio���ģ��ɵ�����λ�γɵ�LEDƬѡ�ź�)
    input    [2:0]    ledaddr;    // 2'b00 means updata the low 16bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input    [31:0]    ledwdata;    // the data (from register/memorio)  waiting for to be writen to the leds of the board
    output    [15:0]    ledout;        // the data writen to the leds  of the board
    output    [31:0]    digit_led7;
  
    reg [15:0] ledout;
    reg [31:0] digit_led7;
    
    always @ (posedge led_clk or posedge ledrst) begin
        if (ledrst)
            ledout <= 16'h0000;
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		else if (ledcs && ledwrite) begin
			if (ledaddr == 3'b000)
				ledout[15:0] <= {ledwdata[7:0],ledout[7:0]};
			else if (ledaddr == 3'b010 )
				ledout[15:0] <= {ledout[15:8],ledwdata[7:0]};
			else if (ledaddr == 3'b100 )
			    digit_led7[31:0] <= ledwdata[31:0];
			else
				ledout <= ledout;
        end else begin
            ledout <= ledout;
        end
    end
	
endmodule
