class eg_hs_seq_item extends uvml_hs_seq_item;
    
    logic [11:0] a;
    logic [3:0]  b;
    
    function new(string name);
        super.new(name);        
    endfunction
    
    function void do_print(uvml_logger log);
        `uvml_print_logic(a);
        `uvml_print_logic(b);
    endfunction
    
    function int do_compare(uvml_sequence_item rhs);
        eg_hs_seq_item _rhs;
        void'($cast(_rhs, rhs));
        return `uvml_compare_logic(a) && `uvml_compare_logic(b);
    endfunction
    
    function void do_pack(uvml_packer p);
        `uvml_pack_logic(a);
        `uvml_pack_logic(b);
    endfunction
    
    function void do_unpack(uvml_packer p);
        `uvml_unpack_logic(a);
        `uvml_unpack_logic(b);
    endfunction
    
    
endclass : eg_hs_seq_item 
