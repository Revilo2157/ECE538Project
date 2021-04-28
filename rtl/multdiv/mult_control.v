module mult_control (operation, skip, instruction_bits, ctrl_MULT, clk);
    input [1:0] instruction_bits;
    input ctrl_MULT, clk;

    output operation,skip;
    wire add, sub;

    /////////////////////////// Determine Operation from Last 2 Bits ///////////////////////////

    assign skip = (~instruction_bits[1] & ~instruction_bits[0]) | (instruction_bits[1] & instruction_bits[0]);
    assign add = (~instruction_bits[1] & instruction_bits[0]);
    assign operation = (instruction_bits[1] & ~instruction_bits[0]);


endmodule