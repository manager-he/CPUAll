module CU (
    input clk, rst,
    input [5:0] op, func,
    input [4:0] base,
    input alu_zero, alu_negative, mul_busy,
    output IRin, PCin, 
    
    output [1:0] MuxPC, MuxA, 
    output [2:0] MuxB,
    output [3:0] ALUC,
    output Zin,

    output RF_W,
    output [2:0] MuxRF,
    output [1:0] MuxRF_waddr,

    output DM_EN, DM_W, DM_bit, DM_halfw, DM_word, DM_signed,

    output MUL_ena, MUL_mul, MUL_signed,

    output LOin, HIin, MuxLO, MuxHI,

    output MFC0, MTC0, Exception, ERET, 
    output [4:0] cause,

    output Print
);
    // 指令译码
    wire add_=(op==6'b0)?(func==6'b100000)?1:0:0;
    wire addu_=(op==6'b0)?(func==6'b100001)?1:0:0;
    wire sub_=(op==6'b0)?(func==6'b100010)?1:0:0;
    wire subu_=(op==6'b0)?(func==6'b100011)?1:0:0;
    wire and_=(op==6'b0)?(func==6'b100100)?1:0:0;
    wire or_=(op==6'b0)?(func==6'b100101)?1:0:0;
    wire xor_=(op==6'b0)?(func==6'b100110)?1:0:0;
    wire nor_=(op==6'b0)?(func==6'b100111)?1:0:0;
    wire slt_=(op==6'b0)?(func==6'b101010)?1:0:0;
    wire sltu_=(op==6'b0)?(func==6'b101011)?1:0:0;
    wire sll_=(op==6'b0)?(func==6'b000000)?1:0:0;
    wire srl_=(op==6'b0)?(func==6'b000010)?1:0:0;
    wire sra_=(op==6'b0)?(func==6'b000011)?1:0:0;
    wire sllv_=(op==6'b0)?(func==6'b000100)?1:0:0;
    wire srlv_=(op==6'b0)?(func==6'b000110)?1:0:0;
    wire srav_=(op==6'b0)?(func==6'b000111)?1:0:0;
    wire jr_=(op==6'b0)?(func==6'b001000)?1:0:0;
    wire addi_=(op==6'b001000)?1:0;
    wire addiu_=(op==6'b001001)?1:0;
    wire andi_=(op==6'b001100)?1:0;
    wire ori_=(op==6'b001101)?1:0;
    wire xori_=(op==6'b001110)?1:0;
    wire lw_=(op==6'b100011)?1:0;
    wire sw_=(op==6'b101011)?1:0;
    wire beq_=(op==6'b000100)?1:0;
    wire bne_=(op==6'b000101)?1:0;
    wire slti_=(op==6'b001010)?1:0;
    wire sltiu_=(op==6'b001011)?1:0;
    wire lui_=(op==6'b001111)?1:0;
    wire j_=(op==6'b000010)?1:0;
    wire jal_=(op==6'b000011)?1:0;
    wire clz_=(op==6'b011100)?(func==6'b100000)?1:0:0;
    wire jalr_=(op==6'b000000)?(func==6'b001001)?1:0:0;
    wire bgez_=(op==6'b000001)?1:0;
    wire lb_=(op==6'b100000)?1:0;
    wire lbu_=(op==6'b100100)?1:0;
    wire lhu_=(op==6'b100101)?1:0;
    wire sb_=(op==6'b101000)?1:0;
    wire sh_=(op==6'b101001)?1:0;
    wire lh_=(op==6'b100001)?1:0;
    wire mfc0_=(op==6'b010000)?(base==5'b00000)?1:0:0;
    wire mtc0_=(op==6'b010000)?(base==5'b00100)?1:0:0;
    wire mflo_=(op==6'b000000)?(func==6'b010010)?1:0:0;
    wire mfhi_=(op==6'b000000)?(func==6'b010000)?1:0:0;
    wire mthi_=(op==6'b000000)?(func==6'b010001)?1:0:0;
    wire mtlo_=(op==6'b000000)?(func==6'b010011)?1:0:0;
    wire syscall_=(op==6'b000000)?(func==6'b001100)?1:0:0;
    wire teq_=(op==6'b000000)?(func==6'b110100)?1:0:0;
    wire break_=(op==6'b000000)?(func==6'b001101)?1:0:0;
    wire eret_=(op==6'b010000)?(func==6'b011000)?1:0:0;
    wire mult_=(op==6'b000000)?(func==6'b011000)?1:0:0;
    wire multu_=(op==6'b000000)?(func==6'b011001)?1:0:0;
    wire div_=(op==6'b000000)?(func==6'b011010)?1:0:0;
    wire divu_=(op==6'b000000)?(func==6'b011011)?1:0:0;

    // 指令分类
    wire AType = add_ | addu_ | addi_ | addiu_ | sub_ | subu_ | sll_ | sllv_ | sra_ | srav_ | srl_ | srlv_ | 
            clz_ | andi_ | and_ | ori_ | or_ | xori_ | xor_ | nor_ | slt_ | sltu_ | slti_ | sltiu_ | lui_;
    wire BType = lb_ | lbu_ | lhu_ | lw_ | sw_ | sb_ | sh_ | lh_ ;
    wire CType = mfhi_ | mflo_ | mfhi_ | mthi_ | mtlo_ | mtc0_ | mfc0_ ;
    wire DType = mult_ | multu_ | div_ | divu_ ;
    // 定义时钟信号
    reg t0, t1, t2;
    always @(negedge clk or posedge rst) begin
        if(rst) begin
            t0 <= 0; t1 <= 0; t2 <= 0;
        end
        else begin
            t0 <= (~t2 & ~t1 & ~t0) | (~t2 & t1 & ~t0) & (AType | BType | DType |
                 beq_&alu_zero | bne_&~alu_zero | bgez_&~alu_negative | jal_ | jalr_ | teq_&alu_zero | break_ | syscall_ | eret_) |
                 (~t2 & t1 & t0) & DType&mul_busy;
            t1 <= (~t2 & ~t1 & t0) | (~t2 & t1 & ~t0) & (AType | BType | DType |
                 beq_&alu_zero | bne_&~alu_zero | bgez_&~alu_negative | jal_ | jalr_ | teq_&alu_zero | break_ | syscall_ | eret_) |
                 (~t2 & t1 & t0) & DType&mul_busy;
            t2 <= (~t2 & t1 & t0) & (beq_ | bne_ | bgez_ | teq_ | DType&~mul_busy);            
        end
    end
    wire T1, T2, T3, T4, T5;
    assign T1 = ~t2 & ~t1 & ~t0;
    assign T2 = ~t2 & ~t1 & t0;
    assign T3 = ~t2 & t1 & ~t0;
    assign T4 = ~t2 & t1 & t0;
    assign T5 = t2 & ~t1 & ~t0;

    // Print
    assign Print = T1;

    // PC IR
    assign IRin = T1;
    assign PCin = T2 | (j_|jr_)&T3 | (jal_|jalr_)&T4 | (break_ | syscall_ | eret_)&T4 | teq_&T5 |
                  (beq_ | bne_ | bgez_)&T5;
    assign MuxPC[0] = jr_&T3 | jalr_&T4 | (syscall_ | break_ | eret_)&T4 | teq_&T5;    // rs + CP0 -> PC
    assign MuxPC[1] = j_&T3  | jal_&T4  | (syscall_ | break_ | eret_)&T4 | teq_&T5;    // || + CP0-> PC

    // ALUC
    // Most time run add
    // new inst are clz, bgez, teq compared to MIPS31;
    assign ALUC[0]  = (slt_ | sltu_ | sll_ | srl_ | sra_ | sllv_ | srlv_ |
                      srav_ | slti_ | sltiu_ | lui_ | clz_) & T3;
    assign ALUC[1]  = (and_ | or_ | xor_ | nor_ | sra_ | srav_ |
                      andi_ | ori_ | xori_ | lui_ | clz_) & T3;
    assign ALUC[2]  = (sub_ | subu_ | xor_ | nor_ | sll_ | srl_ | sllv_ | srlv_ |
                      xori_ | beq_ | bne_ | teq_ | clz_) & T3;
    assign ALUC[3]  = (addu_ | subu_ | or_ | nor_ | sltu_ | srl_ | srlv_ | addiu_ |
                      ori_ | beq_ | bne_ | bgez_ | sltiu_ | lui_ | jal_ | clz_ & T3);
    // Defalut: rs
    assign MuxA[0] = (sll_ | srl_ | sra_)&T3;           // sa
    assign MuxA[1] = T1 | (beq_ | bne_ | bgez_)&T4;     // PC
    // 000:rt, 001:0, 010:offset||O2, 011:imm, 100:offset, 101:4
    assign MuxB[0] = T1 | (ori_ | xori_ | andi_)&T3 | bgez_&T3;
    assign MuxB[1] = (ori_ | xori_ | andi_)&T3 | BType&T3 | (beq_ | bne_ | bgez_)&T4;
    assign MuxB[2] = T1 | (addi_ | addiu_ | slti_ | sltiu_ | lui_)&T3;
    assign Zin = T1 | AType&T3 | BType&T3 | (beq_ | bne_ | bgez_ | teq_)&T3 | (beq_ | bne_ | bgez_)&T4;

    // RegFiles
    assign RF_W     = AType&T4 | (mfhi_ | mflo_ | mfc0_)&T3 | (jal_ | jalr_)&T3 | (lb_ | lbu_ | lh_ | lhu_ | lw_)&T4;
    // RF_data: 000:_Z, 001:_hi, 010:_lo, 011:_CP0, 100:_PC, 101:_DM 
    assign MuxRF[0] = mfhi_ | mfc0_ | BType;
    assign MuxRF[1] = mflo_ | mfc0_;
    assign MuxRF[2] = jal_ | jalr_ | BType;
    // RF_waddr: 00:rdc, 01:rtc, 10:31
    assign MuxRF_waddr[0] = mfc0_&T3 | BType&T4 | (addi_ | addiu_ | andi_ | ori_ | xori_ | slti_ | sltiu_ | lui_)&T4 ;
    assign MuxRF_waddr[1] = (jal_ | jalr_)&T3;

    // DMEM
    assign DM_EN    = BType&T4;
    assign DM_W     = (sb_ | sh_ | sw_)&T4;
    assign DM_bit   = (lb_ | lbu_ | sb_)&T4;
    assign DM_halfw = (lh_ | lhu_ | sh_)&T4;
    assign DM_word  = (lw_ | sw_)&T4;
    assign DM_signed = (lb_ | lh_ | lw_)&T4;// only read signed

    // MULT and DIV
    assign MUL_ena = DType&T3;
    assign MUL_mul = (mult_ | multu_)&T3;
    assign MUL_signed = (mult_ | div_)&T3;

    // HI and LO
    assign LOin = DType&T5 | mtlo_&T3;
    assign HIin = DType&T5 | mthi_&T3;
    assign MuxHI = mthi_&T3;    //rs, Default:Z1
    assign MuxLO = mtlo_&T3;    //rs, Default:Z2    

    // CP0
    assign MFC0 = mfc0_&T3;
    assign MTC0 = mtc0_&T3;
    assign Exception = (syscall_ | break_)&T3 | teq_&T4;
    assign ERET = eret_&T3;
    assign cause = syscall_&T3? 5'b01000 : break_&T3? 5'b01001 : teq_&T4? 5'b01101 : 5'b00000;

endmodule