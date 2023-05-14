class uvml_hs_seq_item extends uvml_sequence_item;

	function new(string name, uvml_object parent = null);
		super.new(name, parent);
		
	endfunction

endclass : uvml_hs_seq_item


class uvml_hs_beat#(parameter DATA_WIDTH) extends uvml_hs_seq_item;

    logic [DATA_WIDTH-1:0] data;
    int valid_bit_count = 0;
    
    `uvml_object_utils_begin(uvml_hs_beat#(DATA_WIDTH))
        `uvml_field_logic(data, `UVML_DEFAULT)
    `uvml_object_utils_end


    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction

endclass