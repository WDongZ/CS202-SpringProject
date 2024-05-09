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


module switches(clk,rst,switchCtrl,button5,signal,switches,switchData);
input clk;
input rst;
input switchCtrl;
input[4:0] button5;
input[2:0] addr;
input[15:0] switches;
output[15:0] switchData; 
reg [15:0] switchData;
    always@(posedge clk or posedge rst) begin
    if(rst) begin
        switchData <= 0;
    end
    else if(switchCtrl) begin
        if(addr==3'b000)
            switchData[15:0] <= {8'b0,switches[15:8]};
        else if(addr==3'b010)
            switchData[15:0] <= switches[15:0];
        else if(addr==3'b100)
            switchData[15:0] <= {15'b0,button};
        else 
            switchData <= switchData;
    end
    else begin
        switchData <= switchData;
    end
end
endmodule
