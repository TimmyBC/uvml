typedef uvml_sequence_item uvml_stream_seq_item;

class uvml_stream_packet extends uvml_stream_seq_item;

    logic [7:0] data[];
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_print(uvml_logger log);
        $swriteh(log.data, "%0p", data);
    endfunction
    
    virtual function void do_copy(uvml_sequence_item rhs);
        uvml_stream_packet _rhs;
        $cast(_rhs, rhs);
        data = new[_rhs.data.size()](_rhs.data); 
    endfunction
    
    virtual function int do_compare(uvml_sequence_item rhs);
        uvml_stream_packet _rhs;
        $cast(_rhs, rhs);        
        return (_rhs.data === data);
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_pack_array(data);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        int sz = p.get_packedsize();
        data = new[sz/8];
        `uvml_unpack_array(data);
//    for (int _j=0; _j<data.size(); _j++) begin
//        for(int _i=0; _i<$bits(data[0]); _i++) data[_j][_i] = p.unpack_bit();
//        $display("%h",data[_j]);
//    end
    endfunction
    
endclass : uvml_stream_packet 
