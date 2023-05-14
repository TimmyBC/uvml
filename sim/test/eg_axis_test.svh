class eg_axis_test extends uvml_test;

    uvml_api_sequence#(eg_axis_seq_item) snd_seq = null;
    uvml_api_sequence#(eg_axis_seq_item) rcv_seq = null;
    
    int count = 4;
    
    function new(string name, uvml_env env);
        super.new(name, env);        
    endfunction

    task run_phase();
        eg_axis_seq_item snd;
        eg_axis_seq_item rcv;
        
        assert (snd_seq != null) else `uvml_fatal("snd_seq is null")
        assert (rcv_seq != null) else `uvml_fatal("rcv_seq is null")
        
//        fork
        for (int i=0; i<count; i++) begin
            snd = new($sformatf("axis%0d",i), this);
            snd.hdr0 = 16'($urandom());
            snd.hdr1 = 24'($urandom());
            snd.id = 2'($urandom());
            snd.err = 2'($urandom());
            snd.data = new[$urandom_range(100, 1)];
            foreach (snd.data[j])
                snd.data[j] = 8'($urandom());
            snd.print(get_logger());
            snd_seq.send(snd);      
        end
        
//        for (int j=0; j<count; j++) begin
//            rcv = new("rcv");
//            rcv_seq.receive(rcv, 1000);
//            snd.print(get_logger());
//        end
//        
//        join
        
    endtask : run_phase
    
   
    virtual task shutdown_phase();
        `uvml_info_color($sformatf("%0d packets tested", count), COLOR_BLUE, COLOR_BOLD);
    endtask : shutdown_phase
endclass 

