class uvml_stream_packer#(parameter DATA_WIDTH) extends uvml_packer;

    localparam HS_DATA_WIDTH = DATA_WIDTH + 1;
    
    uvml_hs_beat#(HS_DATA_WIDTH) beats[$];
    int ptr = 0;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction
    
    virtual function void new_beat();
        uvml_hs_beat#(HS_DATA_WIDTH) b = new("");
        b.data = {1'b0, {DATA_WIDTH{1'bx}}};
        beats.push_back(b);
        ptr = 0;
    endfunction
    
    virtual function void reset_unpack();
        assert (beats.size() == 0) else `uvml_warning("Not all beats got unpacked in previous packet");
        beats = {};
        ptr = 0;
    endfunction
    
    virtual function void reset_pack();
        beats = {};
        new_beat();
    endfunction
    
    virtual function void pack_bit(logic [0:0] b);
        if (ptr >= DATA_WIDTH) begin
            new_beat();            
        end
        beats[$].data[ptr++] = b;
        beats[$].valid_bit_count = ptr;
    endfunction
    
    virtual function void get_data(ref uvml_hs_beat#(HS_DATA_WIDTH) beat);
        assert (beats.size() > 0) else `uvml_fatal("No more packed data");
        beat = beats.pop_front();
        beat.data[DATA_WIDTH] = (beats.size() != 0) ? 1'b0 : 1'b1;  //last        
    endfunction
    
    virtual function void on_get_data(ref uvml_hs_beat#(HS_DATA_WIDTH) beat);
        assert (beats.size() > 0) else `uvml_fatal("No more packed data");
        beat = beats.pop_front();
        beat.data[DATA_WIDTH] = (beats.size() != 0) ? 1'b0 : 1'b1;  //last        
    endfunction
    
    virtual function void set_data(uvml_hs_beat#(HS_DATA_WIDTH) beat);
        beats.push_back(beat);
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
    
    virtual function int get_packedsize();
        return (beats.size()*DATA_WIDTH + ptr);
    endfunction
    
    virtual function int get_unpackable_size();
        return (beats.size()*DATA_WIDTH);
    endfunction
    
endclass

