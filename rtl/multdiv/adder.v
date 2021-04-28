module adder(data_result, overflow, data_operandA, data_operandB, addOrSub, skip);
    input [31:0] data_operandA, data_operandB;
    input addOrSub, skip;
    
    output [31:0] data_result;
    output overflow;

    wire [31:0] and_A_B, or_A_B, add_or_sub, skip_or_B, add_or_sub_B;



    assign add_or_sub_B = addOrSub ? ~data_operandB : data_operandB;
    assign skip_or_B = skip ? 32'd0 : add_or_sub_B;
    assign and_A_B = data_operandA & skip_or_B;
    assign or_A_B = data_operandA | skip_or_B;


    CLA adder(data_result, carry_out, data_operandA, skip_or_B, and_A_B, or_A_B, addOrSub);

endmodule