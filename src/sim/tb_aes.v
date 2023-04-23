`timescale 1ns/1ns

module tb_aes;

reg         sclk;
reg         srst_n;

reg         aes_en;
reg  [ 7:0] aes_text [15:0];
reg  [ 7:0] aes_key  [15:0];
wire        aes_valid;
wire [ 7:0] aes_val  [15:0];

/**
 *****************************************
 * init
 *****************************************
 */

// wave
initial begin
    $fsdbDumpfile("aes.fsdb");
    $fsdbDumpvars;
    $fsdbDumpMDA();
end

initial begin
    sclk    = 1;
    srst_n  = 0;
    #100
    srst_n  = 1;

    aes_en  = 1;
    #10
    aes_en  = 0;
    #100000
    $finish();
end

initial $readmemh("aes_plain.mem", aes_text);
initial $readmemh("aes_keys.mem", aes_key);

/**
 *****************************************
 * main
 *****************************************
 */

always  #5 sclk = ~ sclk;

always @(posedge sclk) begin
    if (aes_valid) begin
        $display("aes crypt over:");
        for (int i=0;i<16;i++) begin
            $display("%x", aes_val[i]);
        end
    end
end

aes_core aes_core_inst (
    .sclk       (sclk       ),
    .srst_n     (srst_n     ),
    .en         (aes_en     ),
    .text       (aes_text   ),
    .key        (aes_key    ),
    .valid      (aes_valid  ),
    .val        (aes_val    )
);

endmodule
