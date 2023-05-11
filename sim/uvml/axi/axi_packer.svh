class axi_w_packer#(parameter DATA_WIDTH, parameter USER_WIDTH) extends axis_pkg::axis_packer#(DATA_WIDTH, USER_WIDTH);
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction    
endclass

class axi_r_packer#(parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_packer#(DATA_WIDTH + AXI_RESP_WIDTH + USER_WIDTH);

    localparam HS_DATA_WIDTH = DATA_WIDTH + AXI_RESP_WIDTH + USER_WIDTH + 1;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction
    
    virtual function void new_beat();
        uvml_hs_beat#(HS_DATA_WIDTH) b = new("");
        b.data = {1'b0, {USER_WIDTH{1'bx}}, {AXI_RESP_WIDTH{1'bx}}, {DATA_WIDTH{1'bx}}};
        beats.push_back(b);
        ptr = 0;
    endfunction
    
    virtual function void reset_unpack();
        if (beats.size() != 0) begin
            `uvml_warning("Not all beats got unpacked in previous packet");
        end
        beats = {};
        ptr = 0;
    endfunction
    
    virtual function void pack_bit(logic [0:0] b);
        if (ptr >= DATA_WIDTH) begin
            new_beat();            
        end
        beats[$].data[ptr] = b;
        ptr++;
        beats[$].valid_bit_count = ptr;
    endfunction
    

    virtual function logic [0:0] unpack_bit();
        logic [0:0] b;
        assert (beats.size() > 0) else `uvml_fatal("No more bits to unpack");
        b = beats[0].data[ptr++];
        if (ptr == DATA_WIDTH) begin
            void'(beats.pop_front()); 
            ptr = 0;
        end
        return b;
    endfunction
    
// Todo:
//    virtual function int get_packedsize();
//        return ((beats.size()-1)*DATA_WIDTH + ptr);
//    endfunction
    
    virtual function int get_unpackable_size();
        return beats.size() * DATA_WIDTH;
    endfunction
    
endclass



