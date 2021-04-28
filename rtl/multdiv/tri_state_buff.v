module tri_state_buff (out, in, oe);
    input in, oe;
    output out;

    assign out = oe ? in : 1'bz;

endmodule