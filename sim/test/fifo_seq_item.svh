class fifo_output extends axis_sequence_item;
    logic [31:0] header;
    logic [7:0] data[];

    `uvml_object_utils_begin(fifo_output)
        `uvml_field_logic(header, `UVML_NO_PACK)
        `uvml_field_array(data, `UVML_NO_PACK)
    `uvml_object_utils_end

    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_pack(uvml_packer p);
        `uvml_pack_logic(header);
        `uvml_pack_array(data);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_unpack_logic(header);
        data = new[p.get_unpackable_size()/8];
        `uvml_unpack_array(data);
    endfunction

endclass : fifo_output

class axis_data_packet#(type T = axis_sequence_item) extends T;

    logic [0:0] drop;
    logic [7:0] data[];
    
    `uvml_object_utils_begin(axis_data_packet#(T))
        `uvml_field_logic(drop, `UVML_NO_PACK)
        `uvml_field_array(data, `UVML_NO_PACK)
    `uvml_object_utils_end

    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_pack(uvml_packer p);
        super.do_pack(p);
        `uvml_pack_array(data);
        `uvml_user_pack_logic_at_last(drop);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_user_unpack_logic_at_last(drop);
        super.do_unpack(p);
        data = new[p.get_unpackable_size()/8];
        `uvml_unpack_array(data);
    endfunction

endclass : axis_data_packet 

class fifo_input extends axis_sequence_item;
    
    logic [31:0] header;
    logic [0:0] drop;
    logic [7:0] data[];

    `uvml_object_utils_begin(fifo_input)
        `uvml_field_logic(header, `UVML_NO_PACK)
        `uvml_field_logic(drop, `UVML_NO_PACK)
        `uvml_field_array(data, `UVML_NO_PACK)
    `uvml_object_utils_end

    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_pack(uvml_packer p);
        `uvml_pack_array(data);
        `uvml_user_pack_logic_at_last(drop);
        `uvml_user_pack_logic_at_last(header);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
         `uvml_user_unpack_logic_at_last(drop);
        `uvml_user_unpack_logic_at_last(header);
        data = new[p.get_unpackable_size()/8];
        `uvml_unpack_array(data);
    endfunction

endclass : fifo_input
