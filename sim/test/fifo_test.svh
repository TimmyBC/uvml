class fifo_test#(parameter MAX_PKT_BYTES) extends uvml_test;

    uvml_api_sequence#(axis_data_packet) snd_seq = null;
    uvml_api_sequence#(axis_data_packet) rcv_seq = null;
    mailbox#(axis_data_packet) inp_q;

    int count = 1000;
    
    function new(string name, uvml_env env);
        super.new(name, env);      
        inp_q = new(0);  
    endfunction

    task run_phase();
        axis_data_packet snd;
        axis_data_packet snt;
        axis_data_packet rcv;
        
        assert (snd_seq != null) else `uvml_fatal("snd_seq is null")
        assert (rcv_seq != null) else `uvml_fatal("rcv_seq is null")
        
        fork
            for (int i=0; i<count; i++) begin
                snd = new($sformatf("snd%0d",i), this);
                snd.drop = $urandom_range(3,0) == 0 ? 1'b1 : 1'b0;
                snd.data = new[$urandom_range(MAX_PKT_BYTES, 1)];
                foreach (snd.data[j])
                    snd.data[j] = 8'($urandom());
                snd.print(get_logger());
                snd_seq.send(snd);      
                inp_q.put(snd);
            end
            
            for (int j=0; j<count; j++) begin
                rcv = new($sformatf("rcv%0d",j), this);
                rcv_seq.receive(rcv, 1000);
                rcv.print(get_logger());
                inp_q.get(snt);
                if (snt.data === rcv.data && snt.drop === rcv.drop) begin
                    `uvml_info($sformatf("%d matched", j));
                end
                else begin
                    `uvml_fatal($sformatf("%d mismatched", j));
                end
            end
       
        join
    
    endtask : run_phase
    
   
    virtual task shutdown_phase();
        `uvml_info_color($sformatf("%0d packets tested", count), COLOR_BLUE, COLOR_BOLD);
        if (inp_q.num() == 0) 
            `uvml_info_color("All matched", COLOR_BLUE, COLOR_BOLD)
        else
            `uvml_error($sformatf("%d remains not received", inp_q.num()))
    endtask : shutdown_phase
endclass 

// snd338  [ drop  1'h 1 ] [ data 8'h{11} 62 173 211 63 48 17 200 39 204 6 187 ]