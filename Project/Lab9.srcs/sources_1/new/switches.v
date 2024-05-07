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


module switches(clk,rst,switchCtrl,switchread,signal,switches,switchData);
input clk;
input rst;
input switchCtrl;
input switchread;
input[1:0] signal;
input[15:0] switches;
output[15:0] switchData; 
reg [15:0] switchData;
    always@(negedge clk or posedge rst) begin
    if(rst) begin
        switchData <= 0;
    end
    else if(switchCtrl && switchread) begin
        if(signal==2'b00)
            switchData[15:0] <= {switches[15:8],switchData[7:0]};
        else if(signal==2'b10)
            switchData[15:0] <= switches[15:0];
        else 
            switchData <= switchData;
    end
    else begin
        switchData <= switchData;
    end
end
endmodule
