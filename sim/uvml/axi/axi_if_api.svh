class axi_awaddr_if_api#(type T_VIF, parameter ADDR_WIDTH) extends uvml_hs_if_api_base#(ADDR_WIDTH + AXI_LEN_WIDTH);
    
    localparam HS_AWADDR_WIDTH = ADDR_WIDTH + AXI_LEN_WIDTH; 
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;          
    endfunction

    virtual function void set_data(logic [HS_AWADDR_WIDTH-1:0] d);
        {vif.awlen, vif.awaddr} = d;
    endfunction
    
    virtual function logic [HS_AWADDR_WIDTH-1:0] get_data();
        return {vif.awlen, vif.awaddr};
    endfunction
    
    virtual function void set_valid(logic [0:0] v);
        vif.awvalid = v;
    endfunction
    
    virtual function logic [0:0] get_valid();
        return vif.awvalid;
    endfunction
        
    virtual function void set_ready(logic [0:0] r);
        vif.awready = r;
    endfunction
        
    virtual function logic [0:0] get_ready();
        return vif.awready;
    endfunction
    
        
    task wait_clock();
        @(posedge vif.aclk);    
    endtask
    
    task wait_reset();
        @(posedge vif.aresetn);    
    endtask


endclass : axi_awaddr_if_api




class axi_wdata_if_api#(type T_VIF, parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_if_api_base#(DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH);

    localparam STREAM_DATA_WIDTH = DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH + 1;
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;         
    endfunction

    virtual function void set_data(logic [STREAM_DATA_WIDTH-1:0] d);
        {vif.wlast, vif.wuser, vif.wstrb, vif.wdata} = d;
    endfunction
    
    virtual function logic [STREAM_DATA_WIDTH-1:0] get_data();
        return {vif.wlast, vif.wuser, vif.wstrb, vif.wdata};
    endfunction
    
    virtual function void set_valid(logic [0:0] v);
        vif.wvalid = v;
    endfunction
    
    virtual function logic [0:0] get_valid();
        return vif.wvalid;
    endfunction
        
    virtual function void set_ready(logic [0:0] r);
        vif.wready = r;
    endfunction
        
    virtual function logic [0:0] get_ready();
        return vif.wready;
    endfunction
    
        
    task wait_clock();
        @(posedge vif.aclk);    
    endtask
    
    task wait_reset();
        @(posedge vif.aresetn);    
    endtask


endclass : axi_wdata_if_api




class axi_bresp_if_api#(type T_VIF, parameter USER_WIDTH) extends uvml_hs_if_api_base#(USER_WIDTH + AXI_RESP_WIDTH);

    localparam HS_DATA_WIDTH = USER_WIDTH + AXI_RESP_WIDTH;
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;         
    endfunction

    virtual function void set_data(logic [HS_DATA_WIDTH-1:0] d);
        {vif.buser, vif.bresp} = d;
    endfunction
    
    virtual function logic [HS_DATA_WIDTH-1:0] get_data();
        return {vif.buser, vif.bresp};
    endfunction
    
    virtual function void set_valid(logic [0:0] v);
        vif.bvalid = v;
    endfunction
    
    virtual function logic [0:0] get_valid();
        return vif.bvalid;
    endfunction
        
    virtual function void set_ready(logic [0:0] r);
        vif.bready = r;
    endfunction
        
    virtual function logic [0:0] get_ready();
        return vif.bready;
    endfunction
    
        
    task wait_clock();
        @(posedge vif.aclk);    
    endtask
    
    task wait_reset();
        @(posedge vif.aresetn);    
    endtask


endclass : axi_bresp_if_api



class axi_araddr_if_api#(type T_VIF, parameter ADDR_WIDTH) extends uvml_hs_if_api_base#(ADDR_WIDTH + AXI_LEN_WIDTH);

    localparam HS_AWADDR_WIDTH = ADDR_WIDTH + AXI_LEN_WIDTH; 
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;         
    endfunction

    virtual function void set_data(logic [HS_AWADDR_WIDTH-1:0] d);
        {vif.arlen, vif.araddr} = d;
    endfunction
    
    virtual function logic [HS_AWADDR_WIDTH-1:0] get_data();
        return {vif.arlen, vif.araddr};
    endfunction
    
    virtual function void set_valid(logic [0:0] v);
        vif.arvalid = v;
    endfunction
    
    virtual function logic [0:0] get_valid();
        return vif.arvalid;
    endfunction
        
    virtual function void set_ready(logic [0:0] r);
        vif.arready = r;
    endfunction
        
    virtual function logic [0:0] get_ready();
        return vif.arready;
    endfunction
    
        
    task wait_clock();
        @(posedge vif.aclk);    
    endtask
    
    task wait_reset();
        @(posedge vif.aresetn);    
    endtask


endclass : axi_araddr_if_api






class axi_rdata_if_api#(type T_VIF, parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_if_api_base#(DATA_WIDTH + USER_WIDTH + AXI_RESP_WIDTH);

    localparam STREAM_DATA_WIDTH = DATA_WIDTH + USER_WIDTH + AXI_RESP_WIDTH + 1;
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;        
    endfunction

    virtual function void set_data(logic [STREAM_DATA_WIDTH-1:0] d);
        {vif.rlast, vif.ruser, vif.rresp, vif.rdata} = d;
    endfunction
    
    virtual function logic [STREAM_DATA_WIDTH-1:0] get_data();
        return {vif.rlast, vif.ruser, vif.rresp, vif.rdata};
    endfunction
    
    virtual function void set_valid(logic [0:0] v);
        vif.rvalid = v;
    endfunction
    
    virtual function logic [0:0] get_valid();
        return vif.rvalid;
    endfunction
        
    virtual function void set_ready(logic [0:0] r);
        vif.rready = r;
    endfunction
        
    virtual function logic [0:0] get_ready();
        return vif.rready;
    endfunction
    
        
    task wait_clock();
        @(posedge vif.aclk);    
    endtask
    
    task wait_reset();
        @(posedge vif.aresetn);    
    endtask


endclass : axi_rdata_if_api
