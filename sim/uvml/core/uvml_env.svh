//class uvml_env extends uvml_component;
class uvml_env extends uvml_component;
    
    uvml_agent agents[string];
    uvml_component components[string];
    
	function new(string name);
		super.new(name, null);
	endfunction

	function void add_agent(uvml_agent agent);
        assert (agents.exists(agent.get_name()) == 0 && components.exists(agent.get_name()) == 0) else 
            `uvml_fatal({"uvml_env.add_agent with already existing agent/component name,'", agent.get_name(), "'"})
		agents[agent.get_name()] = agent;
    endfunction : add_agent
    
    function void add_component(uvml_component component);
        assert (agents.exists(component.get_name()) == 0 && components.exists(component.get_name()) == 0) else 
            `uvml_fatal({"uvml_env.add_component with already existing agent/component name,'", component.get_name(), "'"})
        components[component.get_name()] = component;
    endfunction : add_component
    
    function uvml_agent get_agent(string name);
        assert (agents.exists(name) == 1) else `uvml_fatal({"uvml_env.get_agent with non exisiting agent '", name, "'"})
        return agents[name];
    endfunction : get_agent
    
    function uvml_component get_component(string name);
        return components[name];
    endfunction : get_component
    
    function uvml_sequencer get_sequencer(string agent_name, string arg = "");
        uvml_sequencer seqr;
        assert (agents.exists(agent_name) == 1) else `uvml_fatal({"uvml_env.get_sequencer with non exisiting agent '", agent_name, "'"})
        seqr = agents[agent_name].get_sequencer(arg);
        assert (seqr != null) else `uvml_fatal($sformatf("\'%s\'.get_sequencer(%s) is null", agent_name, arg));
        return seqr;
    endfunction
    
    function uvml_port get_monitor_port(string agent_name, string arg = "");
        assert (agents.exists(agent_name) == 1) else `uvml_fatal({"uvml_env.connect_monitor_port with non exisiting agent '", agent_name, "'"})
        return agents[agent_name].get_monitor_port(arg);
    endfunction

//    function void connect_monitor_port(uvml_export ex_port, string agent_name, string arg = "");
//        assert (agents.exists(agent_name) == 1) else `uvml_fatal(LOG, {"uvml_env.connect_monitor_port with non exisiting agent '", agent_name, "'"})
//        agents[agent_name].connect_monitor_port(ex_port, arg);
//    endfunction
    
    virtual task run_phase(); 
        `uvml_info("--- START OF RUN PHASE ---")
        
        foreach(agents[s]) begin
            fork
                automatic string as = s;
                agents[as].pid = process::self();
                agents[as].run_phase();
            join_none
            #0;
        end
        
        foreach(components[s]) begin
            fork
                automatic string as = s;
                components[as].pid = process::self();
                components[as].run_phase();
            join_none
            #0;
        end
        
        wait fork;
    endtask : run_phase
    
    virtual task end_run_phase();
        foreach(agents[s]) begin
            fork
                automatic string as = s;
                agents[as].end_run_phase();
            join_none
            #0;
        end
        
        foreach(components[s]) begin
            fork
                automatic string as = s;
                components[as].end_run_phase();
            join_none
            #0;
        end
        
        #30;
        `uvml_info("--- END OF RUN PHASE ---")
        pid.kill();        
    endtask
    
    
    virtual task shutdown_phase();
        `uvml_info("--- START OF SHUTDOWN PHASE ---")
        
        foreach(agents[s]) begin
            fork
                automatic string as = s;
                agents[as].pid = process::self();
                agents[as].shutdown_phase();
            join_none
            #0;
        end
        
        foreach(components[s]) begin
            fork
                automatic string as = s;
                components[as].pid = process::self();
                components[as].shutdown_phase();
            join_none
            #0;
        end
    endtask : shutdown_phase
    
endclass : uvml_env
