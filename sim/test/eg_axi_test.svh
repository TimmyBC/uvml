class eg_axi_test extends uvml_test;

    axi_api_sequence#(.ADDR_WIDTH(10),.DATA_WIDTH(32), .USER_WIDTH(1), 
        .T_W_SEQ_ITEM(axi_data_array_seq_item#(axi_w_seq_item#(1), 1)), 
        .T_R_SEQ_ITEM(axi_data_array_seq_item#(axi_r_seq_item#(1), 1))) m_seq = null;
    
    axi_api_sequence#(.ADDR_WIDTH(10),.DATA_WIDTH(32), .USER_WIDTH(1), 
        .T_W_SEQ_ITEM(axi_data_array_seq_item#(axi_w_seq_item#(1), 1)), 
        .T_R_SEQ_ITEM(axi_data_array_seq_item#(axi_r_seq_item#(1), 1))) s_seq = null;
    
    function new(string name, uvml_env env);
        super.new(name, env);        
    endfunction

    task run_phase();
        axi_data_array_seq_item#(axi_w_seq_item#(1), 1) m_wdata, s_wdata;
        axi_data_array_seq_item#(axi_r_seq_item#(1), 1) m_rdata, s_rdata;
        logic [10-1:0] saddr; 
        logic [AXI_LEN_WIDTH-1:0] slen;
        logic [AXI_RESP_WIDTH-1:0] mresp;
        logic [AXI_RESP_WIDTH-1:0] muser;
        
        m_wdata = new("test_w_data", this);
        m_wdata.data = new[20];
        foreach (m_wdata.data[i])
            m_wdata.data[i] = i + 1;
       
        assert (m_seq != null) else `uvml_fatal("master_seq is null");
        assert (s_seq != null) else `uvml_fatal("slave_seq is null");
        
        fork
            m_seq.m_write(123, 20, m_wdata, mresp, muser, 500, "mtest");
            s_seq.s_write(saddr, slen, s_wdata, RESP_SLVERR, 1'b1, 500, "stest");
        join
        `uvml_info($sformatf("write rcv addr %0d, len %0d, resp %0d, user %0d", saddr, slen, mresp, muser));        
        s_wdata.print(logger);
        
        s_rdata = new("test_r_data", this);
        s_rdata.data = new[20];
        foreach (s_rdata.data[i])
            s_rdata.data[i] = i * 2;
        
        fork
            m_seq.m_read(123, 20, m_rdata, 500, "mtest");
            s_seq.s_read(saddr, slen, s_rdata,  500, "stest");
        join
        `uvml_info($sformatf("read rcv addr %0d, len %0d", saddr, slen));        
        m_rdata.print(logger);
        
    endtask : run_phase
    
    
endclass : eg_axi_test


