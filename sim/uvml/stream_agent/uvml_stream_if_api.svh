virtual class uvml_stream_if_api_base#(parameter DATA_WIDTH) extends uvml_hs_if_api_base#(DATA_WIDTH + 1);
    
endclass

class uvml_stream_if_api#(type T_VIF, parameter DATA_WIDTH) extends uvml_stream_if_api_base#(DATA_WIDTH);

    T_VIF vif;
    
    function new(T_VIF vif);
       this.vif = vif;        
    endfunction

    virtual function void set_data(logic [DATA_WIDTH:0] d);
        {vif.last, vif.data} = d;
    endfunction
    
    virtual function logic [DATA_WIDTH:0] get_data();
        return {vif.last, vif.data};
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
    
        
    task wait_clock();
        @(posedge vif.clk);    
    endtask
    
    task wait_reset();
        @(negedge vif.rst);    
    endtask


endclass : uvml_stream_if_api
