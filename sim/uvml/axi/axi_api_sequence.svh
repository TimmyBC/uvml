class axi_api_sequence#(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32, parameter USER_WIDTH = 1, type T_W_SEQ_ITEM = axi_w_seq_item, type T_R_SEQ_ITEM = axi_r_seq_item) extends uvml_sequence;
    
    int count = 0;
    
    uvml_sequencer aw_seqr_h;
    uvml_sequencer w_seqr_h;
    uvml_sequencer b_seqr_h;
    uvml_sequencer ar_seqr_h;
    uvml_sequencer r_seqr_h;
    
    function new(string name, uvml_agent agent);
        super.new({agent.get_name(), ".", name});
        logger.tag = this.name;
        aw_seqr_h = agent.get_sequencer("aw");
        w_seqr_h = agent.get_sequencer("w");
        b_seqr_h = agent.get_sequencer("b");
        ar_seqr_h = agent.get_sequencer("ar");
        r_seqr_h = agent.get_sequencer("r");
    endfunction

    function string get_seq_item_name(string name);
        return {this.name, ".", name};
    endfunction

    //master
    
    task send_write_request(logic [ADDR_WIDTH-1:0] addr, logic [AXI_LEN_WIDTH-1:0] len, string name = "m_wr_req");
        axi_aw_seq_item#(ADDR_WIDTH) req = new(get_seq_item_name(name));
        req.addr = addr;
        req.len = len;
        aw_seqr_h.send(req);
    endtask
    
    task send_write_data(T_W_SEQ_ITEM data);
        w_seqr_h.send(data);
    endtask
    
    task rcv_write_response(output logic [AXI_RESP_WIDTH-1:0] resp, output logic [USER_WIDTH-1:0] user, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "m_wr_rsp");
        uvml_sequence_item _rsp;
        axi_b_seq_item#(USER_WIDTH) rsp = new(get_seq_item_name(name));
        assert($cast(_rsp, rsp));
        b_seqr_h.receive(_rsp, ns);
        resp = rsp.resp;
        user = rsp.user;
    endtask
    
    task send_read_request(logic [ADDR_WIDTH-1:0] addr, logic [AXI_LEN_WIDTH-1:0] len, string name = "m_rd_req");
        axi_aw_seq_item#(ADDR_WIDTH) req = new(get_seq_item_name(name));
        req.addr = addr;
        req.len = len;
        ar_seqr_h.send(req);
    endtask
    
    task rcv_read_data(output T_R_SEQ_ITEM data, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "m_rd_data");
        uvml_sequence_item _rsp;
        data = new(get_seq_item_name(name));
        assert($cast(_rsp, data));
        r_seqr_h.receive(_rsp, ns);
    endtask
    
    task m_read(logic [ADDR_WIDTH-1:0] addr, logic [AXI_LEN_WIDTH-1:0] len, output T_R_SEQ_ITEM data, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "rd");
        send_read_request(addr, len, {name, "_m_rreq"});
        rcv_read_data(data, ns, {name, "_m_rdata"});
    endtask
    
    task m_write(logic [ADDR_WIDTH-1:0] addr, logic [AXI_LEN_WIDTH-1:0] len, T_W_SEQ_ITEM data, output logic [AXI_RESP_WIDTH-1:0] resp, output logic [USER_WIDTH-1:0] user, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "wr");
        send_write_request(addr, len, {name, "_m_wreq"});
        send_write_data(data);
        rcv_write_response(resp, user, ns, {name, "_m_wrsp"});
    endtask
    
    
    
    //slave
    task rcv_write_request(output logic [ADDR_WIDTH-1:0] addr, output logic [AXI_LEN_WIDTH-1:0] len, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "s_wr_req");
        uvml_sequence_item rsp;
        axi_aw_seq_item#(ADDR_WIDTH) req = new(get_seq_item_name(name));
        assert($cast(rsp, req));
        aw_seqr_h.receive(rsp, ns);
        addr = req.addr;
        len = req.len;
    endtask
    
    task rcv_write_data(output T_W_SEQ_ITEM data, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "s_wr_data");
        uvml_sequence_item rsp;
        data = new(get_seq_item_name(name));
        rsp = data;
        w_seqr_h.receive(rsp, ns);
    endtask
    
    task send_write_response(logic [AXI_RESP_WIDTH-1:0] resp, logic [USER_WIDTH-1:0] user, input string name = "s_wr_rsp");       
        axi_b_seq_item#(USER_WIDTH) rsp = new(get_seq_item_name(name));
        rsp.resp = resp;
        rsp.user = user;
        b_seqr_h.send(rsp);
    endtask
    
    task rcv_read_request(output logic [ADDR_WIDTH-1:0] addr, output logic [AXI_LEN_WIDTH-1:0] len, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "s_rd_req");
        uvml_sequence_item rsp;
        axi_ar_seq_item#(ADDR_WIDTH) req = new(get_seq_item_name(name));
        assert($cast(rsp, req));
        ar_seqr_h.receive(rsp, ns);
        addr = req.addr;
        len = req.len;
    endtask
    
    task send_read_data(T_R_SEQ_ITEM data, input string name = "rd_data");
        r_seqr_h.send(data);
    endtask
    
    task s_read(output logic [ADDR_WIDTH-1:0] addr, output logic [AXI_LEN_WIDTH-1:0] len, input T_R_SEQ_ITEM data, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "s_rd");
        rcv_read_request(addr, len, ns, {name, "_s_rreq"});
        send_read_data(data, {name, "_s_rdata"});
    endtask
    
    task s_write(output logic [ADDR_WIDTH-1:0] addr, output logic [AXI_LEN_WIDTH-1:0] len, output T_W_SEQ_ITEM data, input logic [AXI_RESP_WIDTH-1:0] resp, input logic [USER_WIDTH-1:0] user, input int ns = SEQUENCER_WAIT_FOREVER, input string name = "wr");
        rcv_write_request(addr, len, ns, {name, "_s_wreq"});
        rcv_write_data(data, ns, {name, "_s_wdata"});
        send_write_response(resp, user, {name, "_s_wrsp"});
    endtask
    
endclass : axi_api_sequence