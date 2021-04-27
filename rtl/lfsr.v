module lfsr();
    reg[3:0] state = 0;
    reg[6:0] toCompact = 7'b1010111;
    reg clock = 0;

    initial begin
        // #1 $display("%b \t %b \t %b", state2, toCompact2[7], state2[4] ^ state2[3] ^ state2[1] ^ toCompact2[7]);
        #1 
        $display("State \t Input");
        $display("%b \t %b", state, toCompact[6]);

        @(negedge |toCompact);
        @(negedge clock);
        $finish;
    end

    always @(posedge clock) begin
        state[3] <= state[3] ^ state[2];
        state[2] <= state[1];
        state[1] <= state[0];
        state[0] <= state[3] ^ toCompact[6];
        toCompact <= {toCompact[5:0], 1'b0};
        #1 $display("%b \t %b", state, toCompact[6]);
    end


    // x^5 + x^3 + x + 1

    // reg[4:0] state2 = 0;
    // reg[7:0] toCompact2 = 8'b10001010;

    // //internal 
    // always @(posedge clock) begin
    //     state2[4] <= state2[3];
    //     state2[3] <= state2[4] ^ state2[2];
    //     state2[2] <= state2[1];
    //     state2[1] <= state2[4] ^ state2[0];
    //     state2[0] <= state2[4] ^ toCompact2[7];
    //     toCompact2 <= {toCompact2[6:0], 1'b0};
    //     #1 $display("%b \t %b", state2, toCompact2[7]);
    // end

    // external 
    // always @(posedge clock) begin
    //      state2[4:1] <= state2[3:0];
    //     state2[0] <= state2[4] ^ state2[3] ^ state2[1] ^ toCompact2[7];
    //     toCompact2 <= {toCompact2[6:0], 1'b0};
    //      #1 $display("%b \t %b \t %b", state2, toCompact2[7], state2[4] ^ state2[3] ^ state2[1] ^ toCompact2[7]);
    // end


    always 
        #10 clock <= !clock;
endmodule