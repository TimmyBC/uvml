class axilite_seq_item#(parameter ADDR_WIDTH, parameter DATA_WIDTH) extends uvml_hs_seq_item;
    
    axilite_operation           op;
    logic [ADDR_WIDTH-1:0]      addr;
    logic [DATA_WIDTH-1:0]      data;
    logic [(DATA_WIDTH/8)-1:0]  strb;
    logic [1:0]                 resp;
    
    function new(string name);
        super.new(name);        
    endfunction
    
    function void do_print(uvml_logger log);
        `uvml_print_enum(op);
        `uvml_print_logic(addr);
        `uvml_print_logic(data);
        `uvml_print_logic(strb);
        `uvml_print_logic(resp);
    endfunction
    
    function int do_compare(uvml_sequence_item rhs);
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        return `uvml_compare_logic(addr) && `uvml_compare_logic(data) && `uvml_compare_logic(resp);
    endfunction
    
    function void do_copy(uvml_sequence_item rhs);
        axilite_seq_item#(ADDR_WIDTH, DATA_WIDTH) _rhs;
        void'($cast(_rhs, rhs));
        op   = _rhs.op;
        addr = _rhs.addr;
        data = _rhs.data;
        strb = _rhs.strb;
        resp = _rhs.resp;
    endfunction
    
endclass : axilite_seq_item 
