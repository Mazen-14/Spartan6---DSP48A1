module DSP48A1 #(
    parameter A0REG = 0,
    parameter A1REG = 1,
    parameter B0REG = 0,
    parameter B1REG = 1,
    parameter CREG = 1,
    parameter DREG = 1,
    parameter MREG = 1,
    parameter PREG = 1,
    parameter CARRYINREG = 1,
    parameter CARRYOUTREG = 1,
    parameter OPMODEREG = 1,
    parameter CARRYINSEL = "OPMODE5",
    parameter B_INPUT = "DIRECT",
    parameter RSTTYPE = "SYNC"
)(
    input clk,CARRYIN,
    input CEA, CEB, CEC, CECARRYIN, CED, CEM, CEOPMODE, CEP,
    input RSTA, RSTB, RSTC, RSTCARRYIN, RSTD, RSTM, RSTOPMODE, RSTP,
    input [17:0] A,B,D,BCIN,
    input [47:0] C,PCIN,
    input [7:0] opmode,
    output CARRYOUT,CARRYOUTF,
    output [17:0] BCOUT,
    output [35:0] M,
    output [47:0] P,PCOUT
);

wire [17:0] B_mux,mux_D_out,mux_B0_out,mux_A0_out,pre_AddSub_out,B1,mux_A1_out;
wire [47:0] mux_C_out;
wire [7:0] mux_opmode_out;
wire carrycascade,mux_CYI_out,post_CARRYOUT;
wire [35:0] M_out;
wire [47:0] post_AddSub_out;
reg [47:0] X,Z;



// Stage 1
assign B_mux = (B_INPUT == "CASCADE")? BCIN : B;
Reg_Mux #(RSTTYPE,DREG) D_Reg (clk,RSTD,CED,D,mux_D_out);
Reg_Mux #(RSTTYPE,B0REG) B0_Reg (clk,RSTB,CEB,B_mux,mux_B0_out);
Reg_Mux #(RSTTYPE,A0REG) A0_Reg (clk,RSTA,CEA,A,mux_A0_out);
Reg_Mux #(RSTTYPE,CREG,48) C_Reg (clk,RSTC,CEC,C,mux_C_out);
Reg_Mux #(RSTTYPE,OPMODEREG,8) opmode_reg (clk,RSTOPMODE,CEOPMODE,opmode,mux_opmode_out);

// Stage 2
AddSub Pre_AddSub (mux_D_out,mux_B0_out,0,mux_opmode_out[6],pre_AddSub_out);
assign B1 = (mux_opmode_out[4])? pre_AddSub_out : mux_B0_out;
Reg_Mux #(RSTTYPE,B1REG) B1_Reg (clk,RSTB,CEB,B1,BCOUT);
Reg_Mux #(RSTTYPE,A1REG) A1_Reg (clk,RSTA,CEA,mux_A0_out,mux_A1_out);

// Stage 3
MULT mult(BCOUT,mux_A1_out,M_out);
Reg_Mux #(RSTTYPE,MREG,36) M_Reg (clk,RSTM,CEM,M_out,M);
assign carrycascade = (CARRYINSEL == "OPMODE5")? mux_opmode_out[5] : CARRYIN ;
Reg_Mux #(RSTTYPE,CARRYINREG,1) CYI (clk,RSTCARRYIN,CECARRYIN,carrycascade,mux_CYI_out);

// Stage 4
always@(*)begin
    case(mux_opmode_out[1:0])
        2'b11 : X = {mux_D_out[11:0],mux_A1_out,BCOUT};
        2'b10 : X = PCOUT;
        2'b01 : X = {12'b0, M};
        2'b00 : X = 0;
        default : X = 0;
    endcase
end
always@(*)begin
    case(mux_opmode_out[3:2])
        2'b11 : Z = mux_C_out;
        2'b10 : Z = PCOUT;
        2'b01 : Z = PCIN;
        2'b00 : Z = 0;
        default : Z = 0;
    endcase
end

// Stage 5
AddSub #(48) Post_AddSub (Z,X,mux_CYI_out,mux_opmode_out[7],post_AddSub_out,post_CARRYOUT);
Reg_Mux #(RSTTYPE,CARRYOUTREG,1) CYO (clk,RSTCARRYIN,CECARRYIN,post_CARRYOUT,CARRYOUT);
assign CARRYOUTF = CARRYOUT;
Reg_Mux #(RSTTYPE,PREG,48) P_Reg (clk,RSTP,CEP,post_AddSub_out,P);
assign PCOUT = P;

endmodule