module AddSub(in0,in1,cin,opmode,sum,carryout);
parameter WIDTH = 18;
input [WIDTH-1:0]in0,in1;
input opmode,cin;
output [WIDTH-1:0]sum;
output carryout;
assign {carryout,sum} = (opmode)? (in0-(in1+cin)) : (in0+in1+cin);
endmodule

