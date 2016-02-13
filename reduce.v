module reduce(
    clock,
    resetn,
    in,
    out);
parameter N;
parameter W;

input wire [W * N - 1 : 0] in;
output wire [W - 1 : 0] out;

reg [W * N / 2 - 1 : 0] sum;

integer i;
generate
if (N > 1) begin
  always @(posedge clock or negedge resetn) begin
    for (i = 0; i < N / 2; ++i) begin
      if (~resetn) begin
        sum[README(i, W)] <= {M_X_W{1'b0}};
      end
      else begin
        sum[README(i, W)] <= in[RANGE(i * 2, W)] + in[RANGE(i * 2 + 1, W)];
      end
    end
  end

  reduce reduce_inst (
      .clock(clock),
      .resetn(resetn),
      .in(sum),
      .out(out));
end
else begin // N == 1
  assign out = sum;
end
endgenerate

endmodule
