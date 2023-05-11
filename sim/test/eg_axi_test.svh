class eg_axi_test extends uvml_test;

    axi_api_sequence#(.ADDR_WIDTH(10),.DATA_WIDTH(32), .USER_WIDTH(1), .T_SEQ_ITEM(axi_data_array_seq_item#(1))) m_seq = null;
    axi_api_sequence#(.ADDR_WIDTH(10),.DATA_WIDTH(32), .USER_WIDTH(1), .T_SEQ_ITEM(axi_data_array_seq_item#(1))) s_seq = null;
    
    function new(string name, uvml_env env);
        super.new(name, env);        
    endfunction

    task run_phase();
        axi_data_array_seq_item#(1) wdata;
        axi_data_array_seq_item#(1) rdata;
        logic [10-1:0] saddr; 
        logic [AXI_LEN_WIDTH-1:0] slen;
        logic [AXI_RESP_WIDTH-1:0] mresp;
        logic [AXI_RESP_WIDTH-1:0] muser;
        
        wdata = new("test_wr_data", this);
        wdata.data = new[20];
        foreach (wdata.data[i])
            wdata.data[i] = i + 1;
       
        assert (m_seq != null) else `uvml_fatal("master_seq is null");
        assert (s_seq != null) else `uvml_fatal("slave_seq is null");
        
        fork
            m_seq.m_write(123, 20, wdata, mresp, muser, 500, "mtest");
            s_seq.s_write(saddr, slen, rdata, 2'b0, 1'b1, 500, "stest");
        join
        `uvml_info($sformatf("write rcv addr %0d, len %0d", saddr, slen));        
        rdata.print(logger);
        
        fork
            m_seq.m_read(123, 20, rdata, 500, "mtest");
            s_seq.s_read(saddr, slen, wdata,  500, "stest");
        join
        `uvml_info($sformatf("read rcv addr %0d, len %0d", saddr, slen));        
        rdata.print(logger);
        
    endtask : run_phase
    
    
endclass : eg_axi_test


