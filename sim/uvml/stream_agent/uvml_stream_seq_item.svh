typedef uvml_sequence_item uvml_stream_seq_item;

class uvml_stream_packet extends uvml_stream_seq_item;

    logic [7:0] data[];
    
    `uvml_object_utils_begin(uvml_stream_packet)
        `uvml_field_array(data, `UVML_DEFAULT | `UVML_FILL)
    `uvml_object_utils_end

    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction
    
endclass : uvml_stream_packet 
