class eg_hs_test extends uvml_test;

    uvml_api_sequence#(eg_hs_seq_item) snd_seq = null;
    uvml_api_sequence#(eg_hs_seq_item) rcv_seq = null;
    
    int count = 10;
    
    function new(string name, uvml_env env);
        super.new(name, env);        
    endfunction

//    task reset_phase();
//        assert (hs_seq != null) else `uvml_fatal(LOG, "eg_hs_test.hs_seq is null")
//    endtask : reset_phase
//    
//    task main_phase();4
    task run_phase();
        eg_hs_seq_item it;
        eg_hs_seq_item rcv;
        
        assert (snd_seq != null) else `uvml_fatal("eg_hs_test.snd_seq is null")
        assert (rcv_seq != null) else `uvml_fatal("eg_hs_test.rcv_seq is null")
        
        fork
        for (int i=0; i<count; i++) begin
            it = new("test");
            it.a = i;
            it.b = $urandom();
            snd_seq.send(it);      
    //        it.print(get_logger());
        end
        
        for (int j=0; j<count; j++) begin
            rcv = new("rcv");
            rcv_seq.receive(rcv, 1000);
            `uvml_info($sformatf("%0x rcv item %0x %0x", j, rcv.a, rcv.b));
            assert(rcv.a == $bits(rcv.a)'(j)) else `uvml_fatal("MISMATCH")
        end
        
        join
        
    endtask : run_phase
    
   
    virtual task shutdown_phase();
        `uvml_info($sformatf("%0d packets tested", count));
    endtask : shutdown_phase
    
endclass : eg_hs_test
