class axis_agent#(type T_SEQ_ITEM = axis_sequence_item, parameter DATA_WIDTH, parameter USER_WIDTH) extends uvml_stream_agent#(T_SEQ_ITEM, (DATA_WIDTH + DATA_WIDTH/8 + USER_WIDTH), axis_packer#(DATA_WIDTH, USER_WIDTH));

    function new(uvml_env env, string name, axis_if_api_base#(DATA_WIDTH, USER_WIDTH) axis_if_api, uvml_agent_type agent_type, axis_drive_pattern#(DATA_WIDTH, USER_WIDTH) drive, uvml_color seq_item_log );
        super.new(env, name, axis_if_api, agent_type, drive, seq_item_log);                 
    endfunction
    
endclass : axis_agent
