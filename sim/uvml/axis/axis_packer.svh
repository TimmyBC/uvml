class axis_packer#(parameter DATA_WIDTH, parameter USER_WIDTH = 2) extends uvml_stream_packer#(DATA_WIDTH + DATA_WIDTH/8 + USER_WIDTH);

    localparam KEEP_WIDTH = DATA_WIDTH/8;
    localparam HS_DATA_WIDTH = DATA_WIDTH + KEEP_WIDTH + USER_WIDTH + 1;
    
    int usr_ptr = 0;
    int prv_usr_beat = -2;
    
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction
    
    virtual function void new_beat();
        uvml_hs_beat#(HS_DATA_WIDTH) b = new("");
        b.data = {1'b0, {USER_WIDTH{1'bx}}, {KEEP_WIDTH{1'b0}}, {DATA_WIDTH{1'bx}}};
        beats.push_back(b);
        ptr = 0;
        usr_ptr = 0;
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
        usr_ptr = 0;
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
    
    
    virtual function void pack_user_bit(logic [0:0] b, int arg = -1); //arg = beat index        
        assert (beats.size() > arg) else `uvml_fatal($sformatf("Beat %0d does not exist. User bit packing must be done after packing data", arg));
                
        if (prv_usr_beat != arg) begin
            usr_ptr = 0;
            prv_usr_beat = arg;
        end
        assert (usr_ptr < USER_WIDTH) else begin
            if (arg == -1) begin
                `uvml_fatal($sformatf("User packing at last beat (%0d) overflows. USER_WIDTH = %0d", beats.size()-1, USER_WIDTH));
            end
            else begin
                `uvml_fatal($sformatf("User packing at beat %0d overflows. USER_WIDTH = %0d", arg, USER_WIDTH));
            end
        end

        if (arg < 0)
            beats[$].data[DATA_WIDTH + KEEP_WIDTH + usr_ptr] = b;
        else
            beats[arg].data[DATA_WIDTH + KEEP_WIDTH + usr_ptr] = b;
        
        usr_ptr++;
    endfunction
    
    virtual function logic [0:0] unpack_user_bit(int arg = -1);
        logic [0:0] b;
        assert (beats.size() > arg) else `uvml_fatal($sformatf("Beat %0d does not exist. User bit unpacking must be done before unpacking data", arg));
                
        if (prv_usr_beat != arg) begin
            usr_ptr = 0;
            prv_usr_beat = arg;
        end
        assert (usr_ptr < USER_WIDTH) else `uvml_fatal($sformatf("User unpacking at beat %0d overflows. USER_WIDTH = %0d", arg, USER_WIDTH));
        
        if (arg < 0)
            b = beats[$].data[DATA_WIDTH + KEEP_WIDTH + usr_ptr];
        else
            b = beats[arg].data[DATA_WIDTH + KEEP_WIDTH + usr_ptr];
        
        usr_ptr++;
        return b;
    endfunction
    
//    virtual function logic [USER_WIDTH-1:0] get_user_at_beat(int beat_idx);
//        assert (beats.size() > beat_idx) else `uvml_fatal($sformatf("Beat %0d does not exist. 'get_user_at_beat' must be called before unpacking data", beat_idx));
//        return beats[beat_idx].data[(DATA_WIDTH + KEEP_WIDTH) +: USER_WIDTH];
//    endfunction
//    
//    virtual function logic [USER_WIDTH-1:0] get_user_at_first();
//        return get_user_at_beat(0);
//    endfunction
//    
//    virtual function logic [USER_WIDTH-1:0] get_user_at_last();
//        assert (beats.size() > 0) else `uvml_fatal("No beats. 'get_user_at_last' must be called before unpacking data");
//        return beats[$].data[(DATA_WIDTH + KEEP_WIDTH) +: USER_WIDTH];
//    endfunction
//    
//    
//    virtual function void set_user_at_beat(int beat_idx, logic [USER_WIDTH-1:0] user);
//        assert (beats.size() > beat_idx) else `uvml_fatal($sformatf("Beat %0d does not exist. 'set_user_at_beat' must be called after packing all data", beat_idx));
//        beats[beat_idx].data[(DATA_WIDTH + KEEP_WIDTH) +: USER_WIDTH] = user;
//    endfunction
//    
//    virtual function void set_user_at_first(logic [USER_WIDTH-1:0] user);
//        set_user_at_beat(0, user);
//    endfunction
//    
//    virtual function void set_user_at_last(logic [USER_WIDTH-1:0] user);
//        assert (beats.size() > 0) else `uvml_fatal("No beats. 'set_user_at_last' must be called after packing all data");
//        beats[$].data[(DATA_WIDTH + KEEP_WIDTH) +: USER_WIDTH] = user;
//    endfunction
    
endclass


