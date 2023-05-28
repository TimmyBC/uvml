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

    typedef axis_agent#(eg_axis_seq_item,DATA_WIDTH,USER_WIDTH) t_axis_agent;    
    typedef axis_if_api#(virtual axis_if#(DATA_WIDTH, USER_WIDTH), DATA_WIDTH, USER_WIDTH) t_axis_if_api;
    
    initial begin
        uvml_env env;
        eg_axis_test test;
        uvml_checker#(eg_axis_seq_item) chk;
        t_axis_agent master_agent;
        t_axis_agent slave_agent;        
        t_axis_if_api m_axis_if_api;
        t_axis_if_api s_axis_if_api;
        
        m_axis_if_api = new(m_axis_if);
        s_axis_if_api = new(s_axis_if);
        
        env = new("env");
        master_agent = new(env, "master_agent", m_axis_if_api, MASTER_AGENT, axis_drive_random#(DATA_WIDTH, USER_WIDTH)::create(), COLOR_CYAN);
        slave_agent = new(env, "slave_agent", s_axis_if_api, SLAVE_AUTO_AGENT, axis_drive_const_pkt#(DATA_WIDTH, USER_WIDTH)::create(HS_ANY), COLOR_MAGENTA);
        
        chk = new("checker", env, 1);        
        chk.finish_on_mismatch = 0;
        env.add_component(chk);
        
        env.get_monitor_port("master_agent").connect(chk.ex_port_predict);
        env.get_monitor_port("slave_agent").connect(chk.ex_port_actual);
        
        test = new("axis_test", env);
        test.snd_seq = new("axis_snd_api_seq", env.get_sequencer("master_agent"));
        test.rcv_seq = new("axis_rcv_api_seq", env.get_sequencer("slave_agent"));
        test.run();
        
        uvml_test::finish();
    end
endmodule
