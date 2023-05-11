package axis_pkg;
    import uvml_pkg::*;
    import uvml_hs_pkg::*;
    import uvml_stream_pkg::*;
    `include "uvml_macros.svh"
    
    typedef uvml_stream_seq_item axis_sequence_item;
    
    `include "axis_drive_pattern.svh"
    `include "axis_if_api.svh"
    `include "axis_packer.svh"
    `include "axis_agent.svh"
endpackage
