module Reg_Mux(clk,rst,CE,d,out);
parameter RSTTYPE = "SYNC";
parameter REG = 1;
parameter WIDTH = 18;
input clk,rst,CE;
input [WIDTH-1:0]d;
reg [WIDTH-1:0]out_reg;
output [WIDTH-1:0]out;
generate
        if(RSTTYPE == "SYNC")begin
            always@(posedge clk)begin
                if(rst)out_reg<=0;
                else if(CE)out_reg<=d;
            end
        end
        else if(RSTTYPE == "ASYNC")begin
            always@(posedge clk or posedge rst)begin
                if(rst)out_reg<=0;
                else if(CE)out_reg<=d;
            end
        end     
endgenerate
assign out = (REG)? out_reg : d;
endmodule

