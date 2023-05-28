module tb_fifo;
    `include "uvml_macros.svh";
    import uvml_pkg::*;
    import axis_pkg::*;
    import eg_test_pkg::*;
    
    logic clk;
    logic rst;

    `uvml_clock_reset(10, clk, rst)
    
    localparam DATA_WIDTH       = 32;
    localparam USER_WIDTH       = 33;
    localparam MAX_PKT_BEATS    = 4;

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
    stream_fifo#(
        .DATA_WIDTH     (DATA_WIDTH + (DATA_WIDTH/8) + USER_WIDTH),
        .DEPTH          (16),
        .RDY_BEFORE_VLD (0),
        .MAX_PKT_BEATS  (MAX_PKT_BEATS)
    ) u_stream_fifo (
        .clk        (clk),
        .rst        (rst),

        .s_data     ({m_axis_if.user, m_axis_if.keep, m_axis_if.data}), 
        .s_last     (m_axis_if.last),    
        .s_valid    (m_axis_if.valid),
        .s_ready    (m_axis_if.ready),
        
        .m_data     ({s_axis_if.user, s_axis_if.keep, s_axis_if.data}),
        .m_last     (s_axis_if.last),
        .m_valid    (s_axis_if.valid),
        .m_ready    (s_axis_if.ready)
    );

    typedef axis_agent#(axis_data_packet,DATA_WIDTH,USER_WIDTH) t_m_axis_agent;    
    typedef axis_agent#(axis_data_packet,DATA_WIDTH,USER_WIDTH) t_s_axis_agent;    
    typedef axis_if_api#(virtual axis_if#(DATA_WIDTH, USER_WIDTH), DATA_WIDTH, USER_WIDTH) t_axis_if_api;
    
    initial begin
        uvml_env env;
        fifo_test#(.MAX_PKT_BYTES(MAX_PKT_BEATS * DATA_WIDTH / 8)) test;
        t_m_axis_agent master_agent;
        t_s_axis_agent slave_agent;        
        t_axis_if_api m_axis_if_api;
        t_axis_if_api s_axis_if_api;
        
        m_axis_if_api = new(m_axis_if);
        s_axis_if_api = new(s_axis_if);
        
        env = new("env");
        master_agent = new(env, "master_agent", m_axis_if_api, MASTER_AGENT, axis_drive_random#(DATA_WIDTH, USER_WIDTH)::create(), COLOR_CYAN);
        slave_agent = new(env, "slave_agent", s_axis_if_api, SLAVE_AGENT, axis_drive_random#(DATA_WIDTH, USER_WIDTH)::create(), COLOR_MAGENTA);
        
        test = new("tb_fifo", env);
        test.snd_seq = new("fifo_snd_api_seq", env.get_sequencer("master_agent"));
        test.rcv_seq = new("fifo_rcv_api_seq", env.get_sequencer("slave_agent"));
        test.run();
        
        uvml_test::finish();
    end
endmodule
