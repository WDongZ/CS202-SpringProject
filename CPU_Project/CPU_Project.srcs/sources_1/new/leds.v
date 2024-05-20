`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////

module leds (
    input			ledrst,		// reset, active high (复位信号,高电平有效)
    input			led_clk,	// clk for led (时钟信号)
    input			ledcs,		// 1 means the leds are selected as output (从memorio来的，由低至高位形成的LED片选信号)
    input	[1:0]	ledaddr,	// 2'b00 means updata the low 16bits of ledout, 2'b10 means updata the high 8 bits of ledout
    input	[15:0]	ledwdata,	// the data (from register/memorio)  waiting for to be writen to the leds of the board
    output reg [15:0]	ledout		// the data writen to the leds  of the board
);
  
    
    always @ * begin
        if (ledrst)
            ledout = 16'h000000;
		//!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
		else if (ledcs) begin
			if (ledaddr == 2'b00)
				ledout[15:0] = { ledwdata[15:8], ledout[7:0] };
			else if (ledaddr == 2'b10 )
				ledout[15:0] = { ledout[15:8], ledwdata[7:0] };
			else
				ledout = ledout;
        end else begin
            ledout = ledout;
        end
    end
	
endmodule
