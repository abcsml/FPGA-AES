module aes_keys (
    input           sclk,
    input           srst_n,
    input           en,
    input    [ 7:0] key       [15:0],
    output   [ 7:0] round_key [15:0],
    // for sbox
    output   [ 7:0] sbox_key  [ 3:0],
    input    [ 7:0] sbox_val  [ 3:0]
);

parameter ROUND = 10;

/**
 *****************************************
 * wire init
 *****************************************
 */

reg  [ 3:0] round;

reg  [31:0] w0;
reg  [31:0] w1;
reg  [31:0] w2;
reg  [31:0] w3;

wire [31:0] gw3;

wire [ 7:0] rcon [0:10];
assign rcon[ 0] = 'h0;
assign rcon[ 1] = 'h1;
assign rcon[ 2] = 'h2;
assign rcon[ 3] = 'h4;
assign rcon[ 4] = 'h8;
assign rcon[ 5] = 'h10;
assign rcon[ 6] = 'h20;
assign rcon[ 7] = 'h40;
assign rcon[ 8] = 'h80;
assign rcon[ 9] = 'h1B;
assign rcon[10] = 'h36;

/**
 *****************************************
 * main logic for generate round key
 *****************************************
 */

assign sbox_key[0] = w3[31:24];
assign sbox_key[1] = w3[ 7: 0];
assign sbox_key[2] = w3[15: 8];
assign sbox_key[3] = w3[23:16];

assign gw3[31:24]  = sbox_val[3] ^ rcon[round];
assign gw3[23:16]  = sbox_val[2];
assign gw3[15: 8]  = sbox_val[1];
assign gw3[ 7: 0]  = sbox_val[0];

assign {round_key[15], round_key[14], round_key[13], round_key[12]} = w0;
assign {round_key[11], round_key[10], round_key[ 9], round_key[ 8]} = w1;
assign {round_key[ 7], round_key[ 6], round_key[ 5], round_key[ 4]} = w2;
assign {round_key[ 3], round_key[ 2], round_key[ 1], round_key[ 0]} = w3;

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        round <= 0;
    else if (en)
        round <= 1;
    else if (round == ROUND)
        round <= 0;
    else if (round != 0)
        round <= round + 1;
end

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n) begin
        w0 <= 'h0;
        w1 <= 'h0;
        w2 <= 'h0;
        w3 <= 'h0;
    end
    else if (en) begin
        w0 <= {key[15], key[14], key[13], key[12]};
        w1 <= {key[11], key[10], key[ 9], key[ 8]};
        w2 <= {key[ 7], key[ 6], key[ 5], key[ 4]};
        w3 <= {key[ 3], key[ 2], key[ 1], key[ 0]};
    end
    else if (round != 0) begin
        w0 <= w0 ^ gw3;
        w1 <= w0 ^ gw3 ^ w1;
        w2 <= w0 ^ gw3 ^ w1 ^ w2;
        w3 <= w0 ^ gw3 ^ w1 ^ w2 ^ w3;
    end
end

endmodule