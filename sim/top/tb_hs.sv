module tb_hs;
	`include "uvml_macros.svh";
    import uvml_pkg::*;
    import uvml_hs_pkg::*;
    import eg_test_pkg::*;
    
    logic clk;
    logic rst;

    `uvml_clock_reset(4, clk, rst)
    
    hs_if #(
        .DATA_WIDTH(16)
    )
    rx_hs_if (
        .clk(clk),
        .rst(rst)
    );

    hs_if #(
        .DATA_WIDTH(16)
    )
    tx_hs_if (
        .clk(clk),
        .rst(rst)
    );

    //Sample DUT
    
    reg_slice#(
        .DATA_WIDTH(16)
    ) u_reg_slice (
        .clk(clk),
        .rst(rst),
        .s_data (rx_hs_if.data),
        .s_valid(rx_hs_if.valid),
        .s_ready(rx_hs_if.ready),
        .m_data (tx_hs_if.data),
        .m_valid(tx_hs_if.valid),
        .m_ready(tx_hs_if.ready)
    );

    
//    always@(posedge clk) begin
//        if (rx_hs_if.ready & rx_hs_if.valid) begin
//            $display("RnV %0h", rx_hs_if.data);    
//        end
//    end
//    
    cover property (@(posedge clk) (rx_hs_if.ready & rx_hs_if.valid) == 1);
   
    initial begin
        uvml_env env;
        eg_hs_test test;
        uvml_checker#(eg_hs_seq_item) chk;
        
        env = new("env");
        void'(uvml_hs_agent#(.T_SEQ_ITEM(eg_hs_seq_item), .DATA_WIDTH(16))::create(env, "rx_agent", uvml_hs_if_api#(.T_VIF(virtual hs_if#(.DATA_WIDTH(16))), .DATA_WIDTH(16))::create(rx_hs_if), MASTER_AGENT, uvml_hs_drive_random#(16)::create(), LOG_DEFAULT));
        void'(uvml_hs_agent#(.T_SEQ_ITEM(eg_hs_seq_item), .DATA_WIDTH(16))::create(env, "tx_agent", uvml_hs_if_api#(.T_VIF(virtual hs_if#(.DATA_WIDTH(16))), .DATA_WIDTH(16))::create(tx_hs_if), SLAVE_AGENT, uvml_hs_drive_random#(16)::create(), COLOR_BLUE));
        
        chk = new("checker", env, 1);        
        env.add_component(chk);
        
        env.get_monitor_port("rx_agent").connect(chk.ex_port_predict);
        env.get_monitor_port("tx_agent").connect(chk.ex_port_actual);
        
        test = new("hs_test", env);
        test.snd_seq = new("hs_snd_api_seq", env.get_sequencer("rx_agent"));
        test.rcv_seq = new("hs_rcv_api_seq", env.get_sequencer("tx_agent"));
        test.run();
        
		uvml_test::finish();
	end
	
endmodule
