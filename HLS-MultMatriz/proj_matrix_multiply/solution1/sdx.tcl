# ==============================================================
# File generated on Wed Dec 19 00:31:28 -0200 2018
# Vivado(TM) HLS - High-Level Synthesis from C, C++ and SystemC v2018.3 (64-bit)
# SW Build 2405991 on Thu Dec  6 23:38:27 MST 2018
# IP Build 2404404 on Fri Dec  7 01:43:56 MST 2018
# Copyright 1986-2018 Xilinx, Inc. All Rights Reserved.
# ==============================================================
add_files -tb ../../matrix_multiply_tb.cpp -cflags { -Wno-unknown-pragmas}
add_files matrix_multiply.cpp
set_part xc7k70tfbv676-3
create_clock -name default -period 4
config_compile -no_signed_zeros=0
config_compile -unsafe_math_optimizations=0
