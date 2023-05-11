class uvml_hs_packer#(parameter DATA_WIDTH) extends uvml_packer;

    logic [DATA_WIDTH-1:0] data;
    int ptr = 0;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction
    
    virtual function void reset();
        data = 'x;
        ptr = 0;
    endfunction
    
    virtual function void pack_bit(logic [0:0] b);
        assert (ptr < DATA_WIDTH) else `uvml_fatal($sformatf("pack_bit overflows the DATA_WIDTH(%0d)", DATA_WIDTH));
        data[ptr++] = b;
    endfunction
    
    virtual function logic [DATA_WIDTH-1:0] get_data();
        assert (ptr == DATA_WIDTH) else `uvml_warning($sformatf("Not all bits packed. PACKED(%0d) < DATA_WIDTH(%0d)", ptr, DATA_WIDTH));
        return data;
    endfunction
    
    virtual function void set_data(logic [DATA_WIDTH-1:0] d);
        data = d;
        ptr = 0;
    endfunction
    
    virtual function logic [0:0] unpack_bit();
        assert (ptr < DATA_WIDTH) else `uvml_fatal($sformatf("unpack_bit overflows the DATA_WIDTH(%0d)", DATA_WIDTH));
        return data[ptr++];
    endfunction
    
    virtual function int get_packedsize();
        return ptr;
    endfunction
    
    virtual function int get_unpackable_size();
        return (DATA_WIDTH - ptr);
    endfunction
    
endclass : uvml_hs_packer
