module executs32(Read_data_1,Read_data_2,Sign_extend,opcode,funct3,ALUOp,
                 funct7,ALUSrc,I_format,Zero,Jr,ALU_Result,Addr_Result,PC
                 );
    input[31:0]  Read_data_1;		// Data from register_1.
    input[31:0]  Read_data_2;		// Data from register_2
    input[31:0]  Sign_extend;		// Sign extend 0 of 1
    
    input[6:0]   opcode;  	         // Opcode from inst[6:0]
    input[2:0]   funct3;  		    // Funct3 from inst[14:12]
    input[1:0]   ALUOp;             // ALU operator
    input[6:0]   funct7;             // Funct7 from inst[31:25]
    input        ALUSrc;            // ALU sorce 
    input        I_format;          // If inst is I signal from ctrlor
    input        Jr;               // If jr type from ctrlor
    output       Zero;              // If result is 0
    output[31:0] ALU_Result;        // ALU result
    output[31:0] Addr_Result;		// Address result to ifetch
    input[31:0]  PC;                //PC
 
    //assign Addr_Result = Jr? (Read_data_1<<2): (PC_plus_4 + (Sign_extend<<2));
    assign Addr_Result = (PC+(Sign_extend));
    wire[31:0] Ainput,Binput; // two operands for calculation
    wire[5:0] Exe_code; // use to generate ALU_ctrl. (I_format==0) ? Function_opcode : { 3'b000 , Opcode[2:0] };
    reg[2:0] ALU_ctl; // the control signals which affact operation in ALU directely
    wire[2:0] Sftm; // identify the types of shift instruction, equals to Function_opcode[2:0]
    reg[31:0] Shift_Result=0; // the result of shift operation
    reg[31:0] ALU_output_mux=0; // the result of arithmetic or logic calculation
    wire[32:0] Branch_Addr; // the calculated address of the instruction, Addr_Result is Branch_Addr[31:0]
    
    assign Ainput = Read_data_1;
    assign Binput = (ALUSrc == 0) ? Read_data_2 : Sign_extend[31:0];
    always @ *  begin
        case(ALUOp)
         2'b00,2'b01: ALU_ctl = { ALUOp[0], 2'b11};
         2'b10: begin
                case(funct3)
                    3'h0: ALU_ctl = (funct7 == 7'h20 && ALUSrc == 1'b0) ? 3'h7 : 3'h2;
                    3'h7: ALU_ctl = 3'h0;
                    3'h6: ALU_ctl = 3'h1;
                    3'h4: ALU_ctl = 3'h4;
                    3'h1: ALU_ctl = 3'h5;
                    3'h5: ALU_ctl = 3'h6;
                endcase
             end
         endcase
    end
    reg[31:0] ALU_output=0;
    assign ALU_Result = ALU_output;
    always @*
    begin
        case(ALU_ctl)
        3'b000: ALU_output_mux = (Ainput & Binput);
        3'b001: ALU_output_mux = (Ainput | Binput);
        3'b010: ALU_output_mux = (Ainput + Binput);
        3'b011: ALU_output_mux = (Ainput + Binput);
        3'b100: ALU_output_mux = (Ainput ^ Binput);
        3'b101: ALU_output_mux = (Ainput << Binput);
        3'b110: ALU_output_mux = (Ainput >> Binput);
        3'b111: ALU_output_mux = (Ainput - Binput);
        default: ALU_output_mux = 32'b0000_0000_0000_0000_0000_0000_0000_0000;
        endcase
    end
    
    
    always @* begin
    //lui operation
        if(opcode == 7'h37)
            ALU_output[31:0]= {Binput,12'h000};
    //other types of operation in ALU (arithmatic or logic calculation)
        else
            ALU_output = ALU_output_mux[31:0];
    end
    wire blt;
    wire bge;
    wire bltu;
    wire bgeu;
    assign blt = (Ainput < Binput)? 1'b1:1'b0;
    assign bge = (Ainput >= Binput)? 1'b1:1'b0;
    assign bltu = (Ainput < Binput)? 1'b1:1'b0;
    assign bgeu = (Ainput >= Binput)? 1'b1:1'b0;
    assign Zero = ((ALU_Result==32'b0 && funct3==3'b000)||(ALU_Result!=32'b0 && funct3==3'b001)||(blt && funct3==3'b100)||(bge && funct3==3'b101)||(bltu && funct3==3'b110)||(bgeu && funct3==3'b111))? 1'b1: 1'b0;
    //assign Zero = ((Exe_opcode==6'b000000&&Function_opcode==6'b001000)||((Ainput==Binput) && (Exe_opcode == 6'b000100))||(Ainput!=Binput)&&(Exe_opcode==6'b000101));
endmodule
