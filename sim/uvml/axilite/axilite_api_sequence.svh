class axilite_api_sequence#(parameter ADDR_WIDTH = 32, parameter DATA_WIDTH = 32) extends uvml_api_sequence#(axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH));
    
    int count = 0;
    
    function new(string name, uvml_sequencer sequencer);
        super.new(name, sequencer);
        logger.tag = name;
    endfunction

    //master interface
    
    virtual task write_resp(logic [ADDR_WIDTH-1:0] addr, logic [DATA_WIDTH-1:0] data, output logic [1:0] resp, input logic [(DATA_WIDTH/8-1):0] strb = '1);
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr = new($sformatf("%s.WR%0d", name, count));
        tr.op = AXILITE_WRITE;
        tr.addr = addr;
        tr.data = data;
        tr.strb = strb;
        send_receive(tr, tr);
        resp = tr.resp;
        count++;
    endtask
    
    virtual task read_resp(logic [ADDR_WIDTH-1:0] addr, output logic [DATA_WIDTH-1:0] data, output logic [1:0] resp);
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr = new($sformatf("%s.RD%0d", name, count));
        tr.op = AXILITE_READ;
        tr.addr = addr;
        send_receive(tr, tr);
        data = tr.data;
        resp = tr.resp;
        count++;
    endtask
    
    virtual task write(logic [ADDR_WIDTH-1:0] addr, logic [DATA_WIDTH-1:0] data, input logic [(DATA_WIDTH/8-1):0] strb = '1);
        logic [1:0] resp;
        write_resp(addr, data, resp, strb);
        assert(resp == 2'b0) else `uvml_fatal($sformatf("AXILITE WRITE RESP ERROR! Addr: %0d'h%0h, Data: %0d'h%0h, Resp: 2'h%0h", ADDR_WIDTH, addr, DATA_WIDTH, data, resp))
    endtask
    
    virtual task read(logic [ADDR_WIDTH-1:0] addr, output logic [DATA_WIDTH-1:0] data);
        logic [1:0] resp;
        read_resp(addr, data, resp);
        assert(resp == 2'b0) else `uvml_fatal($sformatf("AXILITE READ RESP ERROR! Addr: %0d'h%0h, Data: %0d'h%0h, Resp: 2'h%0h", ADDR_WIDTH, addr, DATA_WIDTH, data, resp))
    endtask
    
    
    
    //slave interface 
    
    task get_response(output axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr);
        tr = new($sformatf("%s.SLV%0d", name, count));
        send_receive(tr, tr);
        if (tr.op == AXILITE_WRITE) begin
            on_write_request(tr.addr, tr.data, tr.resp);
        end
        else begin
            on_read_request(tr.addr, tr.data, tr.resp);
        end
        send(tr);
        count++;
    endtask;
    
    task respond();
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) tr;
        get_response(tr);
    endtask
    
    task start_bg();
        fork
            forever begin
                respond(); 
            end
        join_none
    endtask
    
    virtual task on_write_request(logic [ADDR_WIDTH-1:0] addr, logic [DATA_WIDTH-1:0] data, output [1:0] resp);
        `uvml_fatal("All slave sequences must implement 'on_write_request'");
    endtask
    
    virtual task on_read_request(logic [ADDR_WIDTH-1:0] addr, output logic [DATA_WIDTH-1:0] data, output [1:0] resp);
        `uvml_fatal("All slave sequences must implement 'on_read_request'");
    endtask
    
endclass : axilite_api_sequence