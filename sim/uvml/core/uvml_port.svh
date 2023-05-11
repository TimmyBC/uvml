class uvml_export extends uvml_object;

    int write_count = 0;
    int read_count = 0;;
    
    local mailbox#(uvml_sequence_item) q;
    
    function new();
        super.new();
        q = new();
    endfunction

    //It is expected that the unbounded queue will not block more than a clock cycle.
    //If it is practical, it may lead to drop sequence items from moniter. If so this must reimplemented by a different manner.
    task write(uvml_sequence_item itm);
        q.put(itm);
        write_count++;
    endtask
    
    task get(ref uvml_sequence_item it);
        q.get(it);
        read_count++;
//        assert(it != null);
    endtask
    
    function int get_queue_size();
        return q.num();
    endfunction
    
    function int try_get(ref uvml_sequence_item it);
        if (q.try_get(it)) begin
            read_count++;
            return 1;
        end
            return 0;
    endfunction
    
endclass : uvml_export



class uvml_port extends uvml_object;

    local uvml_export xpq[$];
    
    function new();
        super.new();
    endfunction

    function void connect(uvml_export xp);
        xpq.push_back(xp);
    endfunction

    task write(uvml_sequence_item itm);
        foreach(xpq[i]) begin            
            xpq[i].write(itm);
        end
    endtask
    
endclass : uvml_port

//
//virtual class uvml_scoreboard#(type T_SEQ_ITEM = uvml_sequence_item) extends uvml_component;
//
//    function new(string name);
//        super.new(name);
//        
//    endfunction
//
//    pure virtual function uvml_export#(T_SEQ_ITEM) get_export();
//    
//endclass : uvml_scoreboard
