module comp (
    a_in,
    b_in,
    out);
parameter DATA_WIDTH = 32;
input wire [DATA_WIDTH - 1 : 0] a_in;
input wire [DATA_WIDTH - 1 : 0] b_in;
output wire [DATA_WIDTH - 1 : 0] out;
assign out = a_in > b_in ? a_in : b_in;
endmodule

module maxi (
    in,
    out);
parameter N = 256;
parameter DATA_WIDTH = 32;

input wire [N * DATA_WIDTH * 2 - 1 : 0] in;
output wire [DATA_WIDTH - 1 : 0] out;

wire [N * DATA_WIDTH - 1 : 0] bigger;

genvar i;

generate
  for (i = 0; i < N; i = i + 1) begin :  recursive_maxing
    // TODO right?
    comp #(
        .DATA_WIDTH(DATA_WIDTH)) comp_inst (
        .a_in(in[(i * 2 + 1) * DATA_WIDTH - 1 : i * 2 * DATA_WIDTH]),
        .b_in(in[(i * 2 + 2) * DATA_WIDTH - 1 : (i * 2 + 1) * DATA_WIDTH]),
        .out(bigger[(i + 1) * DATA_WIDTH - 1 : i * DATA_WIDTH]));
  end
  if (N == 1) begin
    assign out = bigger[DATA_WIDTH - 1 : 0];
  end
  else begin
    maxi #(
        .DATA_WIDTH(DATA_WIDTH),
        .N(N / 2)) maxi_inst (
        .in(bigger),
        .out(out));
  end
endgenerate
endmodule
