module realigan (
    e_i,
    m_i,
    out);
parameter M_X_W;
parameter E_W = 8;
reg [M_X_W] m;


always @* begin
  if (m_i < 0) begin
    m_i = -m_i;
  end
  if ()
end
endmodule
