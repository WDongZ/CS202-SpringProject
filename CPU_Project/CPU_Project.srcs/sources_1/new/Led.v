`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2022/05/26 22:15:07
// Design Name: 
// Module Name: Led
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


module Led(
    zero,op,data,r_data,Instruction, rst_in, clk
    );
    input zero;
    input rst_in;
    input clk;
    input[31:0] Instruction;
    input op;                   //show if op=1
    output reg[23:0] data;          //
    input[15:0] r_data;         //data

    wire enable;
    assign enable = (Instruction>0); 
    /*always @* begin
        out[23:18] <= (out[23:18]|opcode);
        out[15:0] <= (out[15:0]|r_data);
    end*/
    always @(negedge clk) begin
        if (rst_in) begin
            data = 0;
        end
        else if(op==1) begin
            //data = {Instruction[31:16],Instruction[7:0]};
            // data[23:18] = Instruction[31:26];
            // data[17] = zero;
            // data[16] = enable;

            data[15]=(r_data[15]&op);
            data[14]=(r_data[14]&op);
            data[13]=(r_data[13]&op);
            data[12]=(r_data[12]&op);
            data[11]=(r_data[11]&op);
            data[10]=(r_data[10]&op);
            data[9]=(r_data[9]&op);
            data[8]=(r_data[8]&op);
            data[7]=(r_data[7]&op);
            data[6]=(r_data[6]&op);
            data[5]=(r_data[5]&op);
            data[4]=(r_data[4]&op);
            data[3]=(r_data[3]&op);
            data[2]=(r_data[2]&op);
            data[1]=(r_data[1]&op);
            data[0]=(r_data[0]&op);
        end
        else 
            data = data;
    end

endmodule
