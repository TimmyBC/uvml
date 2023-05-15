class eg_axis_seq_item extends axis_sequence_item;

    logic [15:0] hdr0;
    logic [23:0] hdr1;
    logic [1:0]  id;
    logic [1:0]  err;
    logic [7:0]  data[]; 
    
    `uvml_object_utils_begin(eg_axis_seq_item)
        `uvml_field_logic(hdr0, `UVML_DEFAULT)
        `uvml_field_logic_bs(hdr1, `UVML_DEFAULT)
        `uvml_field_array(data, `UVML_DEFAULT | `UVML_FILL)
        `uvml_field_logic(id, `UVML_NO_PACK)
        `uvml_field_logic(err, `UVML_NO_PACK)
    `uvml_object_utils_end
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_user_pack_logic(id, 0);
        `uvml_user_pack_logic_at_last(err);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_user_unpack_logic(id, 0);
        `uvml_user_unpack_logic_at_last(err);
    endfunction
    
endclass : eg_axis_seq_item 

