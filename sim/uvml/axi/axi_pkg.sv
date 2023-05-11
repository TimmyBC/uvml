package axi_pkg;
    import uvml_pkg::*;
    import uvml_hs_pkg::*;
    import uvml_stream_pkg::*;
    `include "uvml_macros.svh"
    
    localparam AXI_LEN_WIDTH = 8;
    localparam AXI_RESP_WIDTH = 2;
    
    `include "axi_if_api.svh"
    `include "axi_seq_item.svh"
    `include "axi_api_sequence.svh"
    `include "axi_packer.svh"
    `include "axi_agent.svh"
endpackage


