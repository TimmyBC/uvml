module reg_axis(
        clk,
        rst,
        s_axis,
        m_axis
    );
    
    input clk;
    input rst;
    
    axis_if.slave   s_axis;
    axis_if.master  m_axis;
    
    reg_slice #(
        .DATA_WIDTH(s_axis.DATA_WIDTH + s_axis.KEEP_WIDTH + s_axis.USER_WIDTH + 1)
    )
    u_reg_slice (
        .clk    (clk),
        .rst    (rst),
        .s_data ({s_axis.user, s_axis.last, s_axis.keep, s_axis.data}),
        .s_valid(s_axis.valid),
        .s_ready(s_axis.ready),
        .m_data ({m_axis.user, m_axis.last, m_axis.keep, m_axis.data}),
        .m_valid(m_axis.valid),
        .m_ready(m_axis.ready)
    );
      
endmodule