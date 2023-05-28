class uvml_stream_agent#(type T_SEQ_ITEM = uvml_stream_seq_item, parameter DATA_WIDTH, type T_PACKER = uvml_stream_packer#(DATA_WIDTH)) extends uvml_agent;
    
    uvml_hs_agent#(uvml_hs_beat#(DATA_WIDTH + 1), DATA_WIDTH + 1) hs_agent;     // + 1 for {last, data}
    
    uvml_stream_driver#(DATA_WIDTH, T_PACKER) driver;    
    uvml_stream_monitor#(T_SEQ_ITEM, DATA_WIDTH, T_PACKER) monitor;
    
    function new(uvml_env env, string name, uvml_stream_if_api_base#(DATA_WIDTH) stream_if_api, uvml_agent_type agent_type, uvml_stream_drive_pattern#(DATA_WIDTH) drive, uvml_color seq_item_log);
        super.new(name, env);
        env.add_agent(this);
        
        hs_agent = new(env, {name, ".hs_agent"}, stream_if_api, agent_type, drive, LOG_DISABLE);

        drive.agent_name = get_full_name();

        driver = new("driver", this);
        driver.agent_type = agent_type;
        driver.drive = drive;
        driver.hs_sequencer = hs_agent.get_sequencer(); 
        
        monitor = new("moniter", this, seq_item_log);
        hs_agent.get_monitor_port().connect(monitor.hs_port); 
    endfunction

    virtual function uvml_sequencer get_sequencer(string arg = "");
        return driver.sequencer;
    endfunction : get_sequencer

    virtual function uvml_port get_monitor_port(string arg = "");
        return monitor.port;
    endfunction : get_monitor_port

    virtual task run_phase();
        fork
            if (driver.agent_type != PASSIVE_AGENT) begin
                driver.run();    
            end
            monitor.run();                
        join
    endtask 
    
    
    virtual task end_run_phase();
        fork
            if (driver.agent_type != PASSIVE_AGENT) begin
                driver.end_run_phase();    
            end
            monitor.end_run_phase();                
        join    
    endtask
        
    virtual task shutdown_phase();
        fork
            if (driver.agent_type != PASSIVE_AGENT) begin
                driver.shutdown();    
            end
            monitor.shutdown();                
        join
    endtask

endclass : uvml_stream_agent
