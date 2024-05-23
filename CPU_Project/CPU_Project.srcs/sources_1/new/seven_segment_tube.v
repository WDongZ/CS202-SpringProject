module seven_segment_tube(
input rst,
input tubeCtrl,
input [31:0] code,
input [31:0] addr,
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

reg [3:0] data1;
reg [3:0] data2;
reg [1:0] count=0;
reg [31:0] data=0;

always@(posedge clk or posedge rst) begin
if(rst) data <= 32'h0;
else begin
count <= count + 1;
if(tubeCtrl && addr==32'hfffffc64) data <= code;
end
end

always@(count) begin
case (count)
2'b00:begin
data1<=data[19:16];
state1<=4'b0001;
data2<=data[3:0];
state2<=4'b0001;
end
2'b01:begin
data1<=data[23:20];
state1<=4'b0010;
data2<=data[7:4];
state2<=4'b0010;
end
2'b10:begin
data1<=data[27:24];
state1<=4'b0100;
data2<=data[11:8];
state2<=4'b0100;
end
2'b11:begin
data1<=data[31:28];
state1<=4'b1000;
data2<=data[15:12];
state2<=4'b1000;
end
endcase
end

always @(data1) begin
case(data1)
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
end

always @(data2) begin
case(data2)
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

endmodule
