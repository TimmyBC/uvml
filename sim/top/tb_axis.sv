module tb_axis;
    `include "uvml_macros.svh";
    import uvml_pkg::*;
    import axis_pkg::*;
    import eg_test_pkg::*;
    
    logic clk;
    logic rst;

    `uvml_clock_reset(4, clk, rst)
    
    localparam DATA_WIDTH = 32;
    localparam USER_WIDTH = 2;

    axis_if #(
        .DATA_WIDTH(DATA_WIDTH),
        .USER_WIDTH(USER_WIDTH)
    )
    m_axis_if (
        .clk(clk),
        .rst(rst)
    );
    

    axis_if #(
        .DATA_WIDTH(DATA_WIDTH),
        .USER_WIDTH(USER_WIDTH)
    )
    s_axis_if (
        .clk(clk),
        .rst(rst)
    );

    //DUT
    
    reg_axis u_reg_axis (
        .clk   (clk),
        .rst   (rst),
        .s_axis(m_axis_if),
        .m_axis(s_axis_if)
    );
//    assign s_axis_if.data = m_axis_if.data;
//    assign s_axis_if.keep = m_axis_if.keep;
//    assign s_axis_if.last = m_axis_if.last;
//    assign s_axis_if.user = m_axis_if.user;
//    assign s_axis_if.valid = m_axis_if.valid;
//    assign m_axis_if.ready = s_axis_if.ready;

    typedef axis_agent#(.T_VIF(virtual axis_if#(
                                .DATA_WIDTH(DATA_WIDTH), 
                                .USER_WIDTH(USER_WIDTH))), 
                        .T_SEQ_ITEM(eg_axis_seq_item), 
                        .DATA_WIDTH(DATA_WIDTH), 
                        .USER_WIDTH(USER_WIDTH)) t_axis_agent;
    
    initial begin
        uvml_env env;
        eg_axis_test test;
        uvml_checker#(eg_axis_seq_item) chk;
        t_axis_agent master_agent;
        t_axis_agent slave_agent;
        
        env = new("env");
        master_agent = new(env, "master_agent", m_axis_if, MASTER_AGENT, axis_drive_random#(DATA_WIDTH, USER_WIDTH)::create(), COLOR_CYAN);
        slave_agent = new(env, "slave_agent", s_axis_if, SLAVE_AUTO_AGENT, axis_drive_random#(DATA_WIDTH, USER_WIDTH)::create(), COLOR_MAGENTA);
        
        chk = new("checker", env, 1);        
        chk.finish_on_mismatch = 0;
        env.add_component(chk);
        
        env.get_monitor_port("master_agent").connect(chk.ex_port_predict);
        env.get_monitor_port("slave_agent").connect(chk.ex_port_actual);
        
        test = new("stream_test", env);
        test.snd_seq = new("stream_snd_api_seq", env.get_sequencer("master_agent"));
        test.rcv_seq = new("stream_rcv_api_seq", env.get_sequencer("slave_agent"));
        test.run();
        
        uvml_test::finish();
    end
endmodule
