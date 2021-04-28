module div_reg(product_out, final_out, test_out, product_in, quotient, clk, ctrl_DIV);
    input [31:0] product_in, quotient;
    input clk, ctrl_DIV;

    output [31:0] product_out, intermediateA, intermediateQ;
    output [63:0] final_out, test_out;

    wire[63:0] reg_in, reg_out, reg_out_shifted,reg_in_shift;


    assign intermediateA = product_in[31] ? reg_out[63:32]: product_in; 
    assign intermediateQ[0] = product_in[31] ? 1'b0 : 1'b1;
    assign intermediateQ[31:1] = reg_out[31:1];

    assign reg_in[63:32] = ctrl_DIV ? 32'd0 : intermediateA;
    assign reg_in[31:0] = ctrl_DIV ? quotient : intermediateQ;

    assign reg_in_shift = reg_in << 1;

    //assign reg_out_shifted = reg_out << 1;
    //assign intermediateA = product_in[31] ? reg_out_shifted[63:32]: product_in;
    //assign intermediateQ[0] = product_in[31] ? 1'b0 : 1'b1;
    //assign intermediateQ[31:1] = reg_out_shifted[31:1];
    //assign reg_in[63:32] = ctrl_DIV ? 32'd0 : intermediateA;
    //assign reg_in[31:0] = ctrl_DIV ? quotient : intermediateQ;
       
    register_64 reg0(reg_out,reg_in_shift, clk, 1'b1, 1'b1,1'b0);
    
    assign product_out = reg_out[63:32];
    assign test_out = reg_in;
    assign final_out = reg_out;

endmodule