module aes_add (
    input      [ 7:0] state     [15:0],
    input      [ 7:0] round_key [15:0],
    output reg [ 7:0] val       [15:0]
);

always @(*) begin
    for (int i = 0; i < 16; i++) begin
        val[i] = state[i] ^ round_key[i];
    end
end

endmodule
