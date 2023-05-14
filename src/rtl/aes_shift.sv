module aes_shift (
    input  [ 7:0] state [15:0],
    output [ 7:0] val   [15:0]
);

// assign val[ 0] = state[ 0];
// assign val[ 4] = state[ 4];
// assign val[ 8] = state[ 8];
// assign val[12] = state[12];
// assign val[ 1] = state[ 5];
// assign val[ 5] = state[ 9];
// assign val[ 9] = state[13];
// assign val[13] = state[ 1];
// assign val[ 2] = state[10];
// assign val[ 6] = state[14];
// assign val[10] = state[ 2];
// assign val[14] = state[ 6];
// assign val[ 3] = state[15];
// assign val[ 7] = state[ 3];
// assign val[11] = state[ 7];
// assign val[15] = state[11];

assign val[15] = state[15];
assign val[14] = state[10];
assign val[13] = state[ 5];
assign val[12] = state[ 0];
assign val[11] = state[11];
assign val[10] = state[ 6];
assign val[ 9] = state[ 1];
assign val[ 8] = state[12];
assign val[ 7] = state[ 7];
assign val[ 6] = state[ 2];
assign val[ 5] = state[13];
assign val[ 4] = state[ 8];
assign val[ 3] = state[ 3];
assign val[ 2] = state[14];
assign val[ 1] = state[ 9];
assign val[ 0] = state[ 4];

endmodule