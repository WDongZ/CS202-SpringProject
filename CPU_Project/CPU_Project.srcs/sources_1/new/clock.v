module clock(in, out, upg_out, tube_clk);
input in;
output out;
output upg_out;
output reg tube_clk;
cpuclk clk (
    .clk_in1(in),
    .clk_out1(out),
    .clk_out2(upg_out)
);
reg [31:0] count3; 
initial begin
count3<=0;
tube_clk<=0;
end
always @ (posedge in) begin
if(count3==(50000>>1)-1) begin
tube_clk <= ~tube_clk; // invert clock
count3<=0;
end 
else begin
count3 <= count3+1;
end
end
endmodule
