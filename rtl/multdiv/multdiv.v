module multdiv (
	data_operandA, data_operandB, 
	ctrl_MULT, ctrl_DIV, 
	clock, 
	data_result, data_exception, data_resultRDY);

    input [31:0] data_operandA, data_operandB;
    input ctrl_MULT, ctrl_DIV, clock;

    output [31:0] data_result;
    output data_exception, data_resultRDY;

wire [63:0] mult_final_out, div_final_out,test_div_out;
wire [31:0] multiplicand,divisor, mult_adder_result,mult_out,exception_check,div_out,div_adder_result,positive_data_A, positive_data_B, not_data_A, not_data_B, not_div_out, final_div, div_or_0, temp_div;
wire [1:0] instruction_bits;
wire skip, operation, carry_out,exception, first, second, third, fourth, fifth, sixth, seventh, temp,data_resultRDY_mult, data_resultRDY_div, mult_or_div, mult_on_last, div_on_last, div_exception, mult_exception, divide_by_zero, divide_on_zero, temp1, temp2, temp3;


//////////////////////////////////// Last Operation Register ///////////////////////////////////


dffe_ref div_or_mult_reg(mult_or_div,ctrl_MULT,clock,(ctrl_DIV | ctrl_MULT), 1'b0);

//////////////////////////////////// Multiplication Cycle Checker ///////////////////////////////////
wire [31:0] mult_increment, mult_counter_reg_in, mult__counter_reg_out;
wire mult_overflow;

adder mult_ready_counter(mult_increment, mult_overflow, mult__counter_reg_out, 32'd1, 1'd0, 1'd0);
assign mult_counter_reg_in = ctrl_MULT ? 32'd0 : mult_increment;
register mult_ready_reg(mult__counter_reg_out, mult_counter_reg_in, clock, clock, 1'd1, 1'd0);
assign data_resultRDY_mult = (mult__counter_reg_out[5] & ~mult__counter_reg_out[4] & ~mult__counter_reg_out[3] & ~mult__counter_reg_out[2] & ~mult__counter_reg_out[1] & ~mult__counter_reg_out[0]);

//////////////////////////////////// Division Cycle Checker ///////////////////////////////////


wire [31:0] div_increment, div_counter_reg_in, div__counter_reg_out;
wire div_overflow;

adder div_ready_counter(div_increment, div_overflow, div__counter_reg_out, 32'd1, 1'd0, 1'd0);
assign div_counter_reg_in = ctrl_DIV ? 32'd0 : div_increment;
register div_ready_reg(div__counter_reg_out, div_counter_reg_in, clock, clock, 1'd1, 1'd0);
assign data_resultRDY_div = (~div__counter_reg_out[5] & div__counter_reg_out[4] & div__counter_reg_out[3] & div__counter_reg_out[2] & div__counter_reg_out[1] & div__counter_reg_out[0]);

//////////////////////////////////// Multiplication Hardware ///////////////////////////////////
mult_control mult_controller(operation,skip, instruction_bits,ctrl_MULT, clock);

register reg_multiplicand(multiplicand, data_operandA, clock, ctrl_MULT , 1'b1, 1'b0);
adder mult_adder(mult_adder_result,carry_out,mult_out,multiplicand,operation,skip);
product_reg mult_product(mult_out,mult_final_out,instruction_bits,mult_adder_result,data_operandB,clock,ctrl_MULT);

//////////////////////////////////// Division Hardware ///////////////////////////////////


adder sign_flip0(not_data_A,overflow,32'b0,data_operandA,1'b1,1'b0);
adder sign_flip1(not_data_B,overflow,32'b0,data_operandB,1'b1,1'b0);

assign positive_data_A = data_operandA[31] ? not_data_A: data_operandA;
assign positive_data_B = data_operandB[31] ? not_data_B: data_operandB;


register reg_divisor(divisor, positive_data_B, clock, ctrl_DIV , 1'b1, 1'b0);

div_reg div_register(div_out,div_final_out,test_div_out,div_adder_result,positive_data_A,clock,ctrl_DIV);
adder div_adder(div_adder_result,carry_out, div_out, divisor, 1'b1,1'b0);

//////////////////////////////////// Division Sign Checking ///////////////////////////////////

adder sign_flip(not_div_out,overflow,32'b0,test_div_out[31:0],1'b1,1'b0);

assign temp1 = (data_operandA[31] & data_operandB[31]);
assign temp2 = (~data_operandA[31] & ~data_operandB[31]);
assign temp3 = (temp1 | temp2);
assign final_div = temp3 ? test_div_out[31:0] : not_div_out;  


//////////////////////////////////// Answer Assignment ///////////////////////////////////


assign div_or_0 = divide_by_zero ? 32'b0 : final_div;

assign data_resultRDY = (data_resultRDY_div & ~mult_or_div) | (data_resultRDY_mult & mult_or_div);
assign data_result = mult_or_div ? mult_final_out[31:0]: div_or_0;

//////////////////////////////////// Multiplication Exceptions ///////////////////////////////////
assign exception_check = mult_final_out[63:32];
assign first = (exception_check[0]& exception_check[1]&exception_check[2]& exception_check[3]& exception_check[4]& exception_check[5]& exception_check[6]& exception_check[7]&
                 exception_check[8]& exception_check[9]& exception_check[10]& exception_check[11]& exception_check[12]& exception_check[13]& exception_check[14]& exception_check[15]&
                 exception_check[16]& exception_check[17]& exception_check[18]& exception_check[19]& exception_check[20]& exception_check[21]& exception_check[22]& exception_check[23]&
                 exception_check[24]& exception_check[25]& exception_check[26]& exception_check[27]& exception_check[28]& exception_check[29]& exception_check[30]& exception_check[31]);
assign second = (  ~exception_check[0]&  ~exception_check[1]&  ~exception_check[2]&  ~exception_check[3]&  ~exception_check[4]&  ~exception_check[5]&  ~exception_check[6]&  ~exception_check[7]&
                  ~exception_check[8]&  ~exception_check[9]&  ~exception_check[10]&  ~exception_check[11]&  ~exception_check[12]&  ~exception_check[13]&  ~exception_check[14]&  ~exception_check[15]&
                  ~exception_check[16]&  ~exception_check[17]&  ~exception_check[18]&  ~exception_check[19]&  ~exception_check[20]&  ~exception_check[21]&  ~exception_check[22]&  ~exception_check[23]&
                  ~exception_check[24]&  ~exception_check[25]&  ~exception_check[26]&  ~exception_check[27]&  ~exception_check[28]&  ~exception_check[29]&  ~exception_check[30]&  ~exception_check[31]);
or test(exception, first, second);

assign third = (~data_operandA[31] & ~data_operandB[31] & data_result[31]);
assign fourth = (~data_operandA[31] & data_operandB[31] & ~data_result[31]& ~divide_on_zero & ~divide_by_zero);
assign fifth = (data_operandA[31] & ~data_operandB[31] & ~data_result[31] & ~divide_on_zero & ~divide_by_zero);
assign sixth = (data_operandA[31] & data_operandB[31] & data_result[31]);
assign mult_exception = (~exception | third | fourth | fifth | sixth);

//////////////////////////////////// Division Exceptions ///////////////////////////////////

assign divide_on_zero = (  ~data_operandA[0]&  ~data_operandA[1]&  ~data_operandA[2]&  ~data_operandA[3]&  ~data_operandA[4]&  ~data_operandA[5]&  ~data_operandA[6]&  ~data_operandA[7]&
                  ~data_operandA[8]&  ~data_operandA[9]&  ~data_operandA[10]&  ~data_operandA[11]&  ~data_operandA[12]&  ~data_operandA[13]&  ~data_operandA[14]&  ~data_operandA[15]&
                  ~data_operandA[16]&  ~data_operandA[17]&  ~data_operandA[18]&  ~data_operandA[19]&  ~data_operandA[20]&  ~data_operandA[21]&  ~data_operandA[22]&  ~data_operandA[23]&
                  ~data_operandA[24]&  ~data_operandA[25]&  ~data_operandA[26]&  ~data_operandA[27]&  ~data_operandA[28]&  ~data_operandA[29]&  ~data_operandA[30]&  ~data_operandA[31]);

assign divide_by_zero = (  ~data_operandB[0]&  ~data_operandB[1]&  ~data_operandB[2]&  ~data_operandB[3]&  ~data_operandB[4]&  ~data_operandB[5]&  ~data_operandB[6]&  ~data_operandB[7]&
                  ~data_operandB[8]&  ~data_operandB[9]&  ~data_operandB[10]&  ~data_operandB[11]&  ~data_operandB[12]&  ~data_operandB[13]&  ~data_operandB[14]&  ~data_operandB[15]&
                  ~data_operandB[16]&  ~data_operandB[17]&  ~data_operandB[18]&  ~data_operandB[19]&  ~data_operandB[20]&  ~data_operandB[21]&  ~data_operandB[22]&  ~data_operandB[23]&
                  ~data_operandB[24]&  ~data_operandB[25]&  ~data_operandB[26]&  ~data_operandB[27]&  ~data_operandB[28]&  ~data_operandB[29]&  ~data_operandB[30]&  ~data_operandB[31]);

/////////////////////////////////// Overall Exception ///////////////////////////////////////////

assign data_exception = mult_or_div ? mult_exception : divide_by_zero;


endmodule