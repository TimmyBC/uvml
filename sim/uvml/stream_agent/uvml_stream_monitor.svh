class uvml_stream_monitor#(type T_SEQ_ITEM, parameter DATA_WIDTH, type T_PACKER = uvml_stream_packer#(DATA_WIDTH)) extends uvml_monitor;

    uvml_port port;
    uvml_export hs_port;
    
    local int count = 0;
    local T_PACKER packer;
    
    function new(string name, uvml_component parent, uvml_color log_color = LOG_DEFAULT);
        super.new(name, parent);
        port = new();
        hs_port = new();
        packer = new("stream_packer", this);
        logger.print_color = log_color;
    endfunction

    virtual task run_phase();
        bit last;
        uvml_hs_beat#(DATA_WIDTH + 1) beat;
        T_SEQ_ITEM stream_seq_it;
        uvml_sequence_item hs_seq_it;
        
        forever begin
            #0;
            packer.reset_unpack();
            do begin
                hs_port.get(hs_seq_it);
                assert($cast(beat, hs_seq_it));
                last = beat.data[DATA_WIDTH];
                packer.set_data(beat);
            end
            while(~last);
            stream_seq_it = new($sformatf("s%0d", count++));
            stream_seq_it.unpack(packer); 
            stream_seq_it.print(logger);
            port.write(stream_seq_it);
        end
    endtask
    

endclass : uvml_stream_monitor
