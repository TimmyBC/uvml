class axi_req_seq_item#(parameter ADDR_WIDTH) extends uvml_hs_seq_item;
    
    logic [ADDR_WIDTH-1:0]      addr;
    logic [AXI_LEN_WIDTH-1:0]   len;

    `uvml_object_utils_begin(axi_req_seq_item#(ADDR_WIDTH))
        `uvml_field_logic(addr, `UVML_DEFAULT)
        `uvml_field_logic(len, `UVML_DEFAULT)
    `uvml_object_utils_end

    function new(string name);
        super.new(name);        
    endfunction
        
endclass : axi_req_seq_item 

class axi_aw_seq_item#(parameter ADDR_WIDTH) extends axi_req_seq_item#(ADDR_WIDTH);
    
    function new(string name);
        super.new(name);        
    endfunction
    
endclass

class axi_ar_seq_item#(parameter ADDR_WIDTH) extends axi_req_seq_item#(ADDR_WIDTH);
    
    function new(string name);
        super.new(name);        
    endfunction
    
endclass

class axi_b_seq_item#(parameter USER_WIDTH) extends uvml_hs_seq_item;
    
    logic [AXI_RESP_WIDTH-1:0]      resp;
    logic [USER_WIDTH-1:0]          user;

    `uvml_object_utils_begin(axi_b_seq_item#(USER_WIDTH))
        `uvml_field_logic(resp, `UVML_DEFAULT)
        `uvml_field_logic(user, `UVML_DEFAULT)
    `uvml_object_utils_end
    
    function new(string name);
        super.new(name);        
    endfunction
    
endclass : axi_b_seq_item 


class axi_rw_seq_item extends uvml_stream_seq_item;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void pack_resp(uvml_packer p, logic [AXI_RESP_WIDTH-1:0] resp_value = RESP_EXOKEY, bit resp_vec_filled = 1'b0);
        //only rdata will override, wdata will ignore
    endfunction
    
    virtual function void unpack_resp(uvml_packer p);

    endfunction
    
endclass : axi_rw_seq_item 


class axi_r_seq_item#(parameter USER_WIDTH = 0) extends axi_rw_seq_item;

    
    logic [AXI_RESP_WIDTH-1:0] resp[];
    
    `uvml_object_utils_begin(axi_r_seq_item#(USER_WIDTH))
        `uvml_field_array(resp, `UVML_NO_PACK)
    `uvml_object_utils_end
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction
    
    //must be called only after data is fully packed
    virtual function void pack_resp(uvml_packer p, logic [AXI_RESP_WIDTH-1:0] resp_value = RESP_EXOKEY, bit resp_vec_filled = 1'b0);
        if (!resp_vec_filled) begin
            resp = new[p.get_beat_count()];  
            foreach(resp[i]) resp[i] = resp_value;
        end
        
        foreach(resp[i]) begin
            for (int j=0; j<AXI_RESP_WIDTH; j++)
                p.pack_user_bit(resp[i][j], i - RESP_ARG_OFFSET);
        end
    endfunction
    
    //must be called only before unpacking any data
    virtual function void unpack_resp(uvml_packer p);
        resp = new[p.get_beat_count()];
        
        foreach(resp[i]) begin
            for (int j=0; j<AXI_RESP_WIDTH; j++)
                resp[i][j] = p.unpack_user_bit(i - RESP_ARG_OFFSET);
        end
    endfunction
    
endclass : axi_r_seq_item 



class axi_w_seq_item#(parameter USER_WIDTH = 0) extends axi_rw_seq_item;

    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_print(uvml_logger log);
    endfunction
    
endclass : axi_w_seq_item


class axi_data_array_seq_item#(type T = axi_rw_seq_item, parameter USER_WIDTH = 0) extends T;

    logic [7:0] data[];
        
    `uvml_object_utils_begin(axi_data_array_seq_item#(T, USER_WIDTH))
        `uvml_field_array(data, `UVML_DEFAULT | `UVML_FILL)
    `uvml_object_utils_end
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction
 
    virtual function void do_pack(uvml_packer p);
        pack_resp(p, RESP_OKEY);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        unpack_resp(p);
    endfunction
    
endclass : axi_data_array_seq_item 
