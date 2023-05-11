interface class uvml_hs_drive_pattern#(parameter DATA_WIDTH);
    pure virtual function logic [0:0] get_next_value(input logic [0:0] partner_value = 1'b0);
//    pure virtual function logic [0:0] on_data(input logic [0:0] partner_value = 1'b0);
endclass : uvml_hs_drive_pattern



class uvml_hs_drive_random#(parameter DATA_WIDTH) implements uvml_hs_drive_pattern#(DATA_WIDTH);
    
    static function uvml_hs_drive_random#(DATA_WIDTH) create();
        uvml_hs_drive_random#(DATA_WIDTH) m = new();
        return m;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value = 1'b0);
        return 1'($urandom_range(1, 0));
    endfunction 
        
endclass : uvml_hs_drive_random


class uvml_hs_drive_before#(parameter DATA_WIDTH) implements uvml_hs_drive_pattern#(DATA_WIDTH);
    
    static function uvml_hs_drive_before#(DATA_WIDTH) create();
        uvml_hs_drive_before#(DATA_WIDTH) m = new();
        return m;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value);
        assert (partner_value == 1'b0) else $error("uvml_hs_drive_before");
        return 1'b1;
    endfunction 
        
endclass : uvml_hs_drive_before



class uvml_hs_drive_after#(parameter DATA_WIDTH) implements uvml_hs_drive_pattern#(DATA_WIDTH);
    
    int delay;
    int delay_count = 0;
    
    static function uvml_hs_drive_after#(DATA_WIDTH) create(int delay = 0);
        uvml_hs_drive_after#(DATA_WIDTH) m = new();
        m.delay = delay;
        return m;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] partner_value);
        if (partner_value == 1'b1) begin
            if (delay_count < delay) begin
                delay_count++;
                return 1'b0;
            end
            else begin
                delay_count = 0;
                return 1'b1;                 
            end
        end
        else
            return 1'b0;
    endfunction 
        
endclass : uvml_hs_drive_after