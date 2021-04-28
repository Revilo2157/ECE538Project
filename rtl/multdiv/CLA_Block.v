module CLA_Block(sum, big_g, big_p, A, B, g, p, c0);
        
    input [7:0] A, B, g, p;
    input c0;

    output [7:0] sum;
    output big_p, big_g;

    wire c1,c2,c3,c4,c5,c6,c7;
    wire h6,h5,h4,h3,h2,h1,h0;
    
    wire c1_0;
    wire c2_0,c2_1;
    wire c3_0,c3_1,c3_2;
    wire c4_0,c4_1,c4_2,c4_3;
    wire c5_0,c5_1,c5_2,c5_3,c5_4;
    wire c6_0,c6_1,c6_2,c6_3,c6_4,c6_5;
    wire c7_0,c7_1,c7_2,c7_3,c7_4,c7_5,c7_6;
    
    and and_h0(h0,p[7],p[6],p[5],p[4],p[3],p[2],p[1],g[0]);
    and and_h1(h1,p[7],p[6],p[5],p[4],p[3],p[2],g[1]);
    and and_h2(h2,p[7],p[6],p[5],p[4],p[3],g[2]);
    and and_h3(h3,p[7],p[6],p[5],p[4],g[3]);
    and and_h4(h4,p[7],p[6],p[5],g[4]);
    and and_h5(h5,p[7],p[6],g[5]);
    and and_h6(h6,p[7],g[6]);

    or big_g_or(big_g,g[7],h6,h5,h4,h3,h2,h1,h0);
    and big_p_and(big_p,p[7],p[6],p[5],p[4],p[3],p[2],p[1],p[0]);

    and c1_help_and(c1_0,c0,p[0]);
    or c1_help_or(c1,c1_0,g[0]);

    and c2_help_and_0(c2_0,p[1],g[0]);
    and c2_help_and_1(c2_1,p[1],p[0],c0);
    or c2_help_or(c2,c2_0,c2_1,g[1]);

    and c3_help_and_0(c3_0,p[2],g[1]);
    and c3_help_and_1(c3_1,p[2],p[1],g[0]);
    and c3_help_and_2(c3_2,p[2],p[1],p[0],c0);
    or c3_help_or(c3,c3_0,c3_1,c3_2,g[2]);
    
    and c4_help_and_0(c4_0,p[3],g[2]);
    and c4_help_and_1(c4_1,p[3],p[2],g[1]);
    and c4_help_and_2(c4_2,p[3],p[2],p[1],g[0]);
    and c4_help_and_3(c4_3,p[3],p[2],p[1],p[0],c0);
    or c4_help_or(c4,c4_0,c4_1,c4_2,c4_3,g[3]);

    and c5_help_and_0(c5_0,p[4],g[3]);
    and c5_help_and_1(c5_1,p[4],p[3],g[2]);
    and c5_help_and_2(c5_2,p[4],p[3],p[2],g[1]);
    and c5_help_and_3(c5_3,p[4],p[3],p[2],p[1],g[0]);
    and c5_help_and_4(c5_4,p[4],p[3],p[2],p[1],p[0],c0);
    or c5_help_or(c5,c5_0,c5_1,c5_2,c5_3,c5_4,g[4]);

    and c6_help_and_0(c6_0,p[5],g[4]);
    and c6_help_and_1(c6_1,p[5],p[4],g[3]);
    and c6_help_and_2(c6_2,p[5],p[4],p[3],g[2]);
    and c6_help_and_3(c6_3,p[5],p[4],p[3],p[2],g[1]);
    and c6_help_and_4(c6_4,p[5],p[4],p[3],p[2],p[1],g[0]);
    and c6_help_and_5(c6_5,p[5],p[4],p[3],p[2],p[1],p[0],c0);
    or c6_help_or(c6,c6_0,c6_1,c6_2,c6_3,c6_4,c6_5,g[5]);

    and c7_help_and_0(c7_0,p[6],g[5]);
    and c7_help_and_1(c7_1,p[6],p[5],g[4]);
    and c7_help_and_2(c7_2,p[6],p[5],p[4],g[3]);
    and c7_help_and_3(c7_3,p[6],p[5],p[4],p[3],g[2]);
    and c7_help_and_4(c7_4,p[6],p[5],p[4],p[3],p[2],g[1]);
    and c7_help_and_5(c7_5,p[6],p[5],p[4],p[3],p[2],p[1],g[0]);
    and c7_help_and_6(c7_6,p[6],p[5],p[4],p[3],p[2],p[1],p[0],c0);
    or c7_help_or(c7,c7_0,c7_1,c7_2,c7_3,c7_4,c7_5,c7_6,g[6]);

    xor s0(sum[0],A[0],B[0],c0);
    xor s1(sum[1],A[1],B[1],c1);
    xor s2(sum[2],A[2],B[2],c2);
    xor s3(sum[3],A[3],B[3],c3);
    xor s4(sum[4],A[4],B[4],c4);
    xor s5(sum[5],A[5],B[5],c5);
    xor s6(sum[6],A[6],B[6],c6);
    xor s7(sum[7],A[7],B[7],c7);


endmodule