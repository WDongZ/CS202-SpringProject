module Tube(
        rst,op,data,clk,
        out1,seg_en
    );
    input rst;
    input op;
    input [15:0]data;
    input clk;
    output[7:0] out1;
    output[7:0] seg_en;
    
    reg clk_ = 1'b0;
    reg [7:0]out = 8'h00;
    reg [7:0]add = 8'h00;
    reg [13:0]ct=0;
    reg [1:0]v=0;
    reg [15:0]w_data=0;
    always @(negedge clk)begin
        if (rst)begin
            ct<=0;
            w_data = 0;
        end 
        else begin
            if (op)w_data<=data;
            if (ct==0)begin 
                clk_<=~clk_;
                ct<=ct+1;
            end
            else begin
                ct<=ct+1;
            end
        end
    end
    
    reg [3:0]d;
    always @(posedge clk_)begin
        v<=v+1;
    end
    always @(v)begin
        case (v)
            0:  begin
                    d<=w_data[3:0];
                    add<=8'b00000001;
                end
            1: begin
                    d<=w_data[7:4];
                    add<=8'b00000010;
                end
            2: begin
                    d<=w_data[11:8];
                    add<=8'b00000100;
                end
            3: begin
                    d<=w_data[15:12];
                    add<=8'b00001000;
                end
        endcase
    end
    always @(d)begin
        case (d[3:0])
            4'h0: out<= 8'b11111100;
            4'h1: out<= 8'b01100000;
            4'h2: out<= 8'b11011010;
            4'h3: out<= 8'b11110010;
            4'h4: out<= 8'b01100110;
            4'h5: out<= 8'b10110110;
            4'h6: out<= 8'b10111110;
            4'h7: out<= 8'b11100000;
            4'h8: out<= 8'b11111110;
            4'h9: out<= 8'b11100110;
            4'ha: out<= 8'b11101110;
            4'hb: out<= 8'b00111110;
            4'hc: out<= 8'b00011010;
            4'hd: out<= 8'b01111010;
            4'he: out<= 8'b10011110;
            4'hf: out<= 8'b10001110;
            default: out<=8'b0000000;
        endcase
    end
    assign out1=~out;
    assign seg_en=~add;
    
    
    
endmodule
