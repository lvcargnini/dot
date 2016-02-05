module maxi_wrapper (
    out,
    data,
    clock);
parameter N = 1024;
parameter DATA_WIDTH = 32;

input clock;
input [DATA_WIDTH - 1 : 0] data;
output reg [DATA_WIDTH - 1 : 0] out;

wire [DATA_WIDTH - 1 : 0] out_maxi;
reg [N * DATA_WIDTH * 2 - 1 : 0] in;

always @(posedge clock) begin
  in <= {(N * 2){data}};
  out <= out_maxi;
end

maxi #(
    .N(N),
    .DATA_WIDTH(DATA_WIDTH)) maxi_inst (
    .in(in),
    .out(out_maxi));
endmodule
