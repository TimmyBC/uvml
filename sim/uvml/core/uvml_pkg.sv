package uvml_pkg;
    
    typedef enum {MASTER_AGENT, SLAVE_AGENT, SLAVE_AUTO_AGENT, PASSIVE_AGENT} uvml_agent_type;
    typedef enum {COLOR_BLACK, COLOR_RED, COLOR_GREEN, COLOR_YELLOW, COLOR_BLUE, COLOR_MAGENTA, COLOR_CYAN, COLOR_WHITE, LOG_DISABLE, LOG_DEFAULT} uvml_color;
    typedef enum {COLOR_BOLD = 1, COLOR_FAINT = 2, COLOR_BLINK = 5} uvml_color_style;
    typedef enum {MONITOR_ENABLE, MONITOR_DISABLE} uvml_monitor_enable;
    
    localparam SEQUENCER_WAIT_FOREVER = -1;
    
    `include "uvml_macros.svh"
    `include "uvml_logger.svh"
	`include "uvml_object.svh"
    `include "uvml_packer.svh"
    `include "uvml_sequence_item.svh"
    `include "uvml_sequencer.svh"
    `include "uvml_sequence.svh"
    
	`include "uvml_component.svh"
    `include "uvml_port.svh"
	`include "uvml_monitor.svh"
	`include "uvml_driver.svh"
	`include "uvml_agent.svh"
    `include "uvml_checker.svh"
	`include "uvml_env.svh"
    `include "uvml_test.svh"
endpackage
