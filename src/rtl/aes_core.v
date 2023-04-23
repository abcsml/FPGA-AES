module aes_core (
    input             sclk,
    input             srst_n,
    input             en,
    input      [ 7:0] text  [15:0],
    input      [ 7:0] key   [15:0],
    output reg        valid,
    output     [ 7:0] val   [15:0]
);

parameter ROUND_END = 11;

/**
 *****************************************
 * wire init
 *****************************************
 */

reg  [ 3:0] round;

// for module
wire [ 7:0] sbox_state  [15:0];
wire [ 7:0] sbox_val    [15:0];
wire [ 7:0] shift_state [15:0];
wire [ 7:0] shift_val   [15:0];
wire [ 7:0] mix_state   [15:0];
wire [ 7:0] mix_val     [15:0];
wire [ 7:0] add_state   [15:0];
wire [ 7:0] add_val     [15:0];

wire [ 7:0] sbox_key    [ 3:0];
wire [ 7:0] sbox_key_va [ 3:0];
wire [ 7:0] round_key   [15:0];

// for state
reg  [ 7:0] state       [15:0];
wire [ 7:0] state_1     [15:0];
wire [ 7:0] state_2     [15:0];
wire [ 7:0] state_3     [15:0];
wire [ 7:0] state_4     [15:0];

/**
 *****************************************
 * main function
 *****************************************
 */

// sub bytes
assign sbox_state  = state;
assign state_1     = sbox_val;

// shift row
assign shift_state = state_1;
assign state_2     = shift_val;

// mix col
assign mix_state   = state_2;
assign state_3     = round == ROUND_END ? state_2 : mix_val;

// round add
assign add_state   = round == 1 ? state : state_3;
assign state_4     = add_val;

// output
assign val         = state;

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        round <= 0;
    else if (en)
        round <= 1;
    else if (round == ROUND_END)
        round <= 0;
    else if (round != 0)
        round <= round + 1;
end

always @(posedge sclk or negedge srst_n) begin
    if (en)
        state <= text;
    else if (round != 0)
        state <= state_4;
end

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        valid <= 0;
    else if (round == ROUND_END)
        valid <= 1;
    else
        valid <= 0;
end

/**
 *****************************************
 * module instantiation
 *****************************************
 */

aes_sbox aes_sbox_inst (
    .state      (sbox_state     ),
    .state_val  (sbox_val       ),
    .key        (sbox_key       ),
    .key_val    (sbox_key_va    )
);

aes_shift aes_shift_inst (
    .state      (shift_state    ),
    .val        (shift_val      )
);

aes_mix aes_mix_inst (
    .state      (mix_state      ),
    .val        (mix_val        )
);

aes_add aes_add_inst (
    .state      (add_state      ),
    .round_key  (round_key      ),
    .val        (add_val        )
);

aes_keys aes_keys_inst (
    .sclk       (sclk           ),
    .srst_n     (srst_n         ),
    .en         (en             ),
    .key        (key            ),
    .round_key  (round_key      ),
    .sbox_key   (sbox_key       ),
    .sbox_val   (sbox_key_va    )
);

endmodule