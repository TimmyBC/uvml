class axi_agent#(type T_VIF, parameter ADDR_WIDTH, parameter DATA_WIDTH, parameter USER_WIDTH, type T_W_SEQ_ITEM = axi_w_seq_item, type T_R_SEQ_ITEM = axi_r_seq_item) extends uvml_agent;


    localparam HS_ADDR_WIDTH    = ADDR_WIDTH + AXI_LEN_WIDTH; 
    localparam STRM_WDATA_WIDTH = DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH;
    localparam HS_BRESP_WIDTH   = USER_WIDTH + AXI_RESP_WIDTH;
    localparam STRM_RDATA_WIDTH = DATA_WIDTH + AXI_RESP_WIDTH + USER_WIDTH;
    
    uvml_hs_agent#(axi_aw_seq_item#(ADDR_WIDTH), HS_ADDR_WIDTH)                                  awaddr_agent;
    uvml_stream_agent#(T_W_SEQ_ITEM, STRM_WDATA_WIDTH, axi_w_packer#(DATA_WIDTH, USER_WIDTH))    wdata_agent;
    uvml_hs_agent#(axi_b_seq_item#(USER_WIDTH), HS_BRESP_WIDTH)                                  bresp_agent;
    uvml_hs_agent#(axi_ar_seq_item#(ADDR_WIDTH), HS_ADDR_WIDTH)                                  araddr_agent;
    uvml_stream_agent#(T_R_SEQ_ITEM, STRM_RDATA_WIDTH, axi_r_packer#(DATA_WIDTH, USER_WIDTH))    rdata_agent;
    
    axi_awaddr_if_api#(T_VIF, ADDR_WIDTH)               awaddr_if_api;
    axi_wdata_if_api#(T_VIF, DATA_WIDTH, USER_WIDTH)    wdata_if_api;
    axi_bresp_if_api#(T_VIF, USER_WIDTH)                bresp_if_api;
    axi_araddr_if_api#(T_VIF, ADDR_WIDTH)               araddr_if_api;
    axi_rdata_if_api#(T_VIF, DATA_WIDTH, USER_WIDTH)    rdata_if_api;
      
    function new(uvml_env env, string name, T_VIF vif, uvml_agent_type agent_type, uvml_color seq_item_log = LOG_DISABLE);
        uvml_agent_type agent_type_a;
        uvml_agent_type agent_type_b;
        
        super.new(name, env);
        env.add_agent(this);
          
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
        
        awaddr_agent = new(env, {name, ".awaddr_agent"}, awaddr_if_api, agent_type_a, uvml_hs_drive_random#(HS_ADDR_WIDTH)::create(), LOG_DEFAULT);
        wdata_agent  = new(env, {name, ".wdata_agent"},  wdata_if_api, agent_type_a, uvml_stream_drive_random#(STRM_WDATA_WIDTH)::create(), LOG_DEFAULT);
        bresp_agent  = new(env, {name, ".bresp_agent"},  bresp_if_api, agent_type_b, uvml_hs_drive_random#(HS_BRESP_WIDTH)::create(), LOG_DEFAULT);
        araddr_agent = new(env, {name, ".araddr_agent"}, araddr_if_api, agent_type_a, uvml_hs_drive_random#(HS_ADDR_WIDTH)::create(), LOG_DEFAULT);
        rdata_agent  = new(env, {name, ".rdata_agent"},  rdata_if_api, agent_type_b, uvml_stream_drive_random#(STRM_RDATA_WIDTH)::create(), LOG_DEFAULT);
        
    endfunction

    virtual function uvml_sequencer get_sequencer(string arg = "");
        if (arg == "aw")
            return awaddr_agent.get_sequencer();
        else  if (arg == "w")
            return wdata_agent.get_sequencer();
        else  if (arg == "b")
            return bresp_agent.get_sequencer();
        else  if (arg == "ar")
            return araddr_agent.get_sequencer();
        else  if (arg == "r")
            return rdata_agent.get_sequencer();
        else
            `uvml_fatal($sformatf("Unsupported argument '%s' for axi_agent.get_sequencer", arg));
    endfunction : get_sequencer

    virtual function uvml_port get_monitor_port(string arg = "");
        if (arg == "aw")
            return awaddr_agent.get_monitor_port();
        else  if (arg == "w")
            return wdata_agent.get_monitor_port();
        else  if (arg == "b")
            return bresp_agent.get_monitor_port();
        else  if (arg == "ar")
            return araddr_agent.get_monitor_port();
        else  if (arg == "r")
            return rdata_agent.get_monitor_port();
        else
            `uvml_fatal($sformatf("Unsupported argument '%s' for axi_agent.get_monitor_port", arg));
    endfunction : get_monitor_port

    virtual task run_phase();
//        fork
//            if (driver.agent_type != PASSIVE_AGENT) begin
//                driver.run();    
//            end
//            if (monitor_enable == MONITOR_ENABLE) begin
//                monitor.run();
//            end
//        join
    endtask 
    
    
    virtual task end_run_phase();
//        fork
//            if (driver.agent_type != PASSIVE_AGENT) begin
//                driver.end_run_phase();    
//            end
//            if (monitor_enable == MONITOR_ENABLE) begin
//                monitor.end_run_phase();
//            end
//        join    
    endtask
        
    virtual task shutdown_phase();
//        fork
//            if (driver.agent_type != PASSIVE_AGENT) begin
//                driver.shutdown();    
//            end
//            if (monitor_enable == MONITOR_ENABLE) begin
//                monitor.shutdown();
//            end
//        join
    endtask

endclass : axi_agent


