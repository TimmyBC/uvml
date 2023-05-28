class uvml_hs_drive_pattern#(parameter DATA_WIDTH) extends uvml_object;

    string agent_name = "";

    function new(string agent_name = "NoHSAgentNameSet");
        this.agent_name = agent_name;
    endfunction

    virtual function string get_full_name();
        return agent_name;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] hs = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x);
        $fatal(1, "uvml_hs_drive_pattern.get_next_value must be implemented in derived classes");
    endfunction
//    pure virtual function logic [0:0] on_data(input logic [0:0] partner_value = 1'b0);
endclass : uvml_hs_drive_pattern



class uvml_hs_drive_random#(parameter DATA_WIDTH) extends uvml_hs_drive_pattern#(DATA_WIDTH);
    
    static function uvml_hs_drive_random#(DATA_WIDTH) create();
        uvml_hs_drive_random#(DATA_WIDTH) m = new();
        return m;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] hs = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x);
        return 1'($urandom_range(1, 0));
    endfunction 
        
endclass : uvml_hs_drive_random


class uvml_hs_drive_before#(parameter DATA_WIDTH) extends uvml_hs_drive_pattern#(DATA_WIDTH);
    
    static function uvml_hs_drive_before#(DATA_WIDTH) create();
        uvml_hs_drive_before#(DATA_WIDTH) m = new();
        return m;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] hs, input logic [DATA_WIDTH-1:0] data = 'x);
        assert (hs == 1'b0) else $error("uvml_hs_drive_before");
        return 1'b1;
    endfunction 
        
endclass : uvml_hs_drive_before



class uvml_hs_drive_after#(parameter DATA_WIDTH) extends uvml_hs_drive_pattern#(DATA_WIDTH);
    
    int delay;
    int delay_count = 0;
    
    static function uvml_hs_drive_after#(DATA_WIDTH) create(int delay = 0);
        uvml_hs_drive_after#(DATA_WIDTH) m = new();
        m.delay = delay;
        return m;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] hs, input logic [DATA_WIDTH-1:0] data = 'x);
        if (hs == 1'b1) begin
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