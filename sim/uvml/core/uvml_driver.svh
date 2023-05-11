class uvml_driver extends uvml_component;

    uvml_sequencer sequencer;
    
	function new(string name, uvml_component parent);
		super.new(name, parent);
		sequencer = new();
	endfunction

    virtual function uvml_sequencer get_sequencer();
        return sequencer;    
    endfunction
    
endclass : uvml_driver
