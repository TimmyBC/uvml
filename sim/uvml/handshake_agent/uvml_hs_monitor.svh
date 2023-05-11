class uvml_hs_monitor#(type T_SEQ_ITEM, parameter DATA_WIDTH = 64) extends uvml_monitor;

    uvml_hs_if_api_base#(DATA_WIDTH) vif_api;
    uvml_port port;
    uvml_hs_packer#(DATA_WIDTH) packer;
    uvml_color sequence_item_log;
    
	function new(string name, uvml_component parent);
		super.new(name, parent);
        port = new();
		packer = new("packer", this);
	endfunction

    virtual task run_phase();
        int count = 0;
        logic [0:0] ready = '0;
        
        forever begin
            #0;                         //To achieve same sub cycle behaviour in all simulators
            vif_api.wait_clock();
            
            ready = vif_api.get_ready();
            
            if (ready & vif_api.get_valid()) begin
                
                T_SEQ_ITEM seq_item = new($sformatf("hs%0d", count++));
                packer.set_data(vif_api.get_data());
                seq_item.do_unpack(packer);
  
                seq_item.print(logger);                
                port.write(seq_item);  
            end
            
        end
    endtask
    
endclass : uvml_hs_monitor 
