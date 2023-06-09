module aes_mix (
    input      [ 7:0] state [15:0],
    output reg [ 7:0] val   [15:0]
);

function [ 7:0] aes_mul;
    input [ 3:0] mix;
    input [ 7:0] y;
    reg   [ 7:0] a1,a2,a3;
    begin
        a1 = y[7] ? (y << 1)^'h1B : y << 1;
        a2 = a1[7] ? (a1 << 1)^'h1B : a1 << 1;
        a3 = a2[7] ? (a2 << 1)^'h1B : a2 << 1;

        aes_mul = (mix[0] ? y : 0)^
                  (mix[1] ? a1 : 0)^
                  (mix[2] ? a2 : 0)^
                  (mix[3] ? a3 : 0);
    end
endfunction

reg [ 7:0] a,b,c,d;

always @(*) begin
    for (int i = 0; i < 4; i=i+1) begin
        a = state[15-i*4];
        b = state[14-i*4];
        c = state[13-i*4];
        d = state[12-i*4];
        val[15-i*4] = aes_mul('h2, a) ^ aes_mul('h3, b) ^ aes_mul('h1, c) ^ aes_mul('h1, d);
        val[14-i*4] = aes_mul('h1, a) ^ aes_mul('h2, b) ^ aes_mul('h3, c) ^ aes_mul('h1, d);
        val[13-i*4] = aes_mul('h1, a) ^ aes_mul('h1, b) ^ aes_mul('h2, c) ^ aes_mul('h3, d);
        val[12-i*4] = aes_mul('h3, a) ^ aes_mul('h1, b) ^ aes_mul('h1, c) ^ aes_mul('h2, d);
    end
end

endmodule


