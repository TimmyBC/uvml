class axilite_driver#(type T_VIF, parameter ADDR_WIDTH, parameter DATA_WIDTH) extends uvml_driver;
    
    axilite_awaddr_if_api#(T_VIF, ADDR_WIDTH) vif_api;
    uvml_agent_type agent_type; 
    uvml_sequencer awaddr_sequencer;
    uvml_sequencer wdata_sequencer;
    uvml_sequencer bresp_sequencer;
    uvml_sequencer araddr_sequencer;
    uvml_sequencer rdata_sequencer;
    
    int count = 0;
    
    function new(string name, uvml_component parent);
        super.new(name, parent);
    endfunction

    virtual task run_phase();
        case (agent_type)
            MASTER_AGENT : begin 
                master_run_phase();
            end
            SLAVE_AGENT : begin 
                slave_run_phase();
            end
        endcase
    endtask
    
    task master_run_phase();
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr;
        uvml_hs_beat#(ADDR_WIDTH) addr_beat;
        uvml_hs_beat#(DATA_WIDTH + (DATA_WIDTH/8)) wr_data_beat;
        uvml_hs_beat#(AXIL_RESP_WIDTH) resp_beat;
        uvml_hs_beat#(DATA_WIDTH+AXIL_RESP_WIDTH) data_resp_beat;
        uvml_sequence_item req;
        uvml_sequence_item rsp;
        
        vif_api.wait_reset();
        
        forever begin
            bit last;
            sequencer.get_next_item(req);
            assert($cast(tr, req));
            
            if (tr.op == AXILITE_WRITE) begin
                addr_beat = new($sformatf("awaddr%0d", count), this);
                addr_beat.data = tr.addr;
                awaddr_sequencer.send(addr_beat);
                
                wr_data_beat = new($sformatf("wdata%0d", count), this);
                wr_data_beat.data = {tr.strb, tr.data};
                wdata_sequencer.send(wr_data_beat);
                
                resp_beat = new($sformatf("bresp%0d", count), this);
                rsp = resp_beat;
                bresp_sequencer.receive(rsp, 1000);
                assert($cast(resp_beat, rsp));
                tr.resp = resp_beat.data;
                
                sequencer.put_response(tr);
            end
            else begin
                addr_beat = new($sformatf("araddr%0d", count), this);
                addr_beat.data = tr.addr;
                araddr_sequencer.send(addr_beat);
                                
                data_resp_beat = new($sformatf("rdata%0d", count), this);
                rsp = data_resp_beat;
                rdata_sequencer.receive(rsp, 500);
                assert($cast(data_resp_beat, rsp));
                {tr.resp, tr.data} = data_resp_beat.data;
                tr.strb = '1;
                
                sequencer.put_response(tr);
            end
            count++;
        end
    endtask
    
    task slave_run_phase();
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr;
        uvml_hs_beat#(ADDR_WIDTH) addr_beat;
        uvml_hs_beat#(DATA_WIDTH + (DATA_WIDTH/8)) data_beat;
        uvml_hs_beat#(AXIL_RESP_WIDTH) resp_beat;
        uvml_hs_beat#(DATA_WIDTH+AXIL_RESP_WIDTH) data_resp_beat;
        uvml_sequence_item req;
        uvml_sequence_item rsp;
        int loop;       
        
        vif_api.wait_reset();
        
        slave_awaddr_send();
        slave_araddr_send();
        
        forever begin
            sequencer.get_next_item(req);
            assert($cast(tr, req));   
            
            do begin
                if (slave_awaddr_try_rcv(addr_beat)) begin
                    tr.op = AXILITE_WRITE;
                    tr.addr = addr_beat.data;
                    
                    data_beat = new($sformatf("wdata%0d", count), this);
                    rsp = data_beat;
                    wdata_sequencer.receive(rsp, 1000);
                    assert($cast(data_beat, rsp));
                    {tr.strb, tr.data} = data_beat.data;
                    
                    sequencer.put_response(tr);
                    sequencer.get_next_item(req);
                    assert($cast(tr, req));  
                    
                    resp_beat = new($sformatf("bresp%0d", count), this);
                    resp_beat.data = tr.resp;
                    bresp_sequencer.send(resp_beat);
                    
                    count++;                
                    slave_awaddr_send();
                    loop = 0;
                end
                else if (slave_araddr_try_rcv(addr_beat)) begin
                    tr.op = AXILITE_READ;
                    tr.addr = addr_beat.data;
                                    
                    sequencer.put_response(tr);
                    sequencer.get_next_item(req);
                    assert($cast(tr, req));  
                    
                    data_resp_beat = new($sformatf("rdata%0d", count), this);
                    data_resp_beat.data = {tr.resp, tr.data};
                    rdata_sequencer.send(data_resp_beat);
                                                        
                    count++;
                    slave_araddr_send();
                    loop = 0;
                end
                else begin
                    loop = 1;
                    vif_api.wait_clock();
                end
            end
            while(loop);
        end
    endtask
    
    task slave_awaddr_send();
        uvml_hs_beat#(ADDR_WIDTH) addr_beat = new($sformatf("awaddr%0dor%0d", count, count+1), this);
        awaddr_sequencer.send(addr_beat, 1);
    endtask
    
    task slave_araddr_send();
        uvml_hs_beat#(ADDR_WIDTH) addr_beat = new($sformatf("araddr%0dor%0d", count, count+1), this);
        araddr_sequencer.send(addr_beat, 1);
    endtask
    
    function int slave_awaddr_try_rcv(ref uvml_hs_beat#(ADDR_WIDTH) addr_beat);
        int r;
        uvml_sequence_item rsp;
        r = awaddr_sequencer.try_receive(rsp);
        if (r)
            assert($cast(addr_beat, rsp));
        return r;
    endfunction
    
    function int slave_araddr_try_rcv(ref uvml_hs_beat#(ADDR_WIDTH) addr_beat);
        int r;
        uvml_sequence_item rsp;
        r = araddr_sequencer.try_receive(rsp);
        if (r)
            assert($cast(addr_beat, rsp));      
        return r;
    endfunction
    
endclass : axilite_driver

