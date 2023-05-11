class eg_stream_test extends uvml_test;

    uvml_api_sequence#(uvml_stream_packet) snd_seq = null;
    uvml_api_sequence#(uvml_stream_packet) rcv_seq = null;
    
    int count = 10;
    
    function new(string name, uvml_env env);
        super.new(name, env);        
    endfunction

    task run_phase();
        uvml_stream_packet snd;
        uvml_stream_packet rcv;
        
        assert (snd_seq != null) else `uvml_fatal("eg_stream_test.snd_seq is null")
        assert (rcv_seq != null) else `uvml_fatal("eg_stream_test.rcv_seq is null")
        
        fork
            for (int i=0; i<count; i++) begin
                snd = new("test", this);
                snd.data = new[i + 6];
                foreach (snd.data[j])
                    snd.data[j] = 8'($urandom());
                snd_seq.send(snd);      
                snd.print(get_logger());
            end
            
            for (int j=0; j<count; j++) begin
                rcv = new("rcv");
                rcv_seq.receive(rcv, 1000);
                `uvml_info($sformatf("%p", rcv.data));
            end
        
        join
        
    endtask : run_phase
    
   
    virtual task shutdown_phase();
        `uvml_info_color($sformatf("%0d packets tested", count), COLOR_BLUE, COLOR_BOLD);
    endtask : shutdown_phase
endclass : eg_stream_test
