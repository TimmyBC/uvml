module reg_axilite(
        clk,
        rst,
        s_axilite,
        m_axilite
    );
    
    input clk;
    input rst;
    
    axilite_if.slave   s_axilite;
    axilite_if.master  m_axilite;
    
    reg_slice #(
        .DATA_WIDTH(s_axilite.ADDR_WIDTH)
    )
    aw_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data (s_axilite.awaddr),
        .s_valid(s_axilite.awvalid),
        .s_ready(s_axilite.awready),
        .m_data (m_axilite.awaddr),
        .m_valid(m_axilite.awvalid),
        .m_ready(m_axilite.awready)
    );
    
    reg_slice #(
        .DATA_WIDTH(s_axilite.DATA_WIDTH + s_axilite.STROBE_WIDTH)
    )
    w_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({s_axilite.wstrb, s_axilite.wdata}),
        .s_valid(s_axilite.wvalid),
        .s_ready(s_axilite.wready),
        .m_data ({m_axilite.wstrb, m_axilite.wdata}),
        .m_valid(m_axilite.wvalid),
        .m_ready(m_axilite.wready)
    );

    reg_slice #(
        .DATA_WIDTH(2)
    )
    b_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data (m_axilite.bresp),
        .s_valid(m_axilite.bvalid),
        .s_ready(m_axilite.bready),
        .m_data (s_axilite.bresp),
        .m_valid(s_axilite.bvalid),
        .m_ready(s_axilite.bready)
    );

    reg_slice #(
        .DATA_WIDTH(s_axilite.ADDR_WIDTH)
    )
    ar_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data (s_axilite.araddr),
        .s_valid(s_axilite.arvalid),
        .s_ready(s_axilite.arready),
        .m_data (m_axilite.araddr),
        .m_valid(m_axilite.arvalid),
        .m_ready(m_axilite.arready)
    );

    reg_slice #(
        .DATA_WIDTH(s_axilite.DATA_WIDTH + 2)
    )
    r_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({m_axilite.rresp, m_axilite.rdata}),
        .s_valid(m_axilite.rvalid),
        .s_ready(m_axilite.rready),
        .m_data ({s_axilite.rresp, s_axilite.rdata}),
        .m_valid(s_axilite.rvalid),
        .m_ready(s_axilite.rready)
    );

endmodule