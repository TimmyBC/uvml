module tb_axilite;
    `include "uvml_macros.svh";
    import uvml_pkg::*;
    import axilite_pkg::*;
    import eg_test_pkg::*;
    
    logic aclk;
    logic aresetn;

    `uvml_clock_reset_n(4, aclk, aresetn)
    
    localparam ADDR_WIDTH = 10;
    localparam DATA_WIDTH = 32;

    axilite_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )
    m_axilite_if (
        .aclk   (aclk),
        .aresetn(aresetn)
    );
    

    axilite_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )
    s_axilite_if (
        .aclk   (aclk),
        .aresetn(aresetn)
    );

    //DUT
    reg_axilite u_reg_axilite (
        .clk      (aclk),
        .rst      (~aresetn),
        .m_axilite(s_axilite_if),
        .s_axilite(m_axilite_if)
    );
//    assign s_axilite_if.awaddr = m_axilite_if.awaddr;
//    assign s_axilite_if.awvalid = m_axilite_if.awvalid;
//    assign m_axilite_if.awready = s_axilite_if.awready;
//    
//    assign s_axilite_if.wdata = m_axilite_if.wdata;
//    assign s_axilite_if.wstrb = m_axilite_if.wstrb;
//    assign s_axilite_if.wvalid = m_axilite_if.wvalid;
//    assign m_axilite_if.wready = s_axilite_if.wready;
//    
//    assign m_axilite_if.bresp = s_axilite_if.bresp;
//    assign m_axilite_if.bvalid = s_axilite_if.bvalid;
//    assign s_axilite_if.bready = m_axilite_if.bready;
//    
//    assign s_axilite_if.araddr = m_axilite_if.araddr;
//    assign s_axilite_if.arvalid = m_axilite_if.arvalid;
//    assign m_axilite_if.arready = s_axilite_if.arready;
//    
//    assign m_axilite_if.rdata = s_axilite_if.rdata;
//    assign m_axilite_if.rresp = s_axilite_if.rresp;
//    assign m_axilite_if.rvalid = s_axilite_if.rvalid;
//    assign s_axilite_if.rready = m_axilite_if.rready;


    typedef axilite_agent#(.T_VIF(virtual axilite_if#( 
                                .ADDR_WIDTH(ADDR_WIDTH),
                                .DATA_WIDTH(DATA_WIDTH))), 
                        .ADDR_WIDTH(ADDR_WIDTH), 
                        .DATA_WIDTH(DATA_WIDTH)) t_axilite_agent;
    
    
    initial begin
        uvml_env env;
        eg_axilite_test test;
        t_axilite_agent master_agent;
        t_axilite_agent slave_agent;
        
        env = new("env");
        master_agent = new(env, "master_agent", m_axilite_if, MASTER_AGENT, COLOR_CYAN, MONITOR_ENABLE);
        slave_agent = new(env, "slave_agent", s_axilite_if, SLAVE_AGENT, COLOR_MAGENTA, MONITOR_ENABLE);
          
        test = new("axilite_test", env);
        test.m_seq = new("axilite_master_seq", env.get_sequencer("master_agent"));
        test.s_seq = new("axilite_slave_seq", env.get_sequencer("slave_agent"));
        test.run();
        
        uvml_test::finish();
    end
endmodule
