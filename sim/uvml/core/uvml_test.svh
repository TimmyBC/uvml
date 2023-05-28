class uvml_test extends uvml_component;

    protected uvml_env env;
    
    uvml_sequence sequences[string];
    
    function new(string name, uvml_env env);
        super.new(name, env);
        this.env = env;
    endfunction

    function void add_sequence(uvml_sequence seq);
        sequences[seq.name] = seq;
    endfunction
        
    task run;        
        fork
            begin
                env.run();
            end
            begin
                pid = process::self();
                `uvml_info_color($sformatf("*** TEST: %s ***", get_name()), COLOR_BLUE, COLOR_BOLD);
                run_phase();
                #300;
            end
        join_any
        
        env.end_run_phase();
        
        fork
            begin
                shutdown_phase();
                #10;
            end
            env.shutdown();
        join_any
    endtask
            
    
    static task finish();
        $finish(0);
    endtask
    
endclass : uvml_test
