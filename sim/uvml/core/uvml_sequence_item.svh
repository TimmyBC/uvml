class uvml_sequence_item extends uvml_object;

    bit expect_response = 1;
    string name = "";
    string full_name = "";
    
	function new(string name, uvml_object parent = null);
		super.new();
		this.name = name;
        this.full_name = (parent == null) ? name : {parent.get_full_name(), ".", name};
        logger.tag = this.full_name;        
	endfunction

    function string get_full_name();
        return full_name;
    endfunction
    
    function void print(uvml_logger log);
        log.data = name;
        void'(field_ops(SEQ_ITM_PRNT, null, null, log));
        do_print(log);
        log.uvml_print(); 
        log.data = "";
    endfunction
        
    function int compare(uvml_sequence_item rhs);
        return field_ops(SEQ_ITM_CMP, rhs, null, null) & do_compare(rhs);
    endfunction
    
    function void copy(uvml_sequence_item rhs);
        void'(field_ops(SEQ_ITM_COPY, rhs, null, null));
        do_copy(rhs);
    endfunction
    
    function void pack(uvml_packer p);
        void'(field_ops(SEQ_ITM_PACK, null, p, null));
        do_pack(p);
    endfunction
    
    function void unpack(uvml_packer p);
        do_unpack(p);
        void'(field_ops(SEQ_ITM_UNPK, null, p, null));
    endfunction
    
    virtual function int field_ops(uvml_seq_itm_ops op, uvml_sequence_item _rhs, uvml_packer p, uvml_logger log);
        return 1;
    endfunction
    
    virtual function void do_print(uvml_logger log);
        
    endfunction
    
    virtual function void do_copy(uvml_sequence_item rhs);
        
    endfunction
    
    virtual function int do_compare(uvml_sequence_item rhs);
        return 1;
    endfunction
    
    virtual function void do_pack(uvml_packer p);
//        `uvml_error("do_pack must be implemented")
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
//        `uvml_error("do_unpack must be implemented")
    endfunction
        
endclass : uvml_sequence_item
