class axis_packer#(parameter DATA_WIDTH, parameter USER_WIDTH = 2) extends uvml_stream_packer#(DATA_WIDTH + DATA_WIDTH/8 + USER_WIDTH);

    localparam KEEP_WIDTH = DATA_WIDTH/8;
    localparam HS_DATA_WIDTH = DATA_WIDTH + KEEP_WIDTH + USER_WIDTH + 1;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction
    
    virtual function void new_beat();
        uvml_hs_beat#(HS_DATA_WIDTH) b = new("");
        b.data = {1'b0, {USER_WIDTH{1'b0}}, {KEEP_WIDTH{1'b0}}, {DATA_WIDTH{1'bx}}};
        beats.push_back(b);
        ptr = 0;
    endfunction
    
    virtual function void reset_unpack();
        if (beats.size() != 0) begin
            assert (beats.size() == 1) begin
                int sz = 0;
                for (int j=0; j<KEEP_WIDTH; j++) begin
                    if (beats[0].data[DATA_WIDTH + j] === 1'b1) begin
                        sz += 8;    
                    end
                end
                assert (sz == ptr) else `uvml_warning($sformatf("%0d bits in the last beat did not get unpacked in previous packet", (sz - ptr)));
            end
            else
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
        if (ptr % 8 == 0) beats[$].data[DATA_WIDTH + (ptr/8)] = 1'b1;
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
        int sz = 0;
        foreach (beats[i]) begin
            for (int j=0; j<KEEP_WIDTH; j++) begin
                if (beats[i].data[DATA_WIDTH + j] === 1'b1) begin
                    sz += 8;    
                end
            end
        end
        return (sz - ptr);
    endfunction
    
endclass


