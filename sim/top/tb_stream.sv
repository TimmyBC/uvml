module tb_stream;
    `include "uvml_macros.svh";
    import uvml_pkg::*;
    import uvml_stream_pkg::*;
    import eg_test_pkg::*;
    
    logic clk;
    logic rst;

    `uvml_clock_reset(4, clk, rst)
    
    localparam DATA_WIDTH = 32;

    stream_if #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    m_stream_if (
        .clk(clk),
        .rst(rst)
    );

    stream_if #(
        .DATA_WIDTH(DATA_WIDTH)
    )
    s_stream_if (
        .clk(clk),
        .rst(rst)
    );

    //Sample DUT
    
    reg_slice#(
        .DATA_WIDTH(DATA_WIDTH + 1)
    ) u_reg_slice (
        .clk(clk),
        .rst(rst),
        .s_data ({m_stream_if.last, m_stream_if.data}),
        .s_valid(m_stream_if.valid),
        .s_ready(m_stream_if.ready),
        .m_data ({s_stream_if.last, s_stream_if.data}),
        .m_valid(s_stream_if.valid),
        .m_ready(s_stream_if.ready)
    );

    typedef uvml_stream_agent#(.T_SEQ_ITEM(uvml_stream_packet), .DATA_WIDTH(DATA_WIDTH)) t_uvml_stream_agent;
    typedef uvml_stream_if_api#(.T_VIF(virtual stream_if#(.DATA_WIDTH(DATA_WIDTH))), .DATA_WIDTH(DATA_WIDTH)) t_uvml_stream_if_api;
    
    initial begin
        uvml_env env;
        eg_stream_test test;
        uvml_checker#(uvml_stream_packet) chk;
        
        t_uvml_stream_if_api m_stream_if_api;
        t_uvml_stream_if_api s_stream_if_api;
        
        t_uvml_stream_agent master_agent;
        t_uvml_stream_agent slave_agent;
        
        m_stream_if_api = new(m_stream_if);
        s_stream_if_api = new(s_stream_if);
        
        env = new("env");

        master_agent = new(env, "master", m_stream_if_api, MASTER_AGENT, uvml_stream_drive_random#(DATA_WIDTH)::create(), LOG_DEFAULT);
        slave_agent = new(env, "slave", s_stream_if_api, SLAVE_AGENT, uvml_stream_drive_random#(DATA_WIDTH)::create(), LOG_DEFAULT);
       
        chk = new("checker", env, 1);        
        chk.finish_on_mismatch = 0;
        env.add_component(chk);
        
        env.get_monitor_port("master").connect(chk.ex_port_predict);
        env.get_monitor_port("slave").connect(chk.ex_port_actual);
        
        test = new("stream_test", env);
        test.snd_seq = new("stream_snd_api_seq", env.get_sequencer("master"));
        test.rcv_seq = new("stream_rcv_api_seq", env.get_sequencer("slave"));
        test.run();
        
        uvml_test::finish();
    end
endmodule
