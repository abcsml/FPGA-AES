module aes (
    input              sclk,
    input              srst_n,
    // AXI-stream in interface
    input              tvalid,
    input              tlast,
    output reg         tready,
    input      [ 31:0] tid,
    input      [127:0] tdata,      // first: text, second: key
    // data out interface
    output             ovalid,
    output reg [ 31:0] oid,
    output     [127:0] odata
);

/**
 *****************************************
 * wire init
 *****************************************
 */

reg  [ 1:0] busy;
wire        aes_core_en;
wire        tfire;

// 2D array
reg  [ 7:0] text [15:0];
wire [ 7:0] data [15:0];
wire [ 7:0] val  [15:0];

/**
 *****************************************
 * main function
 *****************************************
 */

// array dim change (last data at lower)
genvar i;
generate
    for (i = 0; i < 16; i=i+1) begin
        assign data[i] = tdata[(i+1)*8-1:i*8];
    end
endgenerate

generate
    for (i = 0; i < 16; i=i+1) begin
        assign odata[(i+1)*8-1:i*8] = val[i];
    end
endgenerate

always @(posedge sclk) text <= data;

// wire connect
assign tready       = !busy[1];//(busy != 2'd3);
assign aes_core_en  = tvalid & tready & tlast;
// assign tfire        = tvalid & tready;

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        busy <= 0;
    else if (tvalid & tready)
        busy <= busy + 1;
    else if (ovalid)
        busy <= 0;
end

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        oid <= 0;
    else if (tvalid & tready)
        oid <= tid;
end

/**
 *****************************************
 * module instantiation
 *****************************************
 */

aes_core aes_core_inst (
    .sclk   (sclk           ),
    .srst_n (srst_n         ),
    .en     (aes_core_en    ),
    .text   (text           ),
    .key    (data           ),
    .valid  (ovalid         ),
    .val    (val            )
);

endmodule
