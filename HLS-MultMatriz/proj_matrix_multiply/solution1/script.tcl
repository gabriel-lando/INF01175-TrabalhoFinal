############################################################
## This file is generated automatically by Vivado HLS.
## Please DO NOT edit it.
## Copyright (C) 1986-2018 Xilinx, Inc. All Rights Reserved.
############################################################
open_project proj_matrix_multiply
set_top matrix_multiply_top
add_files matrix_multiply.cpp
add_files -tb matrix_multiply_tb.cpp -cflags "-Wno-unknown-pragmas"
open_solution "solution1"
set_part {xc7k70tfbv676-3}
create_clock -period 4 -name default
config_compile -no_signed_zeros=0 -unsafe_math_optimizations=0
source "./proj_matrix_multiply/solution1/directives.tcl"
csim_design
csynth_design
cosim_design
export_design -format ip_catalog
