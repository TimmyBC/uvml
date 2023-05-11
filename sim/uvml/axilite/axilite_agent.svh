class axilite_agent#(type T_VIF, parameter ADDR_WIDTH, parameter DATA_WIDTH) extends uvml_agent;

    localparam HS_WDATA_WIDTH = DATA_WIDTH + (DATA_WIDTH/8);
    localparam HS_RDATA_WIDTH = DATA_WIDTH + 2;
    
    uvml_hs_agent#(uvml_hs_beat#(ADDR_WIDTH), ADDR_WIDTH)         awaddr_agent;
    uvml_hs_agent#(uvml_hs_beat#(HS_WDATA_WIDTH), HS_WDATA_WIDTH) wdata_agent;
    uvml_hs_agent#(uvml_hs_beat#(2), 2)                           bresp_agent;
    uvml_hs_agent#(uvml_hs_beat#(ADDR_WIDTH), ADDR_WIDTH)         araddr_agent;
    uvml_hs_agent#(uvml_hs_beat#(HS_RDATA_WIDTH), HS_RDATA_WIDTH) rdata_agent;
    
    axilite_awaddr_if_api#(T_VIF, ADDR_WIDTH)   awaddr_if_api;
    axilite_wdata_if_api#(T_VIF, DATA_WIDTH)    wdata_if_api;
    axilite_bresp_if_api#(T_VIF)                bresp_if_api;
    axilite_araddr_if_api#(T_VIF, ADDR_WIDTH)   araddr_if_api;
    axilite_rdata_if_api#(T_VIF, DATA_WIDTH)    rdata_if_api;
    
    uvml_monitor_enable monitor_enable;
    
    axilite_driver#(T_VIF, ADDR_WIDTH, DATA_WIDTH) driver;    
    axilite_monitor#(T_VIF, ADDR_WIDTH, DATA_WIDTH) monitor;
    
    function new(uvml_env env, string name, T_VIF vif, uvml_agent_type agent_type, uvml_color seq_item_log = LOG_DISABLE, uvml_monitor_enable monitor_enable = MONITOR_DISABLE);
        uvml_agent_type agent_type_a;
        uvml_agent_type agent_type_b;
        
        super.new(name, env);
        env.add_agent(this);
        
        this.monitor_enable = monitor_enable;
        
        if (agent_type == MASTER_AGENT) begin
            agent_type_a = MASTER_AGENT;
            agent_type_b = SLAVE_AGENT;
        end
        else if (agent_type == SLAVE_AGENT) begin
            agent_type_a = SLAVE_AGENT;
            agent_type_b = MASTER_AGENT;
        end
        else begin
            `uvml_fatal("axilite agent support MASTER_AGENT or SLAVE_AGENT agent type only");    
        end
        
        awaddr_if_api = new(vif);
        wdata_if_api  = new(vif);
        bresp_if_api  = new(vif);
        araddr_if_api = new(vif);
        rdata_if_api  = new(vif);
        
        awaddr_agent = new(env, {name, ".awaddr_agent"}, awaddr_if_api, agent_type_a, uvml_hs_drive_random#(ADDR_WIDTH)::create(), LOG_DISABLE);
        wdata_agent  = new(env, {name, ".wdata_agent"},  wdata_if_api, agent_type_a, uvml_hs_drive_random#(HS_WDATA_WIDTH)::create(), LOG_DISABLE);
        bresp_agent  = new(env, {name, ".bresp_agent"},  bresp_if_api, agent_type_b, uvml_hs_drive_random#(2)::create(), LOG_DISABLE);
        araddr_agent = new(env, {name, ".araddr_agent"}, araddr_if_api, agent_type_a, uvml_hs_drive_random#(ADDR_WIDTH)::create(), LOG_DISABLE);
        rdata_agent  = new(env, {name, ".rdata_agent"},  rdata_if_api, agent_type_b, uvml_hs_drive_random#(HS_RDATA_WIDTH)::create(), LOG_DISABLE);
        
        driver = new("driver", this);
        driver.vif_api = awaddr_if_api;
        driver.agent_type = agent_type;
        driver.awaddr_sequencer = awaddr_agent.get_sequencer(); 
        driver.wdata_sequencer = wdata_agent.get_sequencer();
        driver.bresp_sequencer = bresp_agent.get_sequencer();
        driver.araddr_sequencer = araddr_agent.get_sequencer();
        driver.rdata_sequencer = rdata_agent.get_sequencer();
        
        monitor = new("moniter", this, seq_item_log);
        monitor.vif_api = awaddr_if_api;
        awaddr_agent.get_monitor_port().connect(monitor.awaddr_port); 
        wdata_agent.get_monitor_port().connect(monitor.wdata_port); 
        bresp_agent.get_monitor_port().connect(monitor.bresp_port); 
        araddr_agent.get_monitor_port().connect(monitor.araddr_port); 
        rdata_agent.get_monitor_port().connect(monitor.rdata_port); 
    endfunction

    virtual function uvml_sequencer get_sequencer(string arg = "");
        return driver.sequencer;
//return null;
    endfunction : get_sequencer

    virtual function uvml_port get_monitor_port(string arg = "");
        return monitor.port;
//return null;
    endfunction : get_monitor_port

    virtual task run_phase();
        fork
            if (driver.agent_type != PASSIVE_AGENT) begin
                driver.run();    
            end
            if (monitor_enable == MONITOR_ENABLE) begin
                monitor.run();
            end
        join
    endtask 
    
    
    virtual task end_run_phase();
        fork
            if (driver.agent_type != PASSIVE_AGENT) begin
                driver.end_run_phase();    
            end
            if (monitor_enable == MONITOR_ENABLE) begin
                monitor.end_run_phase();
            end
        join    
    endtask
        
    virtual task shutdown_phase();
        fork
            if (driver.agent_type != PASSIVE_AGENT) begin
                driver.shutdown();    
            end
            if (monitor_enable == MONITOR_ENABLE) begin
                monitor.shutdown();
            end
        join
    endtask

endclass : axilite_agent

