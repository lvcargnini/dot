// feed forward recursive
module flo (
    data,
    offset_i,
    offset_o);
parameter N;
parameter E_W;


output wire [E_W - 1 : 0] offset_o;
input wire [E_W - 1 : 0] offset_i;
input reg [E_W - 1 : 0] offset_i_sh;

wire [N / 2 - 1 : 0] datah = data[N - 1 : N / 2]);
wire [N / 2 - 1 : 0] datal = data[N / 2 - 1 : 0];
reg h;

generate
always @* begin
  h = (|datah);
  offset_i_sh = {offset_i[E_W - 1 : 1], h};
end
if (N >= 2) begin
  flo flo_inst (
      .data(h ? datah : datal),
      .offset_i(offset_i_sh),
      .offset_o(offset_o));
end
else begin
  assign offset_o = offset_i_sh;
end
endgenerate

end
