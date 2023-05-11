class uvml_checker#(type T_SEQ_ITEM) extends uvml_component;

    uvml_export ex_port_predict;
    uvml_export ex_port_actual;
    int finish_on_mismatch = 0;
    int match_count = 0;
    int mismatch_count = 0;
    int pass = 0;
    
    function new(string name, uvml_component parent, int finish_on_mismatch = 0);
        super.new(name, parent);
        ex_port_predict = new();
        ex_port_actual = new();
        this.finish_on_mismatch = finish_on_mismatch;
    endfunction

    virtual task run_phase();
        uvml_sequence_item pred = new("predicted");
        uvml_sequence_item actual = new("actual");
        forever begin
            fork
                ex_port_actual.get(actual);
                ex_port_predict.get(pred);
            join
            
            assert (pred.do_compare(actual))begin
                match_count++;
            end
            else begin
                mismatch_count++;
                if (finish_on_mismatch) begin
                    `uvml_fatal("Sequece Item Mismatch");
                end
                else begin
                    `uvml_error("Sequece Item Mismatch");
                end
            end
        end
    endtask : run_phase
    
    virtual task shutdown_phase();
        if (mismatch_count != 0) begin
            `uvml_error($sformatf("*** FAILED - MISMATCH !!! *** [ Match Count: %0d, Mismatch Count: %0d ]", match_count, mismatch_count));
            if (ex_port_predict.get_queue_size() != 0 || ex_port_actual.get_queue_size() != 0) begin
                `uvml_error($sformatf("*** FAILED - NOT ALL SEQUECE ITEAMS RECEIVED !!! *** [ Remaining predicted: %0d, Remaining actual: %0d ]", ex_port_predict.get_queue_size(), ex_port_actual.get_queue_size()));
            end
        end
        else if (ex_port_predict.get_queue_size() != 0 || ex_port_actual.get_queue_size() != 0) begin
            `uvml_info($sformatf("*** ALL MATCHED *** [ Match Count: %0d, Mismatch Count: %0d ]", match_count, mismatch_count));
            `uvml_info($sformatf("*** FAILED - NOT ALL SEQUECE ITEAMS RECEIVED !!! *** [ Remaining predicted: %0d, Remaining actual: %0d ]", ex_port_predict.get_queue_size(), ex_port_actual.get_queue_size()));
        end
        else begin
            `uvml_info_color($sformatf("*** PASS !!! *** [ Count: %0d ]", match_count), COLOR_GREEN, COLOR_BOLD);
            pass = 1;
        end 
    endtask : shutdown_phase
    
endclass : uvml_checker
    