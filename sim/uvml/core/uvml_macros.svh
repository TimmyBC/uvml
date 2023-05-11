/*
`define uvml_info(logger, text)\
    if (logger.log_level <= LOG_INFO_LOW) begin\
        $display({"[", logger.tag, "] ", text});\
        logger.count_info_low++;\
    end

`define uvml_warning(logger, text)\
    $warning({"[", logger.tag, "] ", text});
    
`define uvml_error(logger, text)\
    $error({"[", logger.tag, "] ", text});
    
`define uvml_fatal(logger, text)\
    $fatal(0, {"[", logger.tag, "] ", text});
    
*/    

/* printing macros works only inside a uvml_object */

`define uvml_info(text)\
    $display($sformatf("@%0t | %s | %s", $time(), logger.tag, text));

`ifdef LOG_COLOR

    `define uvml_warning(text)\
        $warning($sformatf("%c[1;33m@%0t | %s | %s%c[0m", 27, $time(), logger.tag, text, 27));
        
    `define uvml_error(text)\
        $error($sformatf("%c[1;31m@%0t | %s | %s%c[0m", 27, $time(), logger.tag, text, 27));
        
    `define uvml_fatal(text)\
        $fatal(1, $sformatf("%c[1;31m@%0t | %s | %s%c[0m", 27, $time(), logger.tag, text, 27));
    
    `define uvml_info_color(text, color, style)\
        $display($sformatf("%c[%0d;3%0dm@%0t | %s | %s%c[0m", 27, style, color, $time(), logger.tag, text, 27));

`else
    
    `define uvml_warning(text)\
        $warning($sformatf("@%0t | %s | %s", $time(), logger.tag, text));
        
    `define uvml_error(text)\
        $error($sformatf("@%0t | %s | %s", $time(), logger.tag, text));
        
    `define uvml_fatal(text)\
        $fatal(1, $sformatf("@%0t | %s | %s", $time(), logger.tag, text));
    
    `define uvml_info_color(text, color, style)\
        $display($sformatf("[%s] @%0t | %s | %s", `"color`", $time(), logger.tag, text));

`endif



`define uvml_pack_logic(v)\
    for(int _i=0; _i<$bits(v); _i++) p.pack_bit(v[_i]);
    
`define uvml_unpack_logic(v)\
    for(int _i=0; _i<$bits(v); _i++) v[_i] = p.unpack_bit();
     
`define uvml_pack_array(v)\
    for (int _j=0; _j<v.size(); _j++)\
        for(int _i=0; _i<$bits(v[0]); _i++) p.pack_bit(v[_j][_i]);
    
`define uvml_unpack_array(v)\
    for (int _j=0; _j<v.size(); _j++)\
        for(int _i=0; _i<$bits(v[0]); _i++) v[_j][_i] = p.unpack_bit();


`define uvml_compare_logic(v)\
    (v == _rhs.v)
    
    /*
`define uvml_print_logic(v)\
    log.data = $sformatf("%s\n    %s    %0d'h%z", log.data, `"v`", $bits(v), v);
    */
`define uvml_print_logic(v)\
`ifdef XILINX_SIMULATOR\
    log.data = $sformatf("%s  [ %s  %0d'h %h ]", log.data, `"v`", $bits(v), v);\
`else\
    log.data = $sformatf("%s  [ %s  %0d'h %z ]", log.data, `"v`", $bits(v), v);\
`endif
    
`define uvml_print_enum(v)\
    log.data = $sformatf("%s  [ %s  %s ]", log.data, `"v`", v.name());
    
`define uvml_clock_reset(period, clk, rst)\
    always #(period/2) clk = ~clk;\
    initial begin\
        clk = 0;\
        rst = 1;\
        repeat(8) @(posedge clk);\
        rst = 0;\
    end
    
`define uvml_clock_reset_n(period, clk, rstn)\
    always #(period/2) clk = ~clk;\
    initial begin\
        clk = 0;\
        rstn = 0;\
        repeat(8) @(posedge clk);\
        rstn = 1;\
    end