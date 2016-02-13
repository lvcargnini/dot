endmodule`include common.vh

module align (clock, resetn, s_i, e_i, m_i, e_o, m_o);
parameter N = 1024;
parameter DATA_WIDTH = 32;
parameter E_WIDTH = 8;
parameter M_WIDTH = 23;
parameter X_WIDTH = LOG2(N);
// sign bit
// padding ahead to prevent overflow;
// hidding 1;
// mantissa;
// tail extent for precision;
parameter M_X_WIDTH = 2 * X_WIDTH + M_WIDTH + 2;

input [N - 1 : 0] s_i;
input [E_W * N - 1 : 0] e_i;
input [M_W * N - 1 : 0] m_i;

output wire s_o = s_i;
output wire [E_WIDTH] e_o;
output wire [M_X_WIDTH * N - 1 : 0] m_o;

wire [E_W - 1 : 0] max_e;
wire [E_WIDTH - 1 : 0] e_diff [0 : N - 1];
reg [M_X_W - 1 : 0] m_x [0 : N - 1];
reg [M_X_W - 1 : 0] m_x_sh_1 [0 : N - 1];
reg [M_X_W - 1 : 0] m_x_sh_2 [0 : N - 1];

// get max exponent
maxi #(.DATA_WIDTH(E_WIDTH), .N(N)) maxi_inst (.in(e_i), .out(max_e));
assign e_o = max_e;

// get exponent diff
genvar i;
generate
for (i = 0; i < N; i = i + 1) begin : get_exponent_diff
  assign e_diff[i] = max_e - e_i[RANGE(i, E_WIDTH)];
end
endgenerate

// extent mantissa
generate
for (i = 0; i < N; i = i + 1) begin : ext_mantissa
  assign m_x[i] = {
    s_i[i] ? {(X_W + 1){1'b1}} : {(X_W + 1){1'b0}}, // sign ext
    1'b1, // hidden one
    m_i[RANGE(i, M_X_WIDTH)],
    {X_WIDTH{1'b0}}
  };
end
endgenerate

// shifting
integer i;
always @* begin
for (i = 0; i < N; i = i + 1) begin
  m_x_sh_1[i] = {{1'bx}};
  m_x_sh_2[i] = {{1'bx}};
  case (e_diff[i][5:3])
  0  : begin
  m_x_sh_1[i] = m_x[i];
  end
  1  : begin
  m_x_sh_1[i] = m_x[i] >>> 8;
  end
  2  : begin
  m_x_sh_1[i] = m_x[i] >>> 16;
  end
  3  : begin
  m_x_sh_1[i] = m_x[i] >>> 32;
  end
  default  : begin
  m_x_sh_1[i] = m_x[i] >>> 64;
  end

  case (e_diff[i][2:0])
  0  : begin
  m_x_sh_2[i] = m_x_sh_1[i];
  end
  1  : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 1;
  end
  2  : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 2;
  end
  3  : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 3;
  end
  4 : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 4;
  end
  5 : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 5;
  end
  6 : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 6;
  end
  7 : begin
  m_x_sh_2[i] = m_x_sh_1[i] >>> 7;
  end
end

// assign shift result to output
generate
for (i = 0; i < N; i = i + 1) begin : assign_to_rlt
  assign m_o[RANGE(i, M_X_W)] = m_x_sh_2[i];
end
endgenerate

endmodule
