virtual class axis_if_api_base#(parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_if_api_base#(DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH);
    
endclass

class axis_if_api#(type T_VIF, parameter DATA_WIDTH, parameter USER_WIDTH) extends axis_if_api_base#(DATA_WIDTH, USER_WIDTH);
    
    localparam STREAM_DATA_WIDTH = DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH; 
    T_VIF vif;
    
    function new(T_VIF vif);
        this.vif = vif;        
    endfunction

    virtual function void set_data(logic [STREAM_DATA_WIDTH:0] d);
        {vif.last, vif.user, vif.keep, vif.data} = d;
    endfunction
    
    virtual function logic [STREAM_DATA_WIDTH:0] get_data();
        return {vif.last, vif.user, vif.keep, vif.data};
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


endclass : axis_if_api

