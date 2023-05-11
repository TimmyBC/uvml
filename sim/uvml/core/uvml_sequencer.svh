class uvml_sequencer extends uvml_object;
    
    mailbox#(uvml_sequence_item) req_q;
    mailbox#(uvml_sequence_item) rsp_q;
    
    function new();
        super.new();
        req_q = new(1); 
        rsp_q = new(1);
    endfunction

    task send(uvml_sequence_item req, bit expect_response = 0);
        req.expect_response = expect_response;
        req_q.put(req);
    endtask 
        
    task send_receive(uvml_sequence_item req, ref uvml_sequence_item rsp, input int ns = SEQUENCER_WAIT_FOREVER);
        req.expect_response = 1;
        req_q.put(req); 
        
        if (ns >= 0) begin
            int retry = ns;
            do begin
                if (rsp_q.try_get(rsp))
                    return;
                #1ns;
                retry--;
            end
            while(retry > 0);
            `uvml_fatal($sformatf("Receive timed out after %0d ns", ns));
        end
        else begin
            rsp_q.get(rsp);
        end
    endtask 
        
    task send_wait(uvml_sequence_item req, input int ns = SEQUENCER_WAIT_FOREVER);
        send_receive(req, req, ns);
    endtask 
    
    task receive(ref uvml_sequence_item rsp, input int ns = SEQUENCER_WAIT_FOREVER);
        send_receive(rsp, rsp, ns);
    endtask 
    
    function int try_receive(ref uvml_sequence_item rsp);
        return rsp_q.try_get(rsp);
    endfunction
    
    
    
    task get_next_item(ref uvml_sequence_item req);    
        req_q.get(req);
    endtask
    
    function int try_next_item(ref uvml_sequence_item req);
        return req_q.try_get(req);
    endfunction
    
    function int has_items();
        return req_q.num();
    endfunction
    
    task put_response(uvml_sequence_item rsp);
        if (rsp.expect_response)
            rsp_q.put(rsp);    
    endtask
    
    function int try_response(uvml_sequence_item rsp);
        if (rsp.expect_response == 0)
            return 1;
        return rsp_q.try_put(rsp);
    endfunction
    
    
endclass : uvml_sequencer


//class uvml_sequencer#(type T = uvml_sequence_item) extends uvml_object;
//    
//    mailbox#(T) req_q;
//    mailbox#(T) rsp_q;
//    
//    function new();
//        super.new();
//        req_q = new(1); 
//        rsp_q = new(1);
//    endfunction
//
//    task send(T req);
//        req.expect_response = 0;
//        req_q.put(req);
//    endtask 
//    
//    task send_wait(T req);
//        T rsp;
//        req.expect_response = 1;
//        req_q.put(req);
//        rsp_q.get(rsp);
//    endtask 
//    
//    task send_receive(T req, ref T rsp);
//        req.expect_response = 1;
//        req_q.put(req);
//        rsp_q.get(rsp);
//    endtask 
//    
//    task receive(ref T rsp);
//        T req = new();
//        req.expect_response = 1;
//        req_q.put(req);
//        rsp_q.get(rsp);
//    endtask 
//    
//    
//    
//    task get_next_item(T req);
//        req_q.get(req);
//    endtask
//    
//    function int try_next_item(T req);
//        return req_q.try_get(req);
//    endfunction
//    
//    task put_response(T rsp);
//        if (rsp.expect_response)
//            rsp_q.put(rsp);    
//    endtask
//    
//    function int try_response(T rsp);
//        if (rsp.expect_response == 0)
//            return 1;
//        return rsp_q.try_put(rsp);
//    endfunction
//    
//    
//endclass : uvml_sequencer
