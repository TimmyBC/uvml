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
    
//    function void print(uvml_logger log);
//        log.data = {name, "\n---------------------------"};
//        do_print(log);
//        log.data = {log.data, "\n---------------------------"};
//        log.uvml_info();
//    endfunction
//    
    function void print(uvml_logger log);
        log.data = name;
        do_print(log);
        log.uvml_print(); 
        log.data = "";
    endfunction
    
    virtual function void do_print(uvml_logger log);
        
    endfunction
    
    virtual function void do_copy(uvml_sequence_item rhs);
        
    endfunction
    
    virtual function int do_compare(uvml_sequence_item rhs);
        return 0;
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_error("do_pack must be implemented")
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_error("do_unpack must be implemented")
    endfunction
        
endclass : uvml_sequence_item
