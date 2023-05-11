module tb_axi;
    `include "uvml_macros.svh";
    import uvml_pkg::*;
    import axi_pkg::*;
    import eg_test_pkg::*;
    
    logic aclk;
    logic aresetn;

    `uvml_clock_reset_n(4, aclk, aresetn)
    
    localparam ADDR_WIDTH = 10;
    localparam DATA_WIDTH = 32;
    localparam USER_WIDTH = 1;

    axi_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .USER_WIDTH(USER_WIDTH)
    )
    m_axi_if (
        .aclk   (aclk),
        .aresetn(aresetn)
    );
    

    axi_if #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH),
        .USER_WIDTH(USER_WIDTH)
    )
    s_axi_if (
        .aclk   (aclk),
        .aresetn(aresetn)
    );

    //DUT
    
    assign s_axi_if.awaddr = m_axi_if.awaddr;
    assign s_axi_if.awlen = m_axi_if.awlen;
    assign s_axi_if.awvalid = m_axi_if.awvalid;
    assign m_axi_if.awready = s_axi_if.awready;
    
    assign s_axi_if.wdata = m_axi_if.wdata;
    assign s_axi_if.wstrb = m_axi_if.wstrb;
    assign s_axi_if.wlast = m_axi_if.wlast;
    assign s_axi_if.wuser = m_axi_if.wuser;
    assign s_axi_if.wvalid = m_axi_if.wvalid;
    assign m_axi_if.wready = s_axi_if.wready;
    
    assign m_axi_if.bresp = s_axi_if.bresp;
    assign m_axi_if.buser = s_axi_if.buser;
    assign m_axi_if.bvalid = s_axi_if.bvalid;
    assign s_axi_if.bready = m_axi_if.bready;
    
    assign s_axi_if.araddr = m_axi_if.araddr;
    assign s_axi_if.arlen = m_axi_if.arlen;
    assign s_axi_if.arvalid = m_axi_if.arvalid;
    assign m_axi_if.arready = s_axi_if.arready;
    
    assign m_axi_if.rdata = s_axi_if.rdata;
    assign m_axi_if.rlast = s_axi_if.rlast;
    assign m_axi_if.ruser = s_axi_if.ruser;
    assign m_axi_if.rresp = s_axi_if.rresp;
    assign m_axi_if.rvalid = s_axi_if.rvalid;
    assign s_axi_if.rready = m_axi_if.rready;


    typedef axi_agent#(.T_VIF(virtual axi_if#( 
                                .ADDR_WIDTH(ADDR_WIDTH),
                                .DATA_WIDTH(DATA_WIDTH),
                                .USER_WIDTH(USER_WIDTH))), 
                        .ADDR_WIDTH(ADDR_WIDTH), 
                        .DATA_WIDTH(DATA_WIDTH),
                        .USER_WIDTH(USER_WIDTH),
                        .T_SEQ_ITEM(axi_data_array_seq_item#(USER_WIDTH))) t_axi_agent;
    
    
    initial begin
        uvml_env env;
        eg_axi_test test;
        t_axi_agent master_agent;
        t_axi_agent slave_agent;
        
        env = new("env");
        master_agent = new(env, "master_agent", m_axi_if, MASTER_AGENT, COLOR_CYAN);
        slave_agent = new(env, "slave_agent", s_axi_if, SLAVE_AGENT, COLOR_MAGENTA);
          
        test = new("axi_test", env);
        test.m_seq = new("axi_master_seq", env.get_agent("master_agent"));
        test.s_seq = new("axi_slave_seq", env.get_agent("slave_agent"));
        test.run();
        
        uvml_test::finish();
    end
endmodule

