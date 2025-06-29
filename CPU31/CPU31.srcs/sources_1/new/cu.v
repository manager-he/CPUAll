module CU (
    input [5:0] op, func, alu_z,
    output DM_EN, DM_W, RF_W,
    output [3:0] ALUC,
    output M11, M12, M13, M2, M31, M32, M41, M42, M43, M51, M52
);
    wire add_, addu_, sub_, subu_, and_, or_, xor_, nor_;
    wire slt_, sltu_, sll_, srl_, sra_, sllv_, srlv_, srav_, jr_;
    assign add_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_000);
    assign addu_    = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_001);
    assign sub_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_010);
    assign subu_    = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_011);
    assign and_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_100);
    assign or_      = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_101);
    assign xor_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_110);
    assign nor_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b100_111);
    assign slt_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b101_010);
    assign sltu_    = (op[5:0] == 6'b000_000 && func[5:0] == 6'b101_011);
    assign sll_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b000_000);
    assign srl_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b000_010);
    assign sra_     = (op[5:0] == 6'b000_000 && func[5:0] == 6'b000_011);
    assign sllv_    = (op[5:0] == 6'b000_000 && func[5:0] == 6'b000_100);
    assign srlv_    = (op[5:0] == 6'b000_000 && func[5:0] == 6'b000_110);
    assign srav_    = (op[5:0] == 6'b000_000 && func[5:0] == 6'b000_111);
    assign jr_  = (op[5:0] == 6'b000_000 && func[5:0] == 6'b001_000);
    //instruction 18-29
    wire addi_, addiu_, andi_, ori_, xori_, lw_, sw_, beq_, bne_;
    wire slti_, sltiu_, lui_;
    assign addi_    = (op[5:0] == 6'b001_000);
    assign addiu_   = (op[5:0] == 6'b001_001);
    assign andi_    = (op[5:0] == 6'b001_100);
    assign ori_     = (op[5:0] == 6'b001_101);
    assign xori_    = (op[5:0] == 6'b001_110);
    assign lw_      = (op[5:0] == 6'b100_011);
    assign sw_      = (op[5:0] == 6'b101_011);
    assign beq_     = (op[5:0] == 6'b000_100);
    assign bne_     = (op[5:0] == 6'b000_101);
    assign slti_    = (op[5:0] == 6'b001_010);
    assign sltiu_   = (op[5:0] == 6'b001_011);
    assign lui_     = (op[5:0] == 6'b001_111);
    //instruction 30-31
    wire j_, jal_;
    assign j_       = (op[5:0] == 6'b000_010);
    assign jal_     = (op[5:0] == 6'b000_011);

    // DMEM
    assign DM_EN    = lw_ | sw_;
    assign DM_W     = sw_;
    // RegFiles
    assign RF_W     = ~(jr_ | sw_ | beq_ | bne_ | j_);
    // ALUC0
    assign ALUC[0]  = slt_ | sltu_ | sll_ | srl_ | sra_ | sllv_ | srlv_ |
                      srav_ | slti_ | sltiu_ | lui_;
    assign ALUC[1]  = and_ | or_ | xor_ | nor_ | sra_ | srav_ |
                      andi_ | ori_ | xori_ | lui_;
    assign ALUC[2]  = sub_ | subu_ | xor_ | nor_ | sll_ | srl_ | sllv_ | srlv_ |
                      xori_ | beq_ | bne_;
    assign ALUC[3]  = addu_ | subu_ | or_ | nor_ | sltu_ | srl_ | srlv_ | addiu_ |
                      ori_ | beq_ | bne_ | sltiu_ | lui_ | jal_;
    // M1
    assign M11 = jal_ | j_;
    assign M12 = jr_;
    assign M13 = jr_ | (beq_ & alu_z) | (bne_ & ~alu_z);
    // M2
    assign M2 = lw_;
    // M3
    assign M31 = jal_;
    assign M32 = sll_ | srl_ | sra_;
    // M4
    assign M41 = andi_ | ori_ | xori_;
    assign M42 = jal_;
    assign M43 = addi_ | addiu_ | lw_ | sw_ | slti_ | sltiu_ | lui_ | jal_;
    // M5
    assign M51 = addi_ | addiu_ | andi_ | ori_ | xori_ | lw_ | slti_ | sltiu_ | lui_;
    assign M52 = jal_;

endmodule