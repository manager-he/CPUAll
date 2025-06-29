`timescale 1ns / 1ps
module cpu_tb;
    reg clk, rst;
    wire [31:0] inst, pc;

    //integer file_open;

    integer file_output;
    initial begin
    file_output = $fopen("E:/DigitCircuit/computer_componont/CPU/Data/result.txt");
        clk = 0;
        rst = 1;
        #50 rst = 0;
    end

    // CLK
    parameter clk_period = 100;
    always begin
        #(clk_period/2) clk = ~clk;
    end
    
    sccomp_dataflow uut(
        .clk_in(clk),
        .reset(rst),
        .inst(inst),
        .pc(pc)
    );
    
    // DISPLAY
        always @(posedge clk) begin
            if(cpu_tb.uut.sccpu.inst === 32'hxxxxxxxx) begin
                $fclose(file_output);
            end
            else begin
                $fdisplay(file_output, "pc: %h", cpu_tb.uut.sccpu.pc_out);
                $fdisplay(file_output, "instr: %h", cpu_tb.uut.sccpu.inst);         
                $fdisplay(file_output, "regfile0: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[0]);
                $fdisplay(file_output, "regfile1: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[1]);
                $fdisplay(file_output, "regfile2: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[2]);
                $fdisplay(file_output, "regfile3: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[3]);
                $fdisplay(file_output, "regfile4: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[4]);
                $fdisplay(file_output, "regfile5: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[5]);
                $fdisplay(file_output, "regfile6: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[6]);
                $fdisplay(file_output, "regfile7: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[7]);
                $fdisplay(file_output, "regfile8: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[8]);
                $fdisplay(file_output, "regfile9: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[9]);
                $fdisplay(file_output, "regfile10: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[10]);
                $fdisplay(file_output, "regfile11: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[11]);
                $fdisplay(file_output, "regfile12: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[12]);
                $fdisplay(file_output, "regfile13: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[13]);
                $fdisplay(file_output, "regfile14: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[14]);
                $fdisplay(file_output, "regfile15: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[15]);
                $fdisplay(file_output, "regfile16: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[16]);
                $fdisplay(file_output, "regfile17: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[17]);
                $fdisplay(file_output, "regfile18: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[18]);
                $fdisplay(file_output, "regfile19: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[19]);
                $fdisplay(file_output, "regfile20: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[20]);
                $fdisplay(file_output, "regfile21: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[21]);
                $fdisplay(file_output, "regfile22: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[22]);
                $fdisplay(file_output, "regfile23: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[23]);
                $fdisplay(file_output, "regfile24: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[24]);
                $fdisplay(file_output, "regfile25: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[25]);
                $fdisplay(file_output, "regfile26: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[26]);
                $fdisplay(file_output, "regfile27: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[27]);
                $fdisplay(file_output, "regfile28: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[28]);
                $fdisplay(file_output, "regfile29: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[29]);
                $fdisplay(file_output, "regfile30: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[30]);
                $fdisplay(file_output, "regfile31: %h", cpu_tb.uut.sccpu.cpu_ref.array_reg[31]);   
                // $fdisplay(file_output, "ALUC_A: %h", cpu_tb.uut.sccpu.alu_a);
                // $fdisplay(file_output, "ALUC_B: %h", cpu_tb.uut.sccpu.alu_b);
                // $fdisplay(file_output, "ALUC_F: %h", cpu_tb.uut.sccpu.alu_f);
            end
        end



endmodule