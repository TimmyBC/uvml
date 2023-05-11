class eg_axis_seq_item extends axis_sequence_item;

    logic [15:0] hdr0;
    logic [23:0] hdr1;
    logic [1:0]  id;
    logic [1:0]  err;
    logic [7:0]  data[];
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);     
    endfunction

    virtual function void do_print(uvml_logger log);
        $swriteh(log.data, "%s | 16'h%h | 24'h%h | %0p", name, hdr0, hdr1, data);
    endfunction
    
    virtual function void do_copy(uvml_sequence_item rhs);
        eg_axis_seq_item _rhs;
        $cast(_rhs, rhs);
        data = new[_rhs.data.size()](_rhs.data); 
        hdr0 = _rhs.hdr0;
        hdr1 = _rhs.hdr1;
        id   = _rhs.id;
        err  = _rhs.err;
    endfunction
    
    virtual function int do_compare(uvml_sequence_item rhs);
        eg_axis_seq_item _rhs;
        $cast(_rhs, rhs);        
        return (_rhs.data === data) &&
               (_rhs.hdr0 === hdr0) && 
               (_rhs.hdr1 === hdr1) &&
               (_rhs.id   === id) &&
               (_rhs.err  === err);
    endfunction
    
    virtual function void do_pack(uvml_packer p);
        `uvml_pack_logic(hdr0);
        `uvml_pack_logic(hdr1);
        `uvml_pack_array(data);
    endfunction
    
    virtual function void do_unpack(uvml_packer p);
        `uvml_unpack_logic(hdr0);
        `uvml_unpack_logic(hdr1);
        data = new[p.get_unpackable_size()/8];
        `uvml_unpack_array(data);
    endfunction
    
endclass : eg_axis_seq_item 

