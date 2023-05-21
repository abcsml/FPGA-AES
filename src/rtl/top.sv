module top (
    input           sclk,
    input           srst_n
);

parameter INIT_COUNT = 10;

reg  [ 7:0] aes_text [15:0] = '{8'hae, 8'h2d, 8'h8a, 8'h57, 8'h1e, 8'h03, 8'hac, 8'h9c, 8'h9e, 8'hb7, 8'h6f, 8'hac, 8'h45, 8'haf, 8'h8e, 8'h51};
reg  [ 7:0] aes_key  [15:0] = '{8'h2b, 8'h7e, 8'h15, 8'h16, 8'h28, 8'hae, 8'hd2, 8'ha6, 8'hab, 8'hf7, 8'h15, 8'h88, 8'h09, 8'hcf, 8'h4f, 8'h3c};
wire [ 7:0] aes_data [15:0];
wire [ 7:0] aes_ans  [15:0];

// AXI-stream
wire         tvalid;
wire         tlast;
wire         tready;
reg  [ 31:0] tid = 1;
wire [127:0] tdata;

wire         ovalid;
wire [ 31:0] oid;
wire [127:0] odata;

// count
reg  [ 3:0] init_count;
reg  [ 1:0] valid_count;
wire        flag_start;

//clock
wire clk_out;

/**
 *****************************************
 * main
 *****************************************
 */

assign flag_start = init_count == INIT_COUNT;
assign tvalid     = (valid_count == 1) || (valid_count == 2);
assign tlast      = valid_count == 2;
assign aes_data   = tlast ? aes_key : aes_text;

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

// main
always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        init_count <= 0;
    else if (init_count != INIT_COUNT)
        init_count <= init_count + 1'b1;
    else if (flag_start && ovalid)
        init_count <= 0;
    else
        init_count <= init_count;
end

always @(posedge sclk or negedge srst_n) begin
    if (!srst_n)
        valid_count <= 0;
    else if (flag_start && valid_count != 3)
        valid_count <= valid_count + 1'b1;
    else
        valid_count <= valid_count;
end

/**
 *****************************************
 * inst
 *****************************************
 */

// clock
clk_wiz_0 clk_wiz_0_inst (
    .clk_out1   (clk_out    ),
    .reset      (srst_n     ),
    .locked     (           ),
    .clk_in1    (sclk       )
);

// ila
ila_0 ila_0_inst (
    .clk        (clk_out        ),
    .probe0     (aes_ans[0]     ),
    .probe1     (aes_ans[1]     ),
    .probe2     (aes_ans[2]     ),
    .probe3     (aes_ans[3]     ),
    .probe4     (aes_ans[4]     ),
    .probe5     (aes_ans[5]     ),
    .probe6     (aes_ans[6]     ),
    .probe7     (aes_ans[7]     ),
    .probe8     (aes_ans[8]     ),
    .probe9     (aes_ans[9]     ),
    .probe10    (aes_ans[10]    ),
    .probe11    (aes_ans[11]    ),
    .probe12    (aes_ans[12]    ),
    .probe13    (aes_ans[13]    ),
    .probe14    (aes_ans[14]    ),
    .probe15    (aes_ans[15]    ),
    .probe16    (ovalid         )
);

aes aes_inst (
    .sclk       (clk_out    ),
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