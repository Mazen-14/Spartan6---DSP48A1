module MULT(in0,in1,out);
parameter WIDTH = 18;
input [WIDTH-1:0]in0,in1;
output [(WIDTH*2)-1:0]out;
assign out = in0 * in1;
endmodule

