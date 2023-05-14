package axi_pkg;
    import uvml_pkg::*;
    import uvml_hs_pkg::*;
    import uvml_stream_pkg::*;
    `include "uvml_macros.svh"
    
    localparam AXI_LEN_WIDTH    = 8;
    localparam AXI_RESP_WIDTH   = 2;
    
    localparam [AXI_RESP_WIDTH-1:0] RESP_OKEY   = 2'b00;
    localparam [AXI_RESP_WIDTH-1:0] RESP_EXOKEY = 2'b01;
    localparam [AXI_RESP_WIDTH-1:0] RESP_SLVERR = 2'b10;
    localparam [AXI_RESP_WIDTH-1:0] RESP_DECERR = 2'b11;
    
    localparam RESP_ARG_OFFSET  = 100000;
    
    `include "axi_if_api.svh"
    `include "axi_packer.svh"
    `include "axi_seq_item.svh"
    `include "axi_api_sequence.svh"
    `include "axi_agent.svh"
endpackage


