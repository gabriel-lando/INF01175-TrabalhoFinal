set clock_constraint { \
    name clk \
    module matrix_multiply_top \
    port ap_clk \
    period 1 \
    uncertainty 0.125 \
}

set all_path {}

set false_path {}

