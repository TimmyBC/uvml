class uvml_hs_agent#(type T_SEQ_ITEM = uvml_hs_seq_item, parameter DATA_WIDTH = 64) extends uvml_agent;

    uvml_hs_driver#(T_SEQ_ITEM, DATA_WIDTH) driver;    
    uvml_hs_monitor#(T_SEQ_ITEM, DATA_WIDTH) monitor;
        
    static function uvml_hs_agent#(T_SEQ_ITEM, DATA_WIDTH) create(uvml_env env, string name, uvml_hs_if_api_base#(DATA_WIDTH) vif_api, uvml_agent_type agent_type, uvml_hs_drive_pattern#(DATA_WIDTH) drive, uvml_color seq_item_log = LOG_DEFAULT);
        uvml_hs_agent#(T_SEQ_ITEM, DATA_WIDTH) agent = new(env, name, vif_api, agent_type, drive, seq_item_log);
        return agent;
    endfunction

	function new(uvml_env env, string name, uvml_hs_if_api_base#(DATA_WIDTH) vif_api, uvml_agent_type agent_type, uvml_hs_drive_pattern#(DATA_WIDTH) drive, uvml_color seq_item_log);
        
        super.new(name, env);
        env.add_agent(this);
        
		driver = new("driver", this);
        driver.vif_api = vif_api;
        driver.agent_type = agent_type;
        driver.drive = drive;
        
        monitor = new("monitor", this);
        monitor.vif_api = vif_api;
        monitor.logger.print_color = seq_item_log;
	endfunction
    
    virtual function uvml_sequencer get_sequencer(string arg = "");
        return driver.get_sequencer();
    endfunction 
     
    virtual function uvml_port get_monitor_port(string arg = "");
        return monitor.port;
    endfunction

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
    
endclass : uvml_hs_agent
