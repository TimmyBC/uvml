class uvml_hs_seq_item extends uvml_sequence_item;

	function new(string name, uvml_object parent = null);
		super.new(name, parent);
		
	endfunction

endclass : uvml_hs_seq_item


class uvml_hs_beat#(parameter DATA_WIDTH) extends uvml_hs_seq_item;

    logic [DATA_WIDTH-1:0] data;
    int valid_bit_count = 0;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction


    function void do_print(uvml_logger log);
        `uvml_print_logic(data);
    endfunction
    
    function int do_compare(uvml_sequence_item rhs);
        uvml_hs_beat#(DATA_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        return `uvml_compare_logic(data);
    endfunction
    
    function void do_pack(uvml_packer p);
        `uvml_pack_logic(data);
    endfunction
    
    function void do_unpack(uvml_packer p);
        `uvml_unpack_logic(data);
    endfunction


endclass