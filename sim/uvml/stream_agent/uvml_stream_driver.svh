class uvml_stream_driver#(parameter DATA_WIDTH, type T_PACKER = uvml_stream_packer#(DATA_WIDTH)) extends uvml_driver;
    
    uvml_agent_type agent_type;
    uvml_stream_drive_pattern#(DATA_WIDTH) drive; 
    uvml_sequencer hs_sequencer;
      
    local T_PACKER packer;
    
    function new(string name, uvml_component parent);
        super.new(name, parent);
        packer = new("stream_packer", this);
    endfunction

    virtual task run_phase();
        case (agent_type)
            MASTER_AGENT : begin 
                master_run_phase();
            end
            SLAVE_AGENT : begin 
                slave_run_phase();
            end
            SLAVE_AUTO_AGENT : begin 
                //no need to drive from here
            end
        endcase
    endtask
    
    task master_run_phase();
        uvml_hs_beat#(DATA_WIDTH + 1) beat;
        uvml_sequence_item req;
               
        forever begin
            bit last;
            sequencer.get_next_item(req);
            packer.reset_pack();
            req.do_pack(packer); 
            do begin
                packer.get_data(beat);
                last = beat.data[DATA_WIDTH];
                hs_sequencer.send(beat);
            end
            while(~last);
        end
    endtask
    
    task slave_run_phase();
        int count;
        bit last;
        uvml_hs_beat#(DATA_WIDTH + 1) beat;
        uvml_sequence_item rsp;
        uvml_sequence_item hs_rsp;
        int beat_timeout = drive.get_beat_timeout();
        
        forever begin
            count = 0;
            sequencer.get_next_item(rsp);
            packer.reset_unpack();
            do begin
                beat = new($sformatf("b%0d", count), this);
                hs_rsp = beat;
                hs_sequencer.receive(hs_rsp, beat_timeout);
                assert($cast(beat, hs_rsp));
                last = beat.data[DATA_WIDTH];
                packer.set_data(beat);
            end
            while(~last);
            rsp.do_unpack(packer); 
            sequencer.put_response(rsp);
        end
    endtask
    
endclass : uvml_stream_driver
