vlib work
vlog DSP48A1.v DSP48A1_tb.v Reg_Mux.v AddSub.v MULT.v 
vsim -voptargs=+acc work.DSP48A1_tb
add wave *
run -all
#quit -sim

