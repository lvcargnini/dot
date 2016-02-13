`define ADDR (index, stride, offset) (index * stride + offset)
`define RANGE (index, stride) (index * stride - 1 : index * stride)
`define LOG2 (x) ( \
   (x <= 2) ? 1 : \
   (x <= 4) ? 2 : \
   (x <= 8) ? 3 : \
   (x <= 16) ? 4 : \
   (x <= 32) ? 5 : \
   (x <= 64) ? 6 : \
   (x <= 128) ? 7 : \
   (x <= 256) ? 8 : \
   (x <= 1024) ? 9 : \
   (x <= 2048) ? 10 : x)
