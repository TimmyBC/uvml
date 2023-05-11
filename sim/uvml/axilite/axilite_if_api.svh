class axilite_awaddr_if_api#(type T_VIF, parameter ADDR_WIDTH) extends uvml_hs_if_api_base#(ADDR_WIDTH);
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;          
    endfunction

    virtual function void set_data(logic [ADDR_WIDTH-1:0] d);
        vif.awaddr = d;
    endfunction
    
    virtual function logic [ADDR_WIDTH-1:0] get_data();
        return vif.awaddr;
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


endclass : axilite_awaddr_if_api




class axilite_wdata_if_api#(type T_VIF, parameter DATA_WIDTH) extends uvml_hs_if_api_base#(DATA_WIDTH + (DATA_WIDTH/8));

    localparam HS_DATA_WIDTH = DATA_WIDTH + (DATA_WIDTH/8);
    
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;         
    endfunction

    virtual function void set_data(logic [HS_DATA_WIDTH-1:0] d);
        {vif.wstrb, vif.wdata} = d;
    endfunction
    
    virtual function logic [HS_DATA_WIDTH-1:0] get_data();
        return {vif.wstrb, vif.wdata};
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


endclass : axilite_wdata_if_api




class axilite_bresp_if_api#(type T_VIF) extends uvml_hs_if_api_base#(2);

    localparam HS_DATA_WIDTH = 2;
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;         
    endfunction

    virtual function void set_data(logic [HS_DATA_WIDTH-1:0] d);
        vif.bresp = d;
    endfunction
    
    virtual function logic [HS_DATA_WIDTH-1:0] get_data();
        return vif.bresp;
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


endclass : axilite_bresp_if_api



class axilite_araddr_if_api#(type T_VIF, parameter ADDR_WIDTH) extends uvml_hs_if_api_base#(ADDR_WIDTH);

    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;         
    endfunction

    virtual function void set_data(logic [ADDR_WIDTH-1:0] d);
        vif.araddr = d;
    endfunction
    
    virtual function logic [ADDR_WIDTH-1:0] get_data();
        return vif.araddr;
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


endclass : axilite_araddr_if_api






class axilite_rdata_if_api#(type T_VIF, parameter DATA_WIDTH) extends uvml_hs_if_api_base#(DATA_WIDTH + 2);

    localparam HS_DATA_WIDTH = DATA_WIDTH + 2;
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;        
    endfunction

    virtual function void set_data(logic [HS_DATA_WIDTH-1:0] d);
        {vif.rresp, vif.rdata} = d;
    endfunction
    
    virtual function logic [HS_DATA_WIDTH-1:0] get_data();
        return {vif.rresp, vif.rdata};
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


endclass : axilite_rdata_if_api
