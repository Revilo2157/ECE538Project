module CLA(sum, carry_out, A, B, g, p, c0);
        
    input [31:0] A, B, g, p;
    input c0;

    output [31:0] sum;
    output carry_out;
    
    wire G0, G1, G2, G3;
    wire P0, P1, P2, P3;

    wire c8, c16, c24;
    wire c8_0, c16_0, c16_1, c24_0, c24_1, c24_2, c32_0, c32_1, c32_2, c32_3;

    
    CLA_Block block_0(sum[7:0], G0, P0, A[7:0], B[7:0], g[7:0], p[7:0], c0);

    and c8_help_and(c8_0, P0, c0);
    or c8_help_or(c8,c8_0,G0);

    CLA_Block block_1(sum[15:8], G1, P1, A[15:8], B[15:8], g[15:8], p[15:8], c8);

    and c16_help_and_0(c16_0, P1, G0);
    and c16_help_and_1(c16_1, P1, P0, c0);
    or c16_help_or(c16,c16_0,c16_1,G1);


    CLA_Block block_2(sum[23:16], G2, P2, A[23:16], B[23:16], g[23:16], p[23:16], c16);

    and c24_help_and_0(c24_0, P2, G1);
    and c24_help_and_1(c24_1, P2, P1, G0);
    and c24_help_and_2(c24_2, P2, P1, P0,c0);
    or c24_help_or(c24,c24_0,c24_1,c24_2,G2);


    CLA_Block block_3(sum[31:24], G3, P3, A[31:24], B[31:24], g[31:24], p[31:24], c24);
    
    and c32_help_and_0(c32_0, P3, G2);
    and c32_help_and_1(c32_1, P3, P2, G1);
    and c32_help_and_2(c32_2, P3, P2, P1, G0);
    and c32_help_and_3(c32_3, P3, P2, P1, P0, c0);
    or c32_help_or(carry_out,c32_0,c32_1,c32_2,c32_3,G3);


endmodule