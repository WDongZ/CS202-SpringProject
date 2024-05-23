module key_filter
#(
parameter CNT_MAX = 21'd2000_000 //计数器计数最大值
)
(
input wire sys_clk , //系统时钟100MHz
input wire sys_rst_n , //全局复位
input wire key_in , //按键输入信号

output reg key_flag //key_flag为1时表示消抖后检测到按键被按下
//key_flag为0时表示没有检测到按键被按下
);

reg [19:0] cnt_20ms ; //计数器

always@(posedge sys_clk or negedge sys_rst_n)
if(sys_rst_n == 1'b0)
cnt_20ms <= 21'b0;
else if(key_in == 1'b1)
cnt_20ms <= 21'b0;
else if(cnt_20ms == CNT_MAX && key_in == 1'b0)
cnt_20ms <= cnt_20ms;
else
cnt_20ms <= cnt_20ms + 1'b1;

always@(posedge sys_clk or negedge sys_rst_n)
if(sys_rst_n == 1'b0)
key_flag <= 1'b0;
else if(cnt_20ms == CNT_MAX - 1'b1)
key_flag <= 1'b1;
else
key_flag <= 1'b0;

endmodule