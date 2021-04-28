module product_reg(product_out, final_out, last_2_bits, product_in, multiplier, clk, ctrl_MULT);
    input [31:0] product_in, multiplier;
    input clk, ctrl_MULT;

    output [31:0] product_out;
    output [63:0] final_out;
    output [1:0] last_2_bits;

    wire[64:0] reg_in, reg_in_0, reg_out, shifted;

    assign reg_in[64:33] = ctrl_MULT ? 32'd0 : product_in;
    assign reg_in[32:1] = ctrl_MULT ? multiplier : reg_out[32:1];
    assign reg_in[0] = ctrl_MULT ? 1'd0 : reg_out[0];

    shift_right shifter(shifted, reg_in);
    assign reg_in_0 = ~ctrl_MULT ? shifted : reg_in;
    
    register_65 reg0(reg_out,reg_in_0, clk, 1'b1, 1'b1,1'b0);
    assign product_out = reg_out[64:33];

    assign last_2_bits[0] = reg_out[0];
    assign last_2_bits[1] = reg_out[1];
    assign final_out = reg_out[64:1];

endmodule