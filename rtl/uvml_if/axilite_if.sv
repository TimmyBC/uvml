interface axilite_if(
        aclk,
        aresetn
    );
    
    parameter ADDR_WIDTH = 8;
    parameter DATA_WIDTH = 32;
    
    localparam STROBE_WIDTH = DATA_WIDTH/8;
    localparam RESP_WIDTH   = 2;
    
    input                       aclk;
    input                       aresetn;
    
    logic [ADDR_WIDTH-1:0]      awaddr;
    logic                       awvalid;
    logic                       awready;
    
    logic [DATA_WIDTH-1:0]      wdata;
    logic [STROBE_WIDTH-1:0]    wstrb;
    logic                       wvalid;
    logic                       wready;
    
    logic [RESP_WIDTH-1:0]      bresp;
    logic                       bvalid;
    logic                       bready;
    
    logic [ADDR_WIDTH-1:0]      araddr;        
    logic                       arvalid;
    logic                       arready;      
    
    logic [DATA_WIDTH-1:0]      rdata;
    logic [RESP_WIDTH-1:0]      rresp;
    logic                       rvalid;
    logic                       rready;
        
    modport master(
            output awaddr,
            output awvalid,
            input  awready,
            
            output wdata,
            output wstrb,
            output wvalid,
            input  wready,
            
            input  bresp,
            input  bvalid,
            output bready,
            
            output araddr,
            output arvalid,
            input  arready,
            
            input  rdata,
            input  rresp,
            input  rvalid,
            output rready
        );
    
    modport slave(
            input  awaddr,
            input  awvalid,
            output awready,
            
            input  wdata,
            input  wstrb,
            input  wvalid,
            output wready,
            
            output bresp,
            output bvalid,
            input  bready,
            
            input  araddr,
            input  arvalid,
            output arready,
            
            output rdata,
            output rresp,
            output rvalid,
            input  rready
        );
    
endinterface
