//typedef uvml_hs_drive_pattern#(parameter DATA_WIDTH) uvml_stream_drive_pattern#(DATA_WIDTH);
virtual class uvml_stream_drive_pattern#(parameter DATA_WIDTH, parameter TIMEOUT = 1000) extends uvml_hs_drive_pattern#(DATA_WIDTH + 1);

    function new(string agent_name = "NoStreamAgentNameSet");
        this.agent_name = agent_name;
    endfunction

    virtual function logic [0:0] get_next_value(input logic [0:0] hs = 1'b0, input logic [DATA_WIDTH:0] data = 'x);
        return get_next_value_stream(hs, data[DATA_WIDTH], data[DATA_WIDTH-1:0]);
    endfunction 
    
    virtual function logic [0:0] get_next_value_stream(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x);
        return 1'($urandom_range(1, 0));
    endfunction 

    virtual function int get_beat_timeout();
        return TIMEOUT;
    endfunction
    
endclass

class uvml_stream_drive_random#(parameter DATA_WIDTH, parameter TIMEOUT = 1000) extends uvml_stream_drive_pattern#(DATA_WIDTH, TIMEOUT);

    static function uvml_stream_drive_random#(DATA_WIDTH) create(string agent_name = "NoStreamAgentNameSet");
        uvml_stream_drive_random#(DATA_WIDTH) m = new(agent_name);
        return m;
    endfunction
    
    virtual function logic [0:0] get_next_value_stream(input logic [0:0] hs = 1'b0, input logic [0:0] last = 1'b0, input logic [DATA_WIDTH-1:0] data = 'x);
        return 1'($urandom_range(1, 0));
    endfunction 

endclass : uvml_stream_drive_random
