class uvml_packer extends uvml_object;

    function new(string name, uvml_object parent = null);
        super.new();
        logger.tag = (parent == null) ? name : {parent.get_full_name(), ".", name};        
    endfunction

    virtual function void pack_bit(logic [0:0] b);
    
    endfunction
    
    virtual function logic [0:0] unpack_bit();
        return 1'bx;
    endfunction
    
    virtual function int get_packedsize();
        return 0;
    endfunction
    
    virtual function int get_unpackable_size();
        return 0;
    endfunction

    virtual function int get_beat_count();
        return 0;
    endfunction


    virtual function void pack_user_bit(logic [0:0] b, int arg = -1);
    
    endfunction
    
    virtual function logic [0:0] unpack_user_bit(int arg = -1);
        return 1'bx;
    endfunction
    
endclass : uvml_packer
