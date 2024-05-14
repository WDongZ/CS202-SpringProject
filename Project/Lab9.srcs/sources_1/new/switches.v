`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 22:23:23
// Design Name: 
// Module Name: switches
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module switches(clk,rst,switchCtrl,button4,addr,switches,switchData);
input clk;
input rst;
input switchCtrl;
input[3:0] button4;
input[4:0] addr; // 70(10000)读入拨码开关,78(11000)编码开关,64(00100)是七段数码管,(10100)74是确认按键
input[15:0] switches;
output[15:0] switchData; 
reg [15:0] switchData;
    always@(posedge clk or posedge rst) begin
    if(rst) begin
        switchData <= 0;
    end
    else if(switchCtrl) begin
        if(addr==5'b10000)
            switchData[15:0] <= {8'b0,switches[15:8]};
        else if(addr==5'b11000)
            switchData[15:0] <= {8'b0,switches[7:0]};
        else if(addr==5'b10100)
            switchData[15:0] <= {15'b0,button4[2]};
        else 
            switchData <= switchData;
    end
    else begin
        switchData <= switchData;
    end
end
endmodule
