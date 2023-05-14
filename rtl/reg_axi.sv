module reg_axi(
        clk,
        rst,
        s_axi,
        m_axi
    );
    
    input clk;
    input rst;
    
    axi_if.slave   s_axi;
    axi_if.master  m_axi;
    
    reg_slice #(
        .DATA_WIDTH(s_axi.ADDR_WIDTH + 8)
    )
    aw_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({s_axi.awlen, s_axi.awaddr}),
        .s_valid(s_axi.awvalid),
        .s_ready(s_axi.awready),
        .m_data ({m_axi.awlen, m_axi.awaddr}),
        .m_valid(m_axi.awvalid),
        .m_ready(m_axi.awready)
    );
    
    reg_slice #(
        .DATA_WIDTH(s_axi.DATA_WIDTH + s_axi.STROBE_WIDTH + s_axi.USER_WIDTH + 1)
    )
    w_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({s_axi.wuser, s_axi.wlast, s_axi.wstrb, s_axi.wdata}),
        .s_valid(s_axi.wvalid),
        .s_ready(s_axi.wready),
        .m_data ({m_axi.wuser, m_axi.wlast, m_axi.wstrb, m_axi.wdata}),
        .m_valid(m_axi.wvalid),
        .m_ready(m_axi.wready)
    );

    reg_slice #(
        .DATA_WIDTH(s_axi.USER_WIDTH + 2)
    )
    b_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({m_axi.buser, m_axi.bresp}),
        .s_valid(m_axi.bvalid),
        .s_ready(m_axi.bready),
        .m_data ({s_axi.buser, s_axi.bresp}),
        .m_valid(s_axi.bvalid),
        .m_ready(s_axi.bready)
    );

    reg_slice #(
        .DATA_WIDTH(s_axi.ADDR_WIDTH + 8)
    )
    ar_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({s_axi.arlen, s_axi.araddr}),
        .s_valid(s_axi.arvalid),
        .s_ready(s_axi.arready),
        .m_data ({m_axi.arlen, m_axi.araddr}),
        .m_valid(m_axi.arvalid),
        .m_ready(m_axi.arready)
    );

    reg_slice #(
        .DATA_WIDTH(s_axi.DATA_WIDTH + s_axi.USER_WIDTH + 3)
    )
    r_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({m_axi.ruser, m_axi.rresp, m_axi.rlast, m_axi.rdata}),
        .s_valid(m_axi.rvalid),
        .s_ready(m_axi.rready),
        .m_data ({s_axi.ruser, s_axi.rready, s_axi.rlast, s_axi.rdata}),
        .m_valid(s_axi.rvalid),
        .m_ready(s_axi.rready)
    );

endmodule