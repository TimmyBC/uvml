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

//field packing/unpacking macros for sequence items

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

`define uvml_pack_logic_bs(v)\
    for(int _i=$bits(v) - 8; _i>=0; _i-=8) \
        for(int _j=0; _j<8; _j++) \
            p.pack_bit(v[_i + _j]);
    
`define uvml_unpack_logic_bs(v)\
    for(int _i=$bits(v) - 8; _i>=0; _i-=8) \
        for(int _j=0; _j<8; _j++) \
            v[_i + _j] = p.unpack_bit();




`define uvml_user_pack_logic(v, beat_index)\
    for(int _i=0; _i<$bits(v); _i++) p.pack_user_bit(v[_i], beat_index);
    
`define uvml_user_unpack_logic(v, beat_index)\
    for(int _i=0; _i<$bits(v); _i++) v[_i] = p.unpack_user_bit(beat_index);
     
`define uvml_user_pack_array(v, beat_index)\
    for (int _j=0; _j<v.size(); _j++)\
        for(int _i=0; _i<$bits(v[0]); _i++) p.pack_user_bit(v[_j][_i], beat_index);
    
`define uvml_user_unpack_array(v, beat_index)\
    for (int _j=0; _j<v.size(); _j++)\
        for(int _i=0; _i<$bits(v[0]); _i++) v[_j][_i] = p.unpack_user_bit(beat_index);

`define uvml_user_pack_logic_bs(v, beat_index)\
    for(int _i=$bits(v) - 8; _i>=0; _i-=8) \
        for(int _j=0; _j<8; _j++) \
            p.pack_user_bit(v[_i + _j], beat_index);
    
`define uvml_user_unpack_logic_bs(v, beat_index)\
    for(int _i=$bits(v) - 8; _i>=0; _i-=8) \
        for(int _j=0; _j<8; _j++) \
            v[_i + _j] = p.unpack_user_bit(beat_index);
   
   

`define uvml_user_pack_logic_at_last(v)\
    for(int _i=0; _i<$bits(v); _i++) p.pack_user_bit(v[_i], -1);
    
`define uvml_user_unpack_logic_at_last(v)\
    for(int _i=0; _i<$bits(v); _i++) v[_i] = p.unpack_user_bit(-1);
     
`define uvml_user_pack_array_at_last(v)\
    for (int _j=0; _j<v.size(); _j++)\
        for(int _i=0; _i<$bits(v[0]); _i++) p.pack_user_bit(v[_j][_i], -1);
    
`define uvml_user_unpack_array_at_last(v)\
    for (int _j=0; _j<v.size(); _j++)\
        for(int _i=0; _i<$bits(v[0]); _i++) v[_j][_i] = p.unpack_user_bit(-1);



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

// `define uvml_print_array(v)\
//     log.data = (v.size() > 0) ? $sformatf("%s [ %s %0d'h{%0d} %0p ]", log.data, `"v`", $bits(v[0]), v.size(), v) : $sformatf("%s [ %s {} ]", log.data, `"v`");

`define uvml_print_array(v)\
    if (v.size() > 0) begin\
        $swriteh(log.data, "%s [ %s %0d'h{%0d} %0p ]", log.data, `"v`", $bits(v[0]), v.size(), v);\
    end\
    else begin\
        $swriteh(log.data, "%s [ %s {} ]", log.data, `"v`");\
    end

`define uvml_print_enum(v)\
    log.data = $sformatf("%s  [ %s  %s ]", log.data, `"v`", v.name());


`define UVML_DEFAULT    8'b11101111
`define UVML_COPY       8'b00000001
`define UVML_CMP        8'b00000010
`define UVML_PRNT       8'b00000100
`define UVML_PACK       8'b00001000
`define UVML_FILL       8'b00010000
`define UVML_NO_COPY    8'b11111110
`define UVML_NO_CMP     8'b11111101
`define UVML_NO_PRNT    8'b11111011
`define UVML_NO_PACK    8'b11110111
    
    
`define uvml_object_utils_begin(cls)\
    function int field_ops(uvml_seq_itm_ops op, uvml_sequence_item _rhs, uvml_packer p, uvml_logger log);\
        int cmp; \
        cls rhs; \
        $cast(rhs, _rhs); \
        cmp = super.field_ops(op, _rhs, p, log);

`define uvml_field_logic(f, flg) \
        case (op) \
            SEQ_ITM_COPY : begin  \
                if (flg & `UVML_COPY) f = rhs.f; \
            end \
            SEQ_ITM_CMP : begin \
                if (flg & `UVML_CMP) cmp &= (f === rhs.f) ? 1 : 0; \
            end \
            SEQ_ITM_PRNT: begin \
                if (flg & `UVML_PRNT) `uvml_print_logic(f) \
            end \
            SEQ_ITM_PACK: begin \
                if (flg & `UVML_PACK) `uvml_pack_logic(f); \
            end \
            SEQ_ITM_UNPK: begin \
                if (flg & `UVML_PACK) `uvml_unpack_logic(f); \
            end \
        endcase

`define uvml_field_logic_bs(f, flg) \
        case (op) \
            SEQ_ITM_COPY : begin  \
                if (flg & `UVML_COPY) f = rhs.f; \
            end \
            SEQ_ITM_CMP : begin \
                if (flg & `UVML_CMP) cmp &= (f === rhs.f) ? 1 : 0; \
            end \
            SEQ_ITM_PRNT: begin \
                if (flg & `UVML_PRNT) `uvml_print_logic(f) \
            end \
            SEQ_ITM_PACK: begin \
                if (flg & `UVML_PACK) `uvml_pack_logic_bs(f); \
            end \
            SEQ_ITM_UNPK: begin \
                if (flg & `UVML_PACK) `uvml_unpack_logic_bs(f); \
            end \
        endcase
        
`define uvml_field_array(f, flg) \
        case (op) \
            SEQ_ITM_COPY : begin  \
                if (flg & `UVML_COPY) f = new[rhs.f.size()](rhs.f); \
            end \
            SEQ_ITM_CMP : begin \
                if (flg & `UVML_CMP) cmp &= (rhs.f === f) ? 1 : 0; \
            end \
            SEQ_ITM_PRNT: begin \
                if (flg & `UVML_PRNT) `uvml_print_array(f) \
            end \
            SEQ_ITM_PACK: begin \
                if (flg & `UVML_PACK) `uvml_pack_array(f); \
            end \
            SEQ_ITM_UNPK: begin \
                if (flg & `UVML_PACK) begin \
                    if (flg & `UVML_FILL) f = new[p.get_unpackable_size()/8]; \
                    `uvml_unpack_array(f); \
                end \
            end \
        endcase
        
`define uvml_object_utils_end \
        return cmp; \
    endfunction
    
    
//clock reset generators for test back top

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
