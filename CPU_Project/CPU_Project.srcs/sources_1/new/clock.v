module clock(in, out, upg_out);
input in;
output out;
output upg_out;
cpuclk clk (
    .clk_in1(in),
    .clk_out1(out),
    .clk_out2(upg_out)
);
endmodule
