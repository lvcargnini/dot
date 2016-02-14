module realigan (
    e_max,
    m_sum,
    off,
    out);
parameter M_X_W;
parameter E_W = 8;

input [E_W - 1 : 0] e_max;
input [M_X_W - 1 : 0] m_sum;
output [31 : 0] out;

reg [M_X_W - 1 : 0] m_sum_pos;

reg [M_X_W - 1 : 0] m_sum_p;
reg [M_X_W - 1 : 0] m_sum_p_al;
reg [9 : 0] e_max_al; // 10 bits to present (-23 ~ 255 + 23).
reg [9 : 0] off;
reg [9 : 0] off_p;
wire [9 : 0] flo_off;

reg s;
reg [E_W - 1 : 0] e;
reg [M_W - 1 : 0] m;

always @* begin
  s = 1'b0;
  if (m_sum[M_X_W - 1]) begin // neg
    m_sum_p = -m_sum;
    s = 1'b1;
  end
end

always @* begin
  off = flo_off - 10'd23;
  e_max_al = {2'b00, e_max} + off;
  if (e_max_al[9]) begin // too small
    e = 8'h00;
  end
  else if (e_max_al[8]) begin // too big
    e = 8'hff;
  end else begin
    e = e_max_al[7 : 0];
  end
end

always @* begin // m_sum_p[M_X_W - 1] == 0
  m_sum_p_al = m_sum_p;
  if (off[9]) begin
    off_p = -off;
    if (off_p[4]) begin
      m_sum_p_al = m_sum_p_al << 5;
    end
    if (off_p[3]) begin
      m_sum_p_al = m_sum_p_al << 4;
    end
    if (off_p[2]) begin
      m_sum_p_al = m_sum_p_al << 3;
    end
    if (off_p[1]) begin
      m_sum_p_al = m_sum_p_al << 2;
    end
    if (off_p[0]) begin
      m_sum_p_al = m_sum_p_al << 1;
    end
  end
  else begin
    if (off[4]) begin
      m_sum_p_al = m_sum_p_al >> 5;
    end
    if (off[3]) begin
      m_sum_p_al = m_sum_p_al >> 4;
    end
    if (off[2]) begin
      m_sum_p_al = m_sum_p_al >> 3;
    end
    if (off[1]) begin
      m_sum_p_al = m_sum_p_al >> 2;
    end
    if (off[0]) begin
      m_sum_p_al = m_sum_p_al >> 1;
    end
  end
  m = m_sum_p_al[M_W - 1 : 0];
end

flo flo_inst (
    .data({(1 << E_W){1'b0}} | m_sum_pos),
    .off_i({E_W{1'b0}}),
    .off_o(flo_off));
defparam flo_inst.N = 1 << E_W;
defparam flo_inst.E_W = E_W;

always @* begin
  out = {s, e, m};
end

endmodule
