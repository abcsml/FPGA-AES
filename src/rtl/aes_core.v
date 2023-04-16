module aes_core (
    input   [ 7:0] state [15:0],
    input   [ 7:0] key   [15:0],
    output  [ 7:0] val   [15:0]
);

function [15:0] [ 7:0] round_add;
    input   [ 7:0] state [15:0];
    input   [ 7:0] key   [15:0];
    begin
        for (int i = 0; i < 16; i++) begin
            round_add[i] = state[i] ^ key[i];
        end
    end
endfunction

function [15:0] [ 7:0] shift_rows;
    input   [ 7:0] state [15:0];
    begin
        shift_rows[ 0] = state[ 0];
        shift_rows[ 4] = state[ 4];
        shift_rows[ 8] = state[ 8];
        shift_rows[12] = state[12];
        shift_rows[ 1] = state[ 5];
        shift_rows[ 5] = state[ 9];
        shift_rows[ 9] = state[13];
        shift_rows[13] = state[ 1];
        shift_rows[ 2] = state[10];
        shift_rows[ 6] = state[14];
        shift_rows[10] = state[ 2];
        shift_rows[14] = state[ 6];
        shift_rows[ 3] = state[15];
        shift_rows[ 7] = state[ 3];
        shift_rows[11] = state[ 7];
        shift_rows[15] = state[11];
    end
endfunction

endmodule