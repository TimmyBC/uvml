virtual class uvml_agent extends uvml_component;

	function new(string name, uvml_component parent);
		super.new(name, parent);
	endfunction

    pure virtual function uvml_sequencer get_sequencer(string arg = "");
    
    pure virtual function uvml_port get_monitor_port(string arg = "");
//    pure virtual function void connect_monitor_port(uvml_export ex_port, string arg = "");
    
    virtual task run_phase();
        `uvml_fatal({"\'", get_name(), "\' must override run_phase and fork driver.run_phase() and moniter.run_phase() as required"});
    endtask : run_phase
    
endclass : uvml_agent
