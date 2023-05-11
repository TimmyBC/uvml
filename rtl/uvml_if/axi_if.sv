interface axi_if(
        aclk,
        aresetn
    );
    
//    parameter ID_WIDTH   = 4;
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 32;
    parameter USER_WIDTH = 1;
    
    localparam STROBE_WIDTH = DATA_WIDTH/8;
    localparam LEN_WIDTH    = 8;
    localparam RESP_WIDTH   = 2;
    
    input                       aclk;
    input                       aresetn;
    
//    logic [ID_WIDTH-1:0]        awid;
    logic [ADDR_WIDTH-1:0]      awaddr;
    logic [LEN_WIDTH-1:0]       awlen;
    logic                       awvalid;
    logic                       awready;
    
//    logic [ID_WIDTH-1:0]        wid;
    logic [DATA_WIDTH-1:0]      wdata;
    logic [STROBE_WIDTH-1:0]    wstrb;
    logic                       wlast;
    logic [USER_WIDTH-1:0]      wuser;
    logic                       wvalid;
    logic                       wready;
    
//    logic [ID_WIDTH-1:0]        bid;
    logic [RESP_WIDTH-1:0]      bresp;
    logic [USER_WIDTH-1:0]      buser;
    logic                       bvalid;
    logic                       bready;
    
//    logic [ID_WIDTH-1:0]        arid;
    logic [ADDR_WIDTH-1:0]      araddr;  
    logic [LEN_WIDTH-1:0]       arlen;
    logic                       arvalid;
    logic                       arready;      
    
//    logic [ID_WIDTH-1:0]        rid;
    logic [DATA_WIDTH-1:0]      rdata;
    logic [RESP_WIDTH-1:0]      rresp;
    logic                       rlast;
    logic [USER_WIDTH-1:0]      ruser;
    logic                       rvalid;
    logic                       rready;
        
    modport master(
//            output awid,
            output awaddr,
            output awlen,
            output awvalid,
            input  awready,
            
//            output wid,
            output wdata,
            output wstrb,
            output wlast,
            output wuser,
            output wvalid,
            input  wready,
            
//            input  bid,
            input  bresp,
            input  buser,
            input  bvalid,
            output bready,
            
//            output arid,
            output araddr,
            output arlen,
            output arvalid,
            input  arready,
            
//            input  rid,
            input  rdata,
            input  rresp,
            input  rlast,
            input  ruser,
            input  rvalid,
            output rready
        );
    
    modport slave(
//            input  awid,
            input  awaddr,
            input  awlen,
            input  awvalid,
            output awready,
            
//            input  wid,
            input  wdata,
            input  wstrb,
            input  wlast,
            input  wuser,
            input  wvalid,
            output wready,
            
//            output bid,
            output bresp,
            output bvalid,
            output buser,
            input  bready,
            
//            input  arid,
            input  araddr,
            input  arlen,
            input  arvalid,
            output arready,
            
//            output rid,
            output rdata,
            output rresp,
            output rlast,
            output ruser,
            output rvalid,
            input  rready
        );
    
endinterface

