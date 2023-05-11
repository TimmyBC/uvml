class eg_axilite_slave_seq extends axilite_api_sequence#(.ADDR_WIDTH(10), .DATA_WIDTH(32));

    function new(string name, uvml_sequencer sequencer);
        super.new(name, sequencer);        
    endfunction

    virtual task on_write_request(logic [ADDR_WIDTH-1:0] addr, logic [DATA_WIDTH-1:0] data, output [1:0] resp);
        //example resp error generation
        resp = (addr == data) ? 2'h2 : 2'h0;
        `uvml_info($sformatf("on write request, addr %h, data %h, set resp %h", addr, data, resp));
    endtask
    
    virtual task on_read_request(logic [ADDR_WIDTH-1:0] addr, output logic [DATA_WIDTH-1:0] data, output [1:0] resp);
        //example data resp error generation
        data = addr * 3 + 2;
        resp = (addr % 5 == 0) ? 2'h1 : 2'h0;
        `uvml_info($sformatf("on read request, addr %h, set data %h, resp %h", addr, data, resp));
    endtask
    
endclass : eg_axilite_slave_seq
