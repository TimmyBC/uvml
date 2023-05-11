virtual class uvml_hs_if_api_base#(parameter DATA_WIDTH);

    pure virtual function void set_data(logic [DATA_WIDTH-1:0] d);
     
    pure virtual function logic [DATA_WIDTH-1:0] get_data();
    
    pure virtual function void set_valid(logic [0:0] v);
    
    pure virtual function logic [0:0] get_valid();
        
    pure virtual function void set_ready(logic [0:0] r);
        
    pure virtual function logic [0:0] get_ready();    
        
    pure virtual task wait_clock();
    
    pure virtual task wait_reset();
    
endclass : uvml_hs_if_api_base


class uvml_hs_if_api#(type T_VIF, parameter DATA_WIDTH) extends uvml_hs_if_api_base#(DATA_WIDTH);

    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;
//        assert(DATA_WIDTH >= get_data_width()) else $fatal(0, $sformatf("uvml_hs_if_api DATA_WIDTH [%0d] >= get_data_width() [%0d]", DATA_WIDTH, get_data_width()));
    endfunction
 
    static function uvml_hs_if_api#(T_VIF, DATA_WIDTH) create(T_VIF vif);
        uvml_hs_if_api#(T_VIF, DATA_WIDTH) obj;
        obj = new(vif);
        return obj;
    endfunction

    virtual function void set_data(logic [DATA_WIDTH-1:0] d);
        vif.data = d;
    endfunction
    
    virtual function logic [DATA_WIDTH-1:0] get_data();
        return vif.data;
    endfunction
    
    virtual function void set_valid(logic [0:0] v);
        vif.valid = v;
    endfunction
    
    virtual function logic [0:0] get_valid();
        return vif.valid;
    endfunction
        
    virtual function void set_ready(logic [0:0] r);
        vif.ready = r;
    endfunction
        
    virtual function logic [0:0] get_ready();
        return vif.ready;
    endfunction
    
        
    virtual task wait_clock();
        @(posedge vif.clk);    
    endtask
    
    virtual task wait_reset();
        @(negedge vif.rst);    
    endtask
    
endclass : uvml_hs_if_api
