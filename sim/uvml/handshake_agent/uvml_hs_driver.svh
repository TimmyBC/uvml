class uvml_hs_driver#(type T_SEQ_ITEM, parameter DATA_WIDTH = 64) extends uvml_driver;
    
    typedef enum {ST_WAIT_VALID, ST_VALID_READY, ST_WAIT_READY} hs_driver_state;
        
    uvml_hs_if_api_base#(DATA_WIDTH) vif_api;
    uvml_agent_type agent_type;
    uvml_hs_drive_pattern#(DATA_WIDTH) drive;
    
    uvml_hs_packer#(DATA_WIDTH) packer;
    
	function new(string name, uvml_component parent);
		super.new(name, parent);
		packer = new("packer", this);
	endfunction

    
    virtual task run_phase();
        case (agent_type)
            MASTER_AGENT : begin 
                master_run_phase();
            end
            SLAVE_AGENT : begin 
                slave_run_phase(0);
            end
            SLAVE_AUTO_AGENT : begin 
                slave_auto_run_phase();
            end
        endcase
    endtask : run_phase

    
        
    task master_run_phase();
        uvml_sequence_item req;
        int retry;
        logic [0:0] valid;
        logic [0:0] ready;
        logic [DATA_WIDTH-1:0] buffer;
        hs_driver_state state;
        
        state = ST_WAIT_VALID;
        
        vif_api.wait_reset();
        vif_api.set_valid(1'b0);
        
        forever begin
            vif_api.wait_clock();
            
            ready = vif_api.get_ready();
            
            case(state)
                ST_VALID_READY: begin                    
                    if (drive.get_next_value(ready) & sequencer.has_items()) begin   
                        assert (sequencer.try_next_item(req));
                        packer.reset();
                        req.do_pack(packer);  

                        vif_api.set_valid(1'b1); 
                        if (ready === 1'b1) begin                      
                            vif_api.set_data(packer.get_data());
                        end
                        else begin 
                            //previously set data is valid
                            state = ST_WAIT_READY;
                        end
                    end
                    else if (ready === 1'b1) begin
                        vif_api.set_data('x);
                        vif_api.set_valid(1'b0);      
                        state = ST_WAIT_VALID;
                    end
                end
                ST_WAIT_VALID: begin
                    if (drive.get_next_value(ready) & sequencer.has_items()) begin   
                        assert (sequencer.try_next_item(req));
                        packer.reset();
                        req.do_pack(packer);     
                        
                        vif_api.set_data(packer.get_data());
                        vif_api.set_valid(1'b1);
                        state = ST_VALID_READY;
                    end
                end
                ST_WAIT_READY: begin
                    if (ready === 1'b1) begin
                        vif_api.set_data(packer.get_data());
                        vif_api.set_valid(1'b1);  
                        state = ST_VALID_READY;
                    end
                end
            endcase           
        end
    endtask



    task slave_auto_run_phase();
        logic [0:0] ready;        
        
        vif_api.wait_reset();
        vif_api.set_ready(1'b0);
        
        forever begin
            vif_api.wait_clock();
        
            ready = drive.get_next_value(vif_api.get_valid());
            vif_api.set_ready(ready);    
        end
    endtask



    task slave_run_phase(int auto);
        uvml_sequence_item req;
        T_SEQ_ITEM rsp;
        int retry;
        logic [0:0] valid;    
        logic [0:0] ready;    
        logic [0:0] valid_reg;        
        hs_driver_state state = ST_WAIT_VALID;
        
        valid = '0;
        ready = '0;
        vif_api.wait_reset();
        vif_api.set_ready(1'b0);
        
        forever begin
            
            vif_api.wait_clock();
//            valid_reg = valid;
            
            valid = vif_api.get_valid();
            
            
            
            
            if (valid & ready) begin
                assert (sequencer.try_next_item(req));
                assert ($cast(rsp, req));
                packer.set_data(vif_api.get_data());
                rsp.do_unpack(packer);
                sequencer.put_response(rsp);                
            end
            
            
            ready = drive.get_next_value(valid) & sequencer.has_items();
            vif_api.set_ready(ready);
                
//            case (state)
//                ST_VALID_READY : begin
//                    if (valid) begin
//                        if (ready) begin
//                            assert (sequencer.try_next_item(req));
//                            assert ($cast(rsp, req));
//                            packer.set_data(vif_api.get_data());
//                            rsp.do_unpack(packer);
//                            sequencer.put_response(rsp);
//                            
//                            vif_api.set_ready(1'b1);
//                        end
//                        else begin
//                            assert (sequencer.try_next_item(req));
//                            assert ($cast(rsp, req));
//                            packer.set_data(vif_api.get_data());
//                            rsp.do_unpack(packer);
//                            sequencer.put_response(rsp);
//                            vif_api.set_ready(1'b1);
//                            vif_api.set_ready(1'b0);
//                            state = ST_WAIT_READY;
//                        end
//                    end
//                    else begin
//                        if (ready) begin
//                            vif_api.set_ready(1'b1);
//                            state = ST_WAIT_VALID;
//                        end
//                    end
//                end
//                ST_WAIT_VALID  :begin
//                    vif_api.set_ready(1'b1);
//                    if (valid) begin
//                        assert (sequencer.try_next_item(req));
//                        assert ($cast(rsp, req));
//                        packer.set_data(vif_api.get_data());
//                        rsp.do_unpack(packer);
//                        sequencer.put_response(rsp);
//                        state  = ST_VALID_READY;
//                    end
//                end
//                ST_WAIT_READY : begin
//                    if (ready) begin
//                        assert (sequencer.try_next_item(req));
//                        assert ($cast(rsp, req));
//                        packer.set_data(vif_api.get_data());
//                        rsp.do_unpack(packer);
//                        sequencer.put_response(rsp);
//                        vif_api.set_ready(1'b1);
//                        state  = ST_VALID_READY; 
//                    end
//                end
//            endcase
            
        end
        
    endtask    
        
    
endclass : uvml_hs_driver
