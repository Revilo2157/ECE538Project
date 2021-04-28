module register (out, in, clk, en, out_en, clr);
   
    input clk, en, clr, out_en;
    input[31:0] in;

    //Output
    output[31:0] out;

    //Internal wire
    wire[31:0] dffe_out;

    dffe_ref d0(dffe_out[0],in[0],clk,en,clr);
    dffe_ref d1(dffe_out[1],in[1],clk,en,clr);
    dffe_ref d2(dffe_out[2],in[2],clk,en,clr);
    dffe_ref d3(dffe_out[3],in[3],clk,en,clr);
    dffe_ref d4(dffe_out[4],in[4],clk,en,clr);
    dffe_ref d5(dffe_out[5],in[5],clk,en,clr);
    dffe_ref d6(dffe_out[6],in[6],clk,en,clr);
    dffe_ref d7(dffe_out[7],in[7],clk,en,clr);
    dffe_ref d8(dffe_out[8],in[8],clk,en,clr);
    dffe_ref d9(dffe_out[9],in[9],clk,en,clr);
    dffe_ref d10(dffe_out[10],in[10],clk,en,clr);
    dffe_ref d11(dffe_out[11],in[11],clk,en,clr);
    dffe_ref d12(dffe_out[12],in[12],clk,en,clr);
    dffe_ref d13(dffe_out[13],in[13],clk,en,clr);
    dffe_ref d14(dffe_out[14],in[14],clk,en,clr);
    dffe_ref d15(dffe_out[15],in[15],clk,en,clr);
    dffe_ref d16(dffe_out[16],in[16],clk,en,clr);
    dffe_ref d17(dffe_out[17],in[17],clk,en,clr);
    dffe_ref d18(dffe_out[18],in[18],clk,en,clr);
    dffe_ref d19(dffe_out[19],in[19],clk,en,clr);
    dffe_ref d20(dffe_out[20],in[20],clk,en,clr);
    dffe_ref d21(dffe_out[21],in[21],clk,en,clr);
    dffe_ref d22(dffe_out[22],in[22],clk,en,clr);
    dffe_ref d23(dffe_out[23],in[23],clk,en,clr);
    dffe_ref d24(dffe_out[24],in[24],clk,en,clr);
    dffe_ref d25(dffe_out[25],in[25],clk,en,clr);
    dffe_ref d26(dffe_out[26],in[26],clk,en,clr);
    dffe_ref d27(dffe_out[27],in[27],clk,en,clr);
    dffe_ref d28(dffe_out[28],in[28],clk,en,clr);
    dffe_ref d29(dffe_out[29],in[29],clk,en,clr);
    dffe_ref d30(dffe_out[30],in[30],clk,en,clr);
    dffe_ref d31(dffe_out[31],in[31],clk,en,clr);

    tri_state_buff t0(out[0],dffe_out[0],out_en);
    tri_state_buff t1(out[1],dffe_out[1],out_en);
    tri_state_buff t2(out[2],dffe_out[2],out_en);
    tri_state_buff t3(out[3],dffe_out[3],out_en);
    tri_state_buff t4(out[4],dffe_out[4],out_en);
    tri_state_buff t5(out[5],dffe_out[5],out_en);
    tri_state_buff t6(out[6],dffe_out[6],out_en);
    tri_state_buff t7(out[7],dffe_out[7],out_en);
    tri_state_buff t8(out[8],dffe_out[8],out_en);
    tri_state_buff t9(out[9],dffe_out[9],out_en);
    tri_state_buff t10(out[10],dffe_out[10],out_en);
    tri_state_buff t11(out[11],dffe_out[11],out_en);
    tri_state_buff t12(out[12],dffe_out[12],out_en);
    tri_state_buff t13(out[13],dffe_out[13],out_en);
    tri_state_buff t14(out[14],dffe_out[14],out_en);
    tri_state_buff t15(out[15],dffe_out[15],out_en);
    tri_state_buff t16(out[16],dffe_out[16],out_en);
    tri_state_buff t17(out[17],dffe_out[17],out_en);
    tri_state_buff t18(out[18],dffe_out[18],out_en);
    tri_state_buff t19(out[19],dffe_out[19],out_en);
    tri_state_buff t20(out[20],dffe_out[20],out_en);
    tri_state_buff t21(out[21],dffe_out[21],out_en);
    tri_state_buff t22(out[22],dffe_out[22],out_en);
    tri_state_buff t23(out[23],dffe_out[23],out_en);
    tri_state_buff t24(out[24],dffe_out[24],out_en);
    tri_state_buff t25(out[25],dffe_out[25],out_en);
    tri_state_buff t26(out[26],dffe_out[26],out_en);
    tri_state_buff t27(out[27],dffe_out[27],out_en);
    tri_state_buff t28(out[28],dffe_out[28],out_en);
    tri_state_buff t29(out[29],dffe_out[29],out_en);
    tri_state_buff t30(out[30],dffe_out[30],out_en);
    tri_state_buff t31(out[31],dffe_out[31],out_en);

endmodule