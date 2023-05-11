class uvml_component extends uvml_object;

    local string name;
    local string full_name = "";
//    uvml_logger logger;
    
	function new(string name, uvml_component parent);
		super.new();
		this.name = name;
        this.full_name = (parent == null) ? name : {parent.get_full_name(), ".", name};
        logger.tag = this.full_name;
	endfunction

    virtual function string get_name();
        return name;
    endfunction
    
    function string get_full_name();
        return full_name;
    endfunction
    
    function uvml_logger get_logger();
        return logger;
    endfunction
    
    virtual task run();
        pid = process::self();
        run_phase();
    endtask
    
    virtual task run_phase();
    
    endtask  

    virtual task end_run_phase();
        pid.kill(); 
    endtask
    
    task shutdown();
        pid = process::self();
        shutdown_phase();
    endtask
    
    virtual task shutdown_phase();
        
    endtask

//    virtual function void uvml_fatal(string s);
//        $fatal(0, {"%c[1;31m@%0t | ", logger.tag, " | ", s, "%c[0m"}, 27, $time(), 27);
//    endfunction
//    
//    virtual function void uvml_error(string s);
//        $error({"%c[1;31m@%0t | ", logger.tag, " | ", s, "%c[0m"}, 27, $time(), 27);
//    endfunction
//    
//    virtual function void uvml_warning(string s);
//        $warning({"%c[1;33m@%0t | ", logger.tag, " | ", s, "%c[0m"}, 27, $time(), 27);
//    endfunction
//    
//    virtual function void uvml_info(string s);
//        $display({"@%0t | ", logger.tag, " | ", s}, $time());
//    endfunction
//    
//    virtual function void uvml_info_color(string s, uvml_color color, uvml_color_style style);
//        $display({"%c[%0d;3%0dm@%0t | ", logger.tag, " | ", s, "%c[0m"}, 27, style, color, $time(), 27);
//    endfunction
    
//    virtual task run_phase();
//        reset_phase();
//        configure_phase();
//        main_phase();
//        shutdown_phase();
//    endtask  
//    
//    virtual task reset_phase();
//    endtask    
//    
//    virtual task configure_phase();
//    endtask
//    
//    virtual task main_phase();
//    endtask
//    
//    virtual task shutdown_phase();
//    endtask
    
endclass : uvml_component 

