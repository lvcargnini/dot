module dot (clock, resetn, data, out);

genvar i;
generate
for (i = 0; i < N; i = i + 1) begin : whatever
  assign align_inst_s_i[i] = data[i * 32 + 31];
  assign align_inst_e_i[RANGE(i, E_W)] = data[i * 32 + 30 : i * 32 + 23];
  assign align_inst_m_i[RANGE(i, M_W)] = data[i * 32 + 22 : i * 32];
end
endgenerate

wire [M_X_W * N - 1 : 0] m_al;
wire [M_X_W - 1 : 0] m_sum;

// align
align align_inst (
    .clock,
    .resetn,
    .s_i(align_inst_s_i),
    .e_i(align_inst_e_i),
    .m_i(align_inst_m_i),
    .e_o(e_max),
    .m_o(m_al));
// TODO defparam ...

reduce reduce_inst (
    .clock(clock),
    .resetn(resetn),
    .in(m_al),
    .out(m_sum));

parameter FLO_INST_N = UPPERLOG2(M_X_W);




endmodule
