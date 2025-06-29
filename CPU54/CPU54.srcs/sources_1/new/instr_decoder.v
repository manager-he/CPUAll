`timescale 1ns / 1ps

module instr_decoder(           //指令译码器
    input [31:0] instr_code,    //32位指令码
    output _add,
    output _addu,
    output _sub,
    output _subu,
    output _and,
    output _or,
    output _xor,
    output _nor,
    output _slt,
    output _sltu,
    output _sll,
    output _srl,
    output _sra,
    output _sllv,
    output _srlv,
    output _srav,
    output _jr,
    output _addi,
    output _addiu,
    output _andi,
    output _ori,
    output _xori,
    output _lw,
    output _sw,
    output _beq,
    output _bne,
    output _slti,
    output _sltiu,
    output _lui,
    output _j,
    output _jal,
    output _div,
    output _divu,
    output _mult,
    output _multu,
    output _bgez,
    output _jalr,
    output _lbu,
    output _lhu,
    output _lb,
    output _lh,
    output _sb,
    output _sh,
    output _break,
    output _syscall,
    output _eret,
    output _mfhi,
    output _mflo,
    output _mthi,
    output _mtlo,
    output _mfc0,
    output _mtc0,
    output _clz,
    output _teq,
    output [4:0] Rsc,
    output [4:0] Rtc,
    output [4:0] Rdc,
    output [4:0] sa,
    output [15:0] imm16,
    output [25:0] target
    );
    /* 操作码编码 */
    /* R型指令，未标注的6位op全零，通过6位func区分 */
    parameter ADD_FUNC  = 6'b100000;
    parameter ADDU_FUNC = 6'b100001;
    parameter SUB_FUNC  = 6'b100010;
    parameter SUBU_FUNC = 6'b100011;
    parameter AND_FUNC  = 6'b100100;
    parameter OR_FUNC   = 6'b100101;
    parameter XOR_FUNC  = 6'b100110;
    parameter NOR_FUNC  = 6'b100111;
    parameter SLT_FUNC  = 6'b101010;
    parameter SLTU_FUNC = 6'b101011;
    parameter SLL_FUNC  = 6'b000000;
    parameter SRL_FUNC  = 6'b000010;
    parameter SRA_FUNC  = 6'b000011;
    parameter SLLV_FUNC = 6'b000100;
    parameter SRLV_FUNC = 6'b000110;
    parameter SRAV_FUNC = 6'b000111;
    parameter JR_FUNC   = 6'b001000;
    parameter JALR_FUNC = 6'b001001;
    parameter MFLO_FUNC = 6'b010010;
    parameter MFHI_FUNC = 6'b010000;
    parameter MTHI_FUNC = 6'b010001;
    parameter MTLO_FUNC = 6'b010011;
    parameter SYSCALL_FUNC  = 6'b001100;
    parameter TEQ_FUNC  = 6'b110100;
    parameter BREAK_FUNC    = 6'b001101;
    parameter MULT_FUNC = 6'b011000;
    parameter MULTU_FUNC    = 6'b011001;
    parameter DIV_FUNC  = 6'b011010;
    parameter DIVU_FUNC = 6'b011011;
    parameter ERET_OP   = 6'b010000;    //eret_op
    parameter ERET_FUNC = 6'b011000;
    parameter CLZ_OP    = 6'b011100;    //clz_op
    parameter CLZ_FUNC  = 6'b100000;
    /* I型指令和J型指令，通过6位op区分 */
    parameter ADDI_OP   = 6'b001000;
    parameter ADDIU_OP  = 6'b001001;
    parameter ANDI_OP   = 6'b001100;
    parameter ORI_OP    = 6'b001101;
    parameter XORI_OP   = 6'b001110;
    parameter LW_OP     = 6'b100011;
    parameter SW_OP     = 6'b101011;
    parameter BEQ_OP    = 6'b000100;
    parameter BNE_OP    = 6'b000101;
    parameter SLTI_OP   = 6'b001010;
    parameter SLTIU_OP  = 6'b001011;
    parameter LUI_OP    = 6'b001111;
    parameter J_OP      = 6'b000010;
    parameter JAL_OP    = 6'b000011;
    parameter BGEZ_OP   = 6'b000001;
    parameter LB_OP     = 6'b100000;
    parameter LBU_OP    = 6'b100100;
    parameter LHU_OP    = 6'b100101;
    parameter SB_OP     = 6'b101000;
    parameter SH_OP     = 6'b101001;
    parameter LH_OP     = 6'b100001;
    /* 特殊，op为010000，通过5位base区分 */
    parameter MFC0_BASE = 5'b00000;
    parameter MTC0_BASE = 5'b00100;
    
    /* 操作码译码 */
    //op = instr_code[31:26], func = instr_code[5:0], base = instr_code[25:21]
    //通过op和func和base判断指令类型
    /* R型指令 */
    assign _add = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==ADD_FUNC)) ? 1'b1 : 1'b0;
    assign _addu = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==ADDU_FUNC)) ? 1'b1 : 1'b0;
    assign _sub = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SUB_FUNC)) ? 1'b1 : 1'b0;
    assign _subu = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SUBU_FUNC)) ? 1'b1 : 1'b0;
    assign _and = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==AND_FUNC)) ? 1'b1 : 1'b0;
    assign _or = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==OR_FUNC)) ? 1'b1 : 1'b0;
    assign _xor = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==XOR_FUNC)) ? 1'b1 : 1'b0;
    assign _nor = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==NOR_FUNC)) ? 1'b1 : 1'b0;
    assign _slt = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SLT_FUNC)) ? 1'b1 : 1'b0;
    assign _sltu = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SLTU_FUNC)) ? 1'b1 : 1'b0;
    assign _sll = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SLL_FUNC)) ? 1'b1 : 1'b0;
    assign _srl = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SRL_FUNC)) ? 1'b1 : 1'b0;
    assign _sra = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SRA_FUNC)) ? 1'b1 : 1'b0;
    assign _sllv = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SLLV_FUNC)) ? 1'b1 : 1'b0;
    assign _srlv = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SRLV_FUNC)) ? 1'b1 : 1'b0;
    assign _srav = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SRAV_FUNC)) ? 1'b1 : 1'b0;
    assign _jr = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==JR_FUNC)) ? 1'b1 : 1'b0;
    assign _jalr = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==JALR_FUNC)) ? 1'b1 : 1'b0;
    assign _mflo = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==MFLO_FUNC)) ? 1'b1 : 1'b0;
    assign _mfhi = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==MFHI_FUNC)) ? 1'b1 : 1'b0;
    assign _mthi = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==MTHI_FUNC)) ? 1'b1 : 1'b0;
    assign _mtlo = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==MTLO_FUNC)) ? 1'b1 : 1'b0;
    assign _syscall = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==SYSCALL_FUNC)) ? 1'b1 : 1'b0;
    assign _teq = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==TEQ_FUNC)) ? 1'b1 : 1'b0;
    assign _break = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==BREAK_FUNC)) ? 1'b1 : 1'b0;
    assign _mult = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==MULT_FUNC)) ? 1'b1 : 1'b0;
    assign _multu = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==MULTU_FUNC)) ? 1'b1 : 1'b0;
    assign _div = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==DIV_FUNC)) ? 1'b1 : 1'b0;
    assign _divu = ((instr_code[31:26]==6'b0) && (instr_code[5:0]==DIVU_FUNC)) ? 1'b1 : 1'b0;
    assign _eret = ((instr_code[31:26]==ERET_OP) && (instr_code[5:0]==ERET_FUNC)) ? 1'b1 : 1'b0;
    assign _clz = ((instr_code[31:26]==CLZ_OP) && (instr_code[5:0]==CLZ_FUNC)) ? 1'b1 : 1'b0;
    /* I型和J型指令 */
    assign _addi = (instr_code[31:26]==ADDI_OP) ? 1'b1 : 1'b0;
    assign _addiu = (instr_code[31:26]==ADDIU_OP) ? 1'b1 : 1'b0;
    assign _andi = (instr_code[31:26]==ANDI_OP) ? 1'b1 : 1'b0;
    assign _ori = (instr_code[31:26]==ORI_OP) ? 1'b1 : 1'b0;
    assign _xori = (instr_code[31:26]==XORI_OP) ? 1'b1 : 1'b0;
    assign _lw = (instr_code[31:26]==LW_OP) ? 1'b1 : 1'b0;
    assign _sw = (instr_code[31:26]==SW_OP) ? 1'b1 : 1'b0;
    assign _beq = (instr_code[31:26]==BEQ_OP) ? 1'b1 : 1'b0;
    assign _bne = (instr_code[31:26]==BNE_OP) ? 1'b1 : 1'b0;
    assign _slti = (instr_code[31:26]==SLTI_OP) ? 1'b1 : 1'b0;
    assign _sltiu = (instr_code[31:26]==SLTIU_OP) ? 1'b1 : 1'b0;
    assign _lui = (instr_code[31:26]==LUI_OP) ? 1'b1 : 1'b0;
    assign _j = (instr_code[31:26]==J_OP) ? 1'b1 : 1'b0;
    assign _jal = (instr_code[31:26]==JAL_OP) ? 1'b1 : 1'b0;
    assign _bgez = (instr_code[31:26]==BGEZ_OP) ? 1'b1 : 1'b0;
    assign _lb = (instr_code[31:26]==LB_OP) ? 1'b1 : 1'b0;
    assign _lbu = (instr_code[31:26]==LBU_OP) ? 1'b1 : 1'b0;
    assign _lhu = (instr_code[31:26]==LHU_OP) ? 1'b1 : 1'b0;
    assign _sb = (instr_code[31:26]==SB_OP) ? 1'b1 : 1'b0;
    assign _sh = (instr_code[31:26]==SH_OP) ? 1'b1 : 1'b0;
    assign _lh = (instr_code[31:26]==LH_OP) ? 1'b1 : 1'b0;
    /* 特殊 */   
    assign _mfc0 = ((instr_code[31:26]==6'b010000) && (instr_code[25:21]==MFC0_BASE)) ? 1'b1 : 1'b0;
    assign _mtc0 = ((instr_code[31:26]==6'b010000) && (instr_code[25:21]==MTC0_BASE)) ? 1'b1 : 1'b0;
     
    /* 操作数译码 */
    //Rsc = instr_code[25:21], Rtc = instr_code[20:16], Rdc = instr_code[15:11]
    //sa = instr_code[10:6], imm16 = instr_code[15:0], target = instr_code[25:0]
    //对照31条MIPS指令表
    assign Rsc = instr_code[25:21];
    assign Rtc = instr_code[20:16];
    assign Rdc = instr_code[15:11];
    assign sa = instr_code[10:6];
    assign imm16 = instr_code[15:0];
    assign target = instr_code[25:0];
endmodule
