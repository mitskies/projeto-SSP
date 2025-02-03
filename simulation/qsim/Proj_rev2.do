onerror {quit -f}
vlib work
vlog -work work Proj_rev2.vo
vlog -work work Proj_rev2.vt
vsim -novopt -c -t 1ps -L max7000s_ver -L altera_ver -L altera_mf_ver -L 220model_ver -L sgate work.Proj_rev2_vlg_vec_tst
vcd file -direction Proj_rev2.msim.vcd
vcd add -internal Proj_rev2_vlg_vec_tst/*
vcd add -internal Proj_rev2_vlg_vec_tst/i1/*
add wave /*
run -all
