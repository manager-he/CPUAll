`timescale 1ns / 1ps

module controller(
    input clk,rst,
    input _add,
    input _addu,
    input _sub,
    input _subu,
    input _and,
    input _or,
    input _xor,
    input _nor,
    input _slt,
    input _sltu,
    input _sll,
    input _srl,
    input _sra,
    input _sllv,
    input _srlv,
    input _srav,
    input _jr,
    input _addi,
    input _addiu,
    input _andi,
    input _ori,
    input _xori,
    input _lw,
    input _sw,
    input _beq,
    input _bne,
    input _slti,
    input _sltiu,
    input _lui,
    input _j,
    input _jal,
    input _div,
    input _divu,
    input _mult,
    input _multu,
    input _bgez,
    input _jalr,
    input _lbu,
    input _lhu,
    input _lb,
    input _lh,
    input _sb,
    input _sh,
    input _break,
    input _syscall,
    input _eret,
    input _mfhi,
    input _mflo,
    input _mthi,
    input _mtlo,
    input _mfc0,
    input _mtc0,
    input _clz,
    input _teq,
    input ZF,SF,DIV_BUSY,
    output PCin,IRin,RF_W,Zin,Z64in,MULT_EN,MULT_S,DIV_EN,DIV_S,HIin,LOin,
    output DM_EN,DM_W,DM_DB,DM_DH,DM_DW,DM_DS,
    output MFC0,MTC0,Exception,ERET,
    output [4:0] cause,
    output [1:0] M1,
    output [2:0] M2,
    output [1:0] M3,
    output [1:0] M4,
    output [2:0] M5,
    output M6,M7,M8,
    output [3:0] ALUC,
    output PC_print
    );
    /* 状态机 */
    reg [2:0] curState;
    reg [2:0] nextState;
    parameter STATE_INIT = 0;
    parameter STATE_T1 = 1;
    parameter STATE_T2 = 2;
    parameter STATE_T3 = 3;
    parameter STATE_T4 = 4;
    parameter STATE_T5 = 5;
    
    //确定现态
    always @ (posedge clk or posedge rst) begin
        if(rst) begin
            curState <= STATE_INIT;
//            PC_print_t <= 0;
        end
        else begin
            curState <= nextState;
        end
    end
    
    //确定次态
    always @ (*) begin
        case(curState)
            STATE_INIT: begin
                nextState <= STATE_T1;
            end
            STATE_T1: begin
//                PC_print_t <= 1;
                nextState <= STATE_T2;
            end
            STATE_T2: begin
//                PC_print_t <= 0;
                nextState <= STATE_T3;
            end
            STATE_T3: begin
                if(_j || _jr || _mfhi || _mthi || _mflo || _mtlo || _mfc0 || _mtc0 ||
                   (_beq && !ZF) || (_bne && ZF) || (_bgez && SF && !ZF) || (_teq && !ZF))begin
                    nextState <= STATE_T1;
                end
                else begin
                    nextState <= STATE_T4;
                end
            end
            STATE_T4: begin
                if(_beq || _bne || _bgez || _teq)begin
                    nextState <= STATE_T5;
                end
                else if((_div || _divu) && DIV_BUSY) begin
                    nextState <= STATE_T4;
                end
                else begin
                    nextState <= STATE_T1;
                end
            end
            STATE_T5: begin
                nextState <= STATE_T1;
            end
            default: begin
                nextState <= STATE_T1;
            end
        endcase
    end
    
    //确定控制信号
    wire T1,T2,T3,T4,T5;
//    reg PC_print_t;
//    assign PC_print = PC_print_t;
    assign T1 = curState==STATE_T1;
    assign T2 = curState==STATE_T2;
    assign T3 = curState==STATE_T3;
    assign T4 = curState==STATE_T4;
    assign T5 = curState==STATE_T5;
    assign PC_print = curState==STATE_T1 || curState==STATE_INIT;
    
    ////////////////////////////////////////////////////////////////
    assign PCin = T2 || (_j || _jr)&&T3 || (_jal || _jalr)&&T4 || (_break || _syscall || _eret)&&T4 || _teq&T5 || (_beq || _bne || _bgez)&&T5;
//    assign PCin = T2 || (_j || _jr)&&T3 || (_jal || _jalr || _break || _syscall)&&T4 || (_beq || _bne || _bgez || _teq)&&T5;
//    assign PCin = T1;
//    assign NPCin = T2 || (_j || _jr)&&T3 || (_jal || _jalr || _break || _syscall)&&T4 || (_beq || _bne || _bgez || _teq)&&T5;
    ////////////////////////////////////////////////////////////////////
    assign IRin = T1;
    assign M1[0] = _j&&T3 || _jal&&T4 || (_break || _syscall || _eret)&&T4 || _teq&&T5;
    assign M1[1] = _jr&&T3 || _jalr&&T4 || (_break || _syscall || _eret)&&T4 || _teq&&T5;
    assign RF_W = (_add || _addu || _addi || _addiu || _sub || _subu || _sll || _sllv ||
                   _sra || _srav || _srl || _srlv ||  _clz || _andi || _and || _ori ||
                   _or || _xori || _xor || _nor || _slt || _sltu || _slti || _sltiu || _lui)&&T4 ||
                   (_jal || _jalr)&&T3 || (_lbu || _lhu || _lb || _lh || _lw)&&T4 || (_mfhi || _mflo || _mfc0)&&T3;
    assign M2[0] = (_lbu || _lhu || _lb || _lh || _lw)&&T4 || (_mfhi || _mfc0)&&T3;
    assign M2[1] = (_jal || _jalr || _mfhi)&&T3;
    assign M2[2] = (_mflo || _mfc0)&&T3;
    assign M3[0] = (_addi || _addiu || _andi || _ori || _xori || _slti || _sltiu || _lui)&&T4 || 
                   (_lbu || _lhu || _lb || _lh || _lw)&&T4 || _mfc0&&T3;
    assign M3[1] = (_jal || _jalr)&&T3;
    assign ALUC[0] = (_sub || _subu || _or || _nor || _slt || _srl || _srlv || _ori || _beq || _bne || _bgez || _slti || _clz || _teq)&&T3;
    assign ALUC[1] = (_add || _sub || _xor || _nor || _slt || _sltu || _sll || _sllv || _addi || _xori || _slti || _sltiu || _clz)&&T3;
    assign ALUC[2] = (_and || _or || _xor || _nor || _sll || _srl || _sra || _sllv || _srlv || _srav || _andi || _ori || _xori || _clz)&&T3;
    assign ALUC[3] = (_slt || _sltu || _sll || _srl || _sra || _sllv || _srlv || _srav || _slti || _sltiu || _lui || _clz)&&T3;
    assign M4[0] = T1 || (_beq || _bne || _bgez)&&T4;
    assign M4[1] = (_sll || _srl || _sra)&&T3;
    assign M5[0] = (_ori || _xori || _andi)&&T3 || T1 || _bgez&&T3;
    assign M5[1] = (_addi || _addiu || _slti || _sltiu || _lui)&&T3 || (_lbu || _lhu || _lb || _lh || _lw || _sb || _sh || _sw)&&T3 || T1;
    assign M5[2] = (_beq || _bne || _bgez)&&T4 || _bgez&&T3;
    assign Zin = T1 || (_add || _addu || _addi || _addiu || _sub || _subu || _sll || _sllv ||
                 _sra || _srav || _srl || _srlv ||  _clz || _andi || _and || _ori ||
                 _or || _xori || _xor || _nor || _slt || _sltu || _slti || _sltiu || _lui)&&T3 || 
                 (_lbu || _lhu || _lb || _lh || _lw || _sb || _sh || _sw)&&T3 || (_beq || _bne || _bgez)&&T4 || 
                 (_beq || _bne || _bgez || _teq)&&T3;
    assign DM_EN = (_lbu || _lhu || _lb || _lh || _lw || _sb || _sh || _sw)&&T4;
    assign DM_W = (_sb || _sh || _sw)&&T4;
    assign DM_DB = (_lbu || _lb || _sb)&&T4;
    assign DM_DH = (_lhu || _lh || _sh)&&T4;
    assign DM_DW = (_lw || _sw)&&T4;
    assign DM_DS = (_lb || _lh || _lw)&&T4;
    assign MULT_EN = (_mult || _multu)&&T3;
    assign MULT_S = _mult&&T3;
    assign DIV_EN = (_div || _divu)&&T3;
    assign DIV_S = _div&&T3;
    assign Z64in = (_mult || _multu || _div || _divu)&&T3;
    assign M6 = (_div || _divu)&&T3;
    assign HIin = (_mult || _multu || _div || _divu)&&T4 || _mthi&&T3;
    assign LOin = (_mult || _multu || _div || _divu)&&T4 || _mtlo&&T3;
    assign M7 = (_mult || _multu || _div || _divu)&&T4;
    assign M8 = (_mult || _multu || _div || _divu)&&T4;
    assign MFC0 = _mfc0&&T3;
    assign MTC0 = _mtc0&&T3;
    assign ERET = _eret&&T3;
    assign Exception = (_break || _syscall)&&T3 || _teq&&T4;
    assign cause = _syscall&&T3 ? 5'b01000 : _break&&T3 ? 5'b01001 : _teq&&T4 ? 5'b01101 : 5'b00000;
endmodule
