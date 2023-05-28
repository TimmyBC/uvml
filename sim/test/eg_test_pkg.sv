package eg_test_pkg;
    import uvml_pkg::*;
    import uvml_hs_pkg::*;
    import uvml_stream_pkg::*;
    import axis_pkg::*;
    import axilite_pkg::*;
    import axi_pkg::*;
    `include "uvml_macros.svh"

    `include "eg_axis_seq_item.svh"
    `include "eg_hs_seq_item.svh"
    `include "fifo_seq_item.svh"
    `include "eg_axilite_slave_seq.svh"
    
    `include "eg_hs_seq.svh"
    `include "eg_hs_test.svh"
    `include "eg_stream_test.svh"
    `include "eg_axis_test.svh"
    `include "eg_axilite_test.svh"
    `include "eg_axi_test.svh"
    `include "fifo_test.svh"
    `include "fifo_hdr_test.svh"
    `include "fifo_drp_test.svh"
endpackage
