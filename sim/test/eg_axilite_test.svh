class eg_axilite_test extends uvml_test;

    axilite_api_sequence#(.ADDR_WIDTH(10),.DATA_WIDTH(32)) m_seq = null;
    eg_axilite_slave_seq s_seq = null;
    
    function new(string name, uvml_env env);
        super.new(name, env);        
    endfunction

    task run_phase();
        logic [1:0] resp;
        logic [31:0] data;
        
        uvml_stream_packet snd;
        uvml_stream_packet rcv;
        
        assert (m_seq != null) else `uvml_fatal("master_seq is null");
        assert (s_seq != null) else `uvml_fatal("slave_seq is null");
        
        
        fork
            m_seq.write_resp(10'h5, 32'h123, resp);
            s_seq.respond();
        join
        assert (resp == 2'b0) begin
            `uvml_info($sformatf("WR RSP: %0h", resp));
        end
        else begin
            `uvml_fatal($sformatf("WR RSP: %0h", resp));
        end

        fork
            m_seq.read_resp(10'h7, data, resp);
            s_seq.respond();
        join
        assert (data == 7 * 3 + 2) begin
            `uvml_info($sformatf("RD DARA: %0h RSP: %0h", data, resp));
        end
        else begin
            `uvml_fatal($sformatf("RD DARA: %0h RSP: %0h", data, resp));
        end
        
        
        
        s_seq.start_bg();
        m_seq.write(10'h23, 32'habcd, 4'h3);
        m_seq.read(10'h33, data);
        
        
    endtask : run_phase
    
    
endclass : eg_axilite_test

