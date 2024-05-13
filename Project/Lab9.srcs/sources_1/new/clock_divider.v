`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/09 13:58:01
// Design Name: 
// Module Name: clock_divider
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


module clock_divider(
input clk,
output reg tube_clk // clk for seven segment tube(200Hz)
    );
// 32 bits counter for dividing frequency    
reg [31:0] count3; 
initial begin
count3<=0;
tube_clk<=0;
end
always @ (posedge clk) begin
if(count3==(50000>>1)-1) begin
tube_clk <= ~tube_clk; // invert clock
count3<=0;
end 
else begin
count3 <= count3+1;
end
end
endmodule
