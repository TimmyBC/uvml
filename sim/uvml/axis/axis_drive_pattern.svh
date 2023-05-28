class axis_drive_pattern#(parameter DATA_WIDTH, parameter USER_WIDTH, parameter TIMEOUT = 1000) extends uvml_stream_drive_pattern#(DATA_WIDTH + DATA_WIDTH/8 + USER_WIDTH, TIMEOUT);
       
    virtual function logic [0:0] get_next_value_stream(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH + DATA_WIDTH/8 + USER_WIDTH-1:0] data = 'x);
        return get_next_value_axis(hs, last, data[0 +: DATA_WIDTH], data[(DATA_WIDTH + DATA_WIDTH/8) +: USER_WIDTH]);
    endfunction 
    
    virtual function logic [0:0] get_next_value_axis(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x, input logic [USER_WIDTH-1:0] user = 'x);
        `uvml_fatal("get_next_value must be implemented in child classes. axis_drive_pattern is not be instantiated directly.");
        return 1'b0;
    endfunction 

endclass


class axis_drive_random#(parameter DATA_WIDTH, parameter USER_WIDTH, parameter TIMEOUT = 1000) extends axis_drive_pattern#(DATA_WIDTH, USER_WIDTH, TIMEOUT);
    
    static function axis_drive_random#(DATA_WIDTH, USER_WIDTH) create();
        axis_drive_random#(DATA_WIDTH, USER_WIDTH) m = new();
        return m;
    endfunction
    
    virtual function logic [0:0] get_next_value_axis(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x, input logic [USER_WIDTH-1:0] user = 'x);
        return ($urandom_range(3, 0) > 0 ? 1'b1 : 1'b0);
    endfunction 
    
endclass

class axis_drive_always#(parameter DATA_WIDTH, parameter USER_WIDTH, parameter TIMEOUT = 1000) extends axis_drive_pattern#(DATA_WIDTH, USER_WIDTH, TIMEOUT);
    
    static function axis_drive_always#(DATA_WIDTH, USER_WIDTH) create();
        axis_drive_always#(DATA_WIDTH, USER_WIDTH) m = new();
        return m;
    endfunction
    
    virtual function logic [0:0] get_next_value_axis(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x, input logic [USER_WIDTH-1:0] user = 'x);
        return 1'b1;
    endfunction 
    
endclass

class axis_drive_const_pkt#(parameter DATA_WIDTH, parameter USER_WIDTH, TIMEOUT = 1000) extends axis_drive_pattern#(DATA_WIDTH, USER_WIDTH, TIMEOUT);
    
    bit eop = 1;
    uvml_hs_precedence precedence = HS_ANY;

    static function axis_drive_const_pkt#(DATA_WIDTH, USER_WIDTH) create(uvml_hs_precedence prcd = HS_ANY);
        axis_drive_const_pkt#(DATA_WIDTH, USER_WIDTH) m = new();
        m.precedence = prcd;
        return m;
    endfunction
    
    virtual function logic [0:0] get_next_value_axis(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x, input logic [USER_WIDTH-1:0] user = 'x);
        logic [0:0] r;
        if (eop) begin
            if (precedence == HS_DUT_FIRST && hs === 1'b0) begin
                return 1'b0;
            end
            if (precedence == HS_TB_FIRST && hs === 1'b1) begin
                `uvml_error("DUT does not honour HS_TB_FIRST drive pattern. DUT gives ready/valid before TB.");
            end
            r = ($urandom_range(3, 0) > 0 ? 1'b0 : 1'b1);
            if (r == 1'b1) begin
                eop = 0;
            end
        end
        else begin
            if (hs === 1'b1 && last === 1'b1) begin
                eop = 1;
                r = ($urandom_range(3, 0) > 0 ? 1'b0 : 1'b1);
            end
            else begin
                r = 1'b1;
            end
        end
        return r;
    endfunction 
    
endclass