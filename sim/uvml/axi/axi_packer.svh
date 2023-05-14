class axi_w_packer#(parameter DATA_WIDTH, parameter USER_WIDTH) extends axis_pkg::axis_packer#(DATA_WIDTH, USER_WIDTH);
    function new(string name, uvml_object parent = null);
        super.new(name, parent);        
    endfunction    
endclass

class axi_r_packer#(parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_packer#(DATA_WIDTH + AXI_RESP_WIDTH + USER_WIDTH);

    localparam HS_DATA_WIDTH = DATA_WIDTH + AXI_RESP_WIDTH + USER_WIDTH + 1;
        
    int usr_ptr = 0;
    int prv_usr_beat = -2;
    
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
    
    virtual function void pack_user_bit(logic [0:0] b, int arg = -1); //arg = beat index        
        assert (beats.size() > arg) else `uvml_fatal($sformatf("Beat %0d does not exist. User bit packing must be done after packing data", arg));
                
        if (prv_usr_beat != arg) begin
            usr_ptr = 0;
            prv_usr_beat = arg;
        end        
        
        if (arg < -1)
            beats[(arg + RESP_ARG_OFFSET)].data[DATA_WIDTH + usr_ptr] = b;  //to get resp. only to be used by pack_resp in axi_data_seq_item
        else begin
            assert (usr_ptr < USER_WIDTH) else `uvml_fatal($sformatf("User packing at beat %0d overflows. USER_WIDTH = %0d", arg, USER_WIDTH));
            
            if (arg < 0)
                beats[$].data[DATA_WIDTH + AXI_RESP_WIDTH + usr_ptr] = b;
            else
                beats[arg].data[DATA_WIDTH + AXI_RESP_WIDTH + usr_ptr] = b;
        end
        usr_ptr++;
    endfunction
    
    virtual function logic [0:0] unpack_user_bit(int arg = -1);
        logic [0:0] b;
        assert (beats.size() > arg) else `uvml_fatal($sformatf("Beat %0d does not exist. User bit unpacking must be done before unpacking data", arg));
                
        if (prv_usr_beat != arg) begin
            usr_ptr = 0;
            prv_usr_beat = arg;
        end

        if (arg < -1)
            b = beats[(arg + RESP_ARG_OFFSET)].data[DATA_WIDTH + usr_ptr];  //to set resp. only to be used by unpack_resp in axi_data_seq_item
        else begin
            assert (usr_ptr < USER_WIDTH) else `uvml_fatal($sformatf("User unpacking at beat %0d overflows. USER_WIDTH = %0d", arg, USER_WIDTH));
            
            if (arg < 0)
                b = beats[$].data[DATA_WIDTH + AXI_RESP_WIDTH + usr_ptr];
            else
                b = beats[arg].data[DATA_WIDTH + AXI_RESP_WIDTH + usr_ptr];
        end
        usr_ptr++;
        return b;
    endfunction
    
    virtual function logic [AXI_RESP_WIDTH-1:0] pack_resp_at_beat(int beat_idx);
        assert (beats.size() > beat_idx) else `uvml_fatal($sformatf("Beat %0d does not exist. Resp packing must be done after packing all data", beat_idx));
        return beats[beat_idx].data[DATA_WIDTH +: AXI_RESP_WIDTH];
    endfunction
    
    virtual function void unpack_resp_at_beat(int beat_idx, logic [AXI_RESP_WIDTH-1:0] resp);
        assert (beats.size() > beat_idx) else `uvml_fatal($sformatf("Beat %0d does not exist. Resp unpacking must be done before unpacking data", beat_idx));
        beats[beat_idx].data[DATA_WIDTH +: AXI_RESP_WIDTH] = resp;
    endfunction
    
endclass



