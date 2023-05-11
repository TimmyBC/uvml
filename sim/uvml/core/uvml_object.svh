class uvml_object;
    int p;
    process pid = null;
    
    uvml_logger logger = new("LOG", LOG_INFO_LOW);
	
	function new();
		
	endfunction

    virtual function string get_full_name();
        return "";
    endfunction
    
//    virtual function void uvml_fatal(string s);
//        $fatal(0, {"@%0t | ", LOG.tag, " | ", s}, $time());
//    endfunction
//    
//    virtual function void uvml_error(string s);
//        $error({"%c[1;31m@%0t | ", LOG.tag, " | ", s, "%c[0m"}, 27, $time(), 27);
//    endfunction
//    
//    virtual function void uvml_warning(string s);
//        $warning({"%c[1;33m@%0t | ", LOG.tag, " | ", s, "%c[0m"}, 27, $time(), 27);
//    endfunction
//    
//    virtual function void uvml_info(string s);
//        $display({"@%0t | ", LOG.tag, " | ", s}, $time());
//    endfunction
//    
//    virtual function void uvml_info_color(string s, uvml_color color, uvml_color_style style);
//        $display({"%c[%0d;3%0dm@%0t | ", LOG.tag, " | ", s, "%c[0m"}, 27, style, color, $time(), 27);
//    endfunction
    
endclass : uvml_object
