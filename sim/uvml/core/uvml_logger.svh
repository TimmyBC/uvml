typedef enum {LOG_INFO_LOW, LOG_INFO_HIGH, LOG_WARN, LOG_ERR, LOG_NONE} LOG_LEVEL_ENUM;
    
class uvml_logger;
    string data = "";
    string tag;
    LOG_LEVEL_ENUM log_level;
    uvml_color print_color;
    
    int count_info_low = 0;
    int count_info_high = 0;
    int count_warn = 0;
    int count_err = 0;
    
    function new(string tag, LOG_LEVEL_ENUM default_log_level = LOG_INFO_LOW);
        this.tag = tag;
        this.log_level = default_log_level;
        this.print_color = LOG_DEFAULT;
    endfunction

    virtual function void uvml_print();
        if (print_color != LOG_DISABLE) begin            
            if (print_color == LOG_DEFAULT) begin
                $display("@%0t | %s | %s", $time(), tag, data);
            end
            else begin
                `ifdef LOG_COLOR
                    $display("%c[1;3%0dm@%0t | %s | %s%c[0m", 27, print_color, $time(), tag, data, 27);
                `else 
                    $display("[%s] @%0t | %s | %s", print_color.name(), $time(), tag, data);
                `endif
            end            
        end
    endfunction

endclass : uvml_logger
