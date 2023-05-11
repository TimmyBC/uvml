//typedef uvml_hs_drive_pattern#(parameter DATA_WIDTH) uvml_stream_drive_pattern#(DATA_WIDTH);
virtual class uvml_stream_drive_pattern#(parameter DATA_WIDTH) implements uvml_hs_drive_pattern#(DATA_WIDTH + 1);
    
//    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value = 1'b0);
//        return 1'($urandom_range(1, 0));
//    endfunction 
    
    virtual function int get_beat_timeout();
        return 50;
    endfunction
    
endclass

class uvml_stream_drive_random#(parameter DATA_WIDTH) extends uvml_stream_drive_pattern#(DATA_WIDTH);

    static function uvml_stream_drive_random#(DATA_WIDTH) create();
        uvml_stream_drive_random#(DATA_WIDTH) m = new();
        return m;
    endfunction
    
    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value = 1'b0);
        return ($urandom_range(3, 0) > 0 ? 1'b1 : 1'b0);
    endfunction 

endclass : uvml_stream_drive_random
