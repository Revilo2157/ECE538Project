module alu(data_operandA, data_operandB, ctrl_ALUopcode, ctrl_shiftamt, data_result, isNotEqual, isLessThan, overflow);
        
    input [31:0] data_operandA, data_operandB;
    input [4:0] ctrl_ALUopcode, ctrl_shiftamt;

    output [31:0] data_result;
    output isNotEqual, isLessThan, overflow;

    wire [31:0] arithmetic, shift_left, shift_right;
    wire [31:0] and_A_B, or_A_B;
    wire [31:0] add_or_sub_B;
    wire carry_out;
    wire [4:0] not_opcode;
    wire [31:0] not_B;
    wire perform_sub;
    wire less_than_0, less_than_1, less_than_2, not_arithmetic_31, not_data_a_31, not_data_b_31, helper, overflow_help_0, overflow_help_1,overflow_help_2;

    small_not small_not_ALUopcode(not_opcode, ctrl_ALUopcode);
    large_not large_not_B(not_B,data_operandB);

    and sub_calc(perform_sub,not_opcode[4],not_opcode[3],not_opcode[2],not_opcode[1],ctrl_ALUopcode[0]);
    mux_2 add_or_sub(add_or_sub_B, perform_sub, data_operandB, not_B);

    large_and and_A_B_gate(and_A_B,data_operandA,add_or_sub_B);
    large_or or_A_B_gate(or_A_B,data_operandA,add_or_sub_B);

    CLA adder(arithmetic, carry_out, data_operandA, add_or_sub_B, and_A_B, or_A_B, perform_sub);

    xnor overflow_calc(overflow_help_0, data_operandA[31], add_or_sub_B[31]);
    xnor overflow_calc_1(overflow_help_1, data_operandA[31], arithmetic[31]);
    not overflow_calc_2(overflow_help_2, overflow_help_1);
    and overflow_calc_3(overflow, overflow_help_0, overflow_help_2);


    or equal_check(isNotEqual, arithmetic[0],arithmetic[1],arithmetic[2],arithmetic[3],arithmetic[4],arithmetic[5],arithmetic[6],arithmetic[7],
    arithmetic[8],arithmetic[9],arithmetic[10],arithmetic[11],arithmetic[12],arithmetic[13],arithmetic[14],arithmetic[15],arithmetic[16],arithmetic[17],arithmetic[18],
    arithmetic[19],arithmetic[20],arithmetic[21],arithmetic[22],arithmetic[23],arithmetic[24],arithmetic[25],arithmetic[26],arithmetic[27],arithmetic[28],arithmetic[29],
    arithmetic[30],arithmetic[31]);


    not arithmetic_not(not_arithmetic_31, arithmetic[31]);
    not A_not(not_data_a_31, data_operandA[31]);
    not B_not(not_data_b_31, data_operandB[31]);

    and less_than_case_0(less_than_0,not_data_a_31,not_data_b_31,arithmetic[31]);
    and less_than_case_1(less_than_1,data_operandA[31], data_operandB[31], arithmetic[31]);
    and less_than_case_2(less_than_2,data_operandA[31], not_data_b_31);

    or less_than_check(helper, less_than_0, less_than_1, less_than_2);
    and helper_gate(isLessThan, helper, isNotEqual);

    shift_left_block left_shifter(shift_left, data_operandA, ctrl_shiftamt);
    shift_right_block right_shifter(shift_right, data_operandA, ctrl_shiftamt);

    mux_6 multiplexer(data_result, ctrl_ALUopcode[2:0], arithmetic, arithmetic, and_A_B, or_A_B, shift_left, shift_right);

endmodule