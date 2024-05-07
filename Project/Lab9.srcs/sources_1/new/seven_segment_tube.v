`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2024/05/07 23:16:12
// Design Name: 
// Module Name: seven_segment_tube
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


module seven_segment_tube(
input tubeCtrl,
input [31:0] code,
input clk,
output [3:0]tub_sel1,// 4'b1000 or 4'b0100 or 4'b0010 or 4'b0001
output [3:0]tub_sel2,// 4'b1000 or 4'b0100 or 4'b0010 or 4'b0001
output reg [7:0] tub_control1,
output reg [7:0] tub_control2
    );
reg [3:0]state1;
reg [3:0]state2;
assign tub_sel1 = state1;
assign tub_sel2 = state2;
initial begin
{state1,state2} = {4'b0001,4'b0001};
end
always@(posedge clk) begin
if(tubeCtrl) begin 

case({state1,state2})
{4'b0001,4'b0001}:begin
case(code[31:28])
4'b0001:tub_control1 = 8'b0110_0000;// 1
4'b0010:tub_control1 = 8'b1101_1010;// 2
4'b0011:tub_control1 = 8'b1111_0010;// 3
4'b0100:tub_control1 = 8'b0110_0110;// 4
4'b0101:tub_control1 = 8'b1011_0110;// 5
4'b0110:tub_control1 = 8'b1011_1110;// 6
4'b0111:tub_control1 = 8'b1110_0000;// 7
4'b1000:tub_control1 = 8'b1111_1110;// 8
4'b1001:tub_control1 = 8'b1110_0110;// 9
4'b1010:tub_control1 = 8'b1110_1110;// a
4'b1011:tub_control1 = 8'b0011_1110;// b
4'b1100:tub_control1 = 8'b1001_1100;// c
4'b1101:tub_control1 = 8'b0111_1010;// d
4'b1110:tub_control1 = 8'b1101_1110;// e
4'b1111:tub_control1 = 8'b1000_1110;// f
default:tub_control1 = 8'b1111_1100;// 0
endcase
case(code[15:12])
4'b0001:tub_control2 = 8'b0110_0000;// 1
4'b0010:tub_control2 = 8'b1101_1010;// 2
4'b0011:tub_control2 = 8'b1111_0010;// 3
4'b0100:tub_control2 = 8'b0110_0110;// 4
4'b0101:tub_control2 = 8'b1011_0110;// 5
4'b0110:tub_control2 = 8'b1011_1110;// 6
4'b0111:tub_control2 = 8'b1110_0000;// 7
4'b1000:tub_control2 = 8'b1111_1110;// 8
4'b1001:tub_control2 = 8'b1110_0110;// 9
4'b1010:tub_control2 = 8'b1110_1110;// a
4'b1011:tub_control2 = 8'b0011_1110;// b
4'b1100:tub_control2 = 8'b1001_1100;// c
4'b1101:tub_control2 = 8'b0111_1010;// d
4'b1110:tub_control2 = 8'b1101_1110;// e
4'b1111:tub_control2 = 8'b1000_1110;// f
default:tub_control2 = 8'b1111_1100;// 0
endcase
end
{4'b1000,4'b1000}:begin
case(code[27:24])
4'b0001:tub_control1 = 8'b0110_0000;// 1
4'b0010:tub_control1 = 8'b1101_1010;// 2
4'b0011:tub_control1 = 8'b1111_0010;// 3
4'b0100:tub_control1 = 8'b0110_0110;// 4
4'b0101:tub_control1 = 8'b1011_0110;// 5
4'b0110:tub_control1 = 8'b1011_1110;// 6
4'b0111:tub_control1 = 8'b1110_0000;// 7
4'b1000:tub_control1 = 8'b1111_1110;// 8
4'b1001:tub_control1 = 8'b1110_0110;// 9
4'b1010:tub_control1 = 8'b1110_1110;// a
4'b1011:tub_control1 = 8'b0011_1110;// b
4'b1100:tub_control1 = 8'b1001_1100;// c
4'b1101:tub_control1 = 8'b0111_1010;// d
4'b1110:tub_control1 = 8'b1101_1110;// e
4'b1111:tub_control1 = 8'b1000_1110;// f
default:tub_control1 = 8'b1111_1100;// 0
endcase
case(code[11:8])
4'b0001:tub_control2 = 8'b0110_0000;// 1
4'b0010:tub_control2 = 8'b1101_1010;// 2
4'b0011:tub_control2 = 8'b1111_0010;// 3
4'b0100:tub_control2 = 8'b0110_0110;// 4
4'b0101:tub_control2 = 8'b1011_0110;// 5
4'b0110:tub_control2 = 8'b1011_1110;// 6
4'b0111:tub_control2 = 8'b1110_0000;// 7
4'b1000:tub_control2 = 8'b1111_1110;// 8
4'b1001:tub_control2 = 8'b1110_0110;// 9
4'b1010:tub_control2 = 8'b1110_1110;// a
4'b1011:tub_control2 = 8'b0011_1110;// b
4'b1100:tub_control2 = 8'b1001_1100;// c
4'b1101:tub_control2 = 8'b0111_1010;// d
4'b1110:tub_control2 = 8'b1101_1110;// e
4'b1111:tub_control2 = 8'b1000_1110;// f
default:tub_control2 = 8'b1111_1100;// 0
endcase
{state1,state2} = {4'b0100,4'b0100};// 8'b0100_0100
end
{4'b0100,4'b0100}:begin
case(code[23:20])
4'b0001:tub_control1 = 8'b0110_0000;// 1
4'b0010:tub_control1 = 8'b1101_1010;// 2
4'b0011:tub_control1 = 8'b1111_0010;// 3
4'b0100:tub_control1 = 8'b0110_0110;// 4
4'b0101:tub_control1 = 8'b1011_0110;// 5
4'b0110:tub_control1 = 8'b1011_1110;// 6
4'b0111:tub_control1 = 8'b1110_0000;// 7
4'b1000:tub_control1 = 8'b1111_1110;// 8
4'b1001:tub_control1 = 8'b1110_0110;// 9
4'b1010:tub_control1 = 8'b1110_1110;// a
4'b1011:tub_control1 = 8'b0011_1110;// b
4'b1100:tub_control1 = 8'b1001_1100;// c
4'b1101:tub_control1 = 8'b0111_1010;// d
4'b1110:tub_control1 = 8'b1101_1110;// e
4'b1111:tub_control1 = 8'b1000_1110;// f
default:tub_control1 = 8'b1111_1100;// 0
endcase
case(code[7:4])
4'b0001:tub_control2 = 8'b0110_0000;// 1
4'b0010:tub_control2 = 8'b1101_1010;// 2
4'b0011:tub_control2 = 8'b1111_0010;// 3
4'b0100:tub_control2 = 8'b0110_0110;// 4
4'b0101:tub_control2 = 8'b1011_0110;// 5
4'b0110:tub_control2 = 8'b1011_1110;// 6
4'b0111:tub_control2 = 8'b1110_0000;// 7
4'b1000:tub_control2 = 8'b1111_1110;// 8
4'b1001:tub_control2 = 8'b1110_0110;// 9
4'b1010:tub_control2 = 8'b1110_1110;// a
4'b1011:tub_control2 = 8'b0011_1110;// b
4'b1100:tub_control2 = 8'b1001_1100;// c
4'b1101:tub_control2 = 8'b0111_1010;// d
4'b1110:tub_control2 = 8'b1101_1110;// e
4'b1111:tub_control2 = 8'b1000_1110;// f
default:tub_control2 = 8'b1111_1100;// 0
endcase
{state1,state2} = {4'b0010,4'b0010};// 8'b0010_0010
end
{4'b0010,4'b0010}:begin
case(code[19:16])
4'b0001:tub_control1 = 8'b0110_0000;// 1
4'b0010:tub_control1 = 8'b1101_1010;// 2
4'b0011:tub_control1 = 8'b1111_0010;// 3
4'b0100:tub_control1 = 8'b0110_0110;// 4
4'b0101:tub_control1 = 8'b1011_0110;// 5
4'b0110:tub_control1 = 8'b1011_1110;// 6
4'b0111:tub_control1 = 8'b1110_0000;// 7
4'b1000:tub_control1 = 8'b1111_1110;// 8
4'b1001:tub_control1 = 8'b1110_0110;// 9
4'b1010:tub_control1 = 8'b1110_1110;// a
4'b1011:tub_control1 = 8'b0011_1110;// b
4'b1100:tub_control1 = 8'b1001_1100;// c
4'b1101:tub_control1 = 8'b0111_1010;// d
4'b1110:tub_control1 = 8'b1101_1110;// e
4'b1111:tub_control1 = 8'b1000_1110;// f
default:tub_control1 = 8'b1111_1100;// 0
endcase
case(code[3:0])
4'b0001:tub_control2 = 8'b0110_0000;// 1
4'b0010:tub_control2 = 8'b1101_1010;// 2
4'b0011:tub_control2 = 8'b1111_0010;// 3
4'b0100:tub_control2 = 8'b0110_0110;// 4
4'b0101:tub_control2 = 8'b1011_0110;// 5
4'b0110:tub_control2 = 8'b1011_1110;// 6
4'b0111:tub_control2 = 8'b1110_0000;// 7
4'b1000:tub_control2 = 8'b1111_1110;// 8
4'b1001:tub_control2 = 8'b1110_0110;// 9
4'b1010:tub_control2 = 8'b1110_1110;// a
4'b1011:tub_control2 = 8'b0011_1110;// b
4'b1100:tub_control2 = 8'b1001_1100;// c
4'b1101:tub_control2 = 8'b0111_1010;// d
4'b1110:tub_control2 = 8'b1101_1110;// e
4'b1111:tub_control2 = 8'b1000_1110;// f
default:tub_control2 = 8'b1111_1100;// 0
endcase
{state1,state2} = {4'b0010,4'b0010};// 8'b0001_0001
end
endcase
end
end
endmodule
