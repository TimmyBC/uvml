class axilite_monitor#(type T_VIF, parameter ADDR_WIDTH, parameter DATA_WIDTH) extends uvml_monitor;

    axilite_awaddr_if_api#(T_VIF, ADDR_WIDTH) vif_api;
    uvml_port port;
    uvml_export awaddr_port;
    uvml_export wdata_port;
    uvml_export bresp_port;
    uvml_export araddr_port;
    uvml_export rdata_port;
    
    local int count = 0;
    
    function new(string name, uvml_component parent, uvml_color log_color = LOG_DEFAULT);
        super.new(name, parent);
        port = new();
        awaddr_port = new();
        wdata_port = new();
        bresp_port = new();
        araddr_port = new();
        rdata_port = new();
        logger.print_color = log_color;
    endfunction

    virtual task run_phase();
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr;
        uvml_hs_beat#(ADDR_WIDTH) addr_beat;
        uvml_hs_beat#(DATA_WIDTH + (DATA_WIDTH/8)) data_beat;
        uvml_hs_beat#(2) resp_beat;
        uvml_hs_beat#(DATA_WIDTH+AXIL_RESP_WIDTH) data_resp_beat;
        uvml_sequence_item addr;
        uvml_sequence_item data;
        uvml_sequence_item rsp;
        
        forever begin
            #0;
            if (awaddr_port.try_get(addr)) begin
                tr = new($sformatf("axilite%0d", count++));
                assert($cast(addr_beat, addr));
                tr.addr = addr_beat.data;
                
                wdata_port.get(data);
                assert($cast(data_beat, data));
                {tr.strb, tr.data} = data_beat.data;
                
                bresp_port.get(rsp);
                assert($cast(resp_beat, rsp));
                tr.resp = resp_beat.data;
                
                tr.op = AXILITE_WRITE;
                tr.print(logger);
                port.write(tr);
            end
            else if (araddr_port.try_get(addr)) begin
                tr = new($sformatf("axilite%0d", count++));
                assert($cast(addr_beat, addr));
                tr.addr = addr_beat.data;
                
                rdata_port.get(data);
                assert($cast(data_resp_beat, data));
                {tr.resp, tr.data} = data_resp_beat.data;
                tr.strb = '1;
                
                tr.op = AXILITE_READ;
                tr.print(logger);
                port.write(tr);
            end
            else begin
                vif_api.wait_clock();
            end
        end
    endtask
    

endclass : axilite_monitor

