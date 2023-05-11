class axi_req_seq_item#(parameter ADDR_WIDTH) extends uvml_hs_seq_item;
    
    logic [ADDR_WIDTH-1:0]      addr;
    logic [AXI_LEN_WIDTH-1:0]   len;
    
    function new(string name);
        super.new(name);        
    endfunction
    
    function void do_print(uvml_logger log);
        `uvml_print_logic(addr);
        `uvml_print_logic(len);
    endfunction
    
    function int do_compare(uvml_sequence_item rhs);
        axi_req_seq_item#(ADDR_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        return `uvml_compare_logic(addr) && `uvml_compare_logic(len);
    endfunction
    
    function void do_copy(uvml_sequence_item rhs);
        axi_req_seq_item#(ADDR_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        addr = _rhs.addr;
        len = _rhs.len;
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_pack_logic(addr);
        `uvml_pack_logic(len);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_unpack_logic(addr);
        `uvml_unpack_logic(len);
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
    
    function new(string name);
        super.new(name);        
    endfunction
    
    function void do_print(uvml_logger log);
        `uvml_print_logic(resp);
        `uvml_print_logic(user);
    endfunction
    
    function int do_compare(uvml_sequence_item rhs);
        axi_b_seq_item#(USER_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        return `uvml_compare_logic(resp);
    endfunction
    
    function void do_copy(uvml_sequence_item rhs);
        axi_b_seq_item#(USER_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        resp = _rhs.resp;
        user = _rhs.user;
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_pack_logic(resp);
        `uvml_pack_logic(user);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_unpack_logic(resp);
        `uvml_unpack_logic(user);
    endfunction
    
endclass : axi_b_seq_item 


typedef uvml_stream_packet axi_rw_seq_item;


class axi_r_seq_item#(parameter USER_WIDTH) extends axi_rw_seq_item;

    logic [AXI_RESP_WIDTH-1:0] resp;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction
    
endclass : axi_r_seq_item 



class axi_data_seq_item#(parameter USER_WIDTH = 0) extends axi_r_seq_item#(USER_WIDTH);

    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

endclass : axi_data_seq_item


class axi_data_array_seq_item#(parameter USER_WIDTH = 0) extends axi_data_seq_item#(USER_WIDTH);

    logic [7:0] data[];
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_print(uvml_logger log);
        $swriteh(log.data, "%0p", data);
    endfunction
    
    virtual function void do_copy(uvml_sequence_item rhs);
        uvml_stream_packet _rhs;
        $cast(_rhs, rhs);
        data = new[_rhs.data.size()](_rhs.data); 
    endfunction
    
    virtual function int do_compare(uvml_sequence_item rhs);
        uvml_stream_packet _rhs;
        $cast(_rhs, rhs);        
        return (_rhs.data === data);
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_pack_array(data);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        int sz = p.get_unpackable_size();
        data = new[sz/8];
        `uvml_unpack_array(data);
    endfunction
    
endclass : axi_data_array_seq_item 
