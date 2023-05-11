class uvml_sequence extends uvml_object;

    string name;
    string full_name = "";
    
    function new(string name, uvml_object parent = null);
        super.new();
        this.name = name;
        this.full_name = (parent == null) ? name : {parent.get_full_name(), ".", name};
        logger.tag = this.full_name;        
    endfunction

    function string get_full_name();
        return full_name;
    endfunction

    task start();
        body();
    endtask
    
    virtual task body();
        
    endtask
    
endclass : uvml_sequence



class uvml_api_sequence#(type T = uvml_sequence_item) extends uvml_sequence;
    
    protected uvml_sequencer sequencer_handle;
    
    function new(string name, uvml_sequencer sequencer);
        super.new(name);
        sequencer_handle = sequencer;
    endfunction


    virtual task send(T req);
        sequencer_handle.send(req);
    endtask 
    
    virtual task send_wait(T req, input int ns = SEQUENCER_WAIT_FOREVER);
        sequencer_handle.send_wait(req, ns);
    endtask 
    
    virtual task send_receive(T req, ref T rsp, input int ns = SEQUENCER_WAIT_FOREVER);
        uvml_sequence_item _rsp;
        sequencer_handle.send_receive(req, _rsp, ns);
        void'($cast(rsp, _rsp));
    endtask 
    
    //If agent is in SLAVE_AUTO_AGENT mode receive does not work 
    virtual task receive(ref T rsp, input int ns = SEQUENCER_WAIT_FOREVER);
        uvml_sequence_item _rsp = rsp;
        sequencer_handle.receive(_rsp, ns);
    endtask
    
    function void set_process();
        pid = process::self();    
    endfunction
    
    task kill_process();
        pid.kill();
    endtask
endclass : uvml_api_sequence
