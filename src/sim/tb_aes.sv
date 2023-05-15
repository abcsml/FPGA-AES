`timescale 1ns/1ns

module tb_aes;

reg         sclk=1'b0;
reg         srst_n;

reg  [ 7:0] aes_text [15:0];
reg  [ 7:0] aes_key  [15:0];

wire [ 7:0] aes_data [15:0];
wire [ 7:0] aes_ans  [15:0];

// AXI-stream
reg              tvalid;
reg              tlast;
wire             tready;
reg      [ 31:0] tid;
wire     [127:0] tdata;

wire             ovalid;
wire     [ 31:0] oid;
wire     [127:0] odata;

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
    srst_n  <= 0;
    // init
    tvalid  <= 0;
    tlast   <= 0;
    tid     <= 0;
    repeat(4) @(posedge sclk);
    srst_n  <= 1;
    @(posedge sclk);
    // input
    tvalid  <= 1;
    tid     <= 1;
    @(posedge sclk);
    tlast   <= 1;
    @(posedge sclk);
    tvalid  <= 0;
    tlast   <= 0;
    #1000
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

assign aes_data = tlast ? aes_key : aes_text;

// array
genvar i;
generate
    for (i = 0; i < 16; i=i+1) begin
        assign tdata[(i+1)*8-1:i*8] = aes_data[i];
    end
endgenerate

generate
    for (i = 0; i < 16; i=i+1) begin
        assign aes_ans[i] = odata[(i+1)*8-1:i*8];
    end
endgenerate

always @(posedge sclk) begin
    if (ovalid) begin
        $display("aes crypt over:");
        for (int i=0;i<16;i=i+1) begin
            $display("%x", aes_ans[i]);
        end
    end
end

aes aes_inst (
    .sclk       (sclk      ),
    .srst_n     (srst_n     ),
    .tvalid     (tvalid     ),
    .tlast      (tlast      ),
    .tready     (tready     ),
    .tid        (tid        ),
    .tdata      (tdata      ),
    .ovalid     (ovalid     ),
    .oid        (oid        ),
    .odata      (odata      )
);

endmodule
