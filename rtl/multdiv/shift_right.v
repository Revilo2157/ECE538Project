module shift_right(out, in);
    input [64:0] in;
    output [64:0] out;

    assign out[64] = in[64];
    assign out[63:0] = in[64:1];

endmodule

