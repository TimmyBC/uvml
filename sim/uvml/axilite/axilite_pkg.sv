package axilite_pkg;
    import uvml_pkg::*;
    import uvml_hs_pkg::*;
    `include "uvml_macros.svh"
    
    typedef enum {AXILITE_READ, AXILITE_WRITE} axilite_operation;
    
    `include "axilite_if_api.svh"
    `include "axilite_seq_item.svh"
    `include "axilite_api_sequence.svh"
    `include "axilite_monitor.svh"
    `include "axilite_driver.svh"
    `include "axilite_agent.svh"
endpackage

