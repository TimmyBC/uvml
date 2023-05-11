class axis_drive_pattern#(parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_drive_pattern#(DATA_WIDTH + DATA_WIDTH/8 + USER_WIDTH);
    
    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value = 1'b0);
        $fatal(0, "axis_drive_pattern.get_next_value must be implemented");
    endfunction 
    
endclass


class axis_drive_random#(parameter DATA_WIDTH, parameter USER_WIDTH) extends axis_drive_pattern#(DATA_WIDTH, USER_WIDTH);
    
    static function axis_drive_random#(DATA_WIDTH, USER_WIDTH) create();
        axis_drive_random#(DATA_WIDTH, USER_WIDTH) m = new();
        return m;
    endfunction
    
    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value = 1'b0);
        return ($urandom_range(3, 0) > 0 ? 1'b1 : 1'b0);
    endfunction 
    
endclass
