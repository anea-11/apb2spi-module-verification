
module apb2spi_dut_wrapper(

      input          pi_clk,
      input          pi_rst_n,
      
      //APB Interface
      input  [31 :0] pi_paddr,
      input          pi_psel,
      input          pi_penable,
      input          pi_pwrite,
      input  [31 :0] pi_pwdata,
      input  [3 :0]  pi_pstrb,
      output         po_pready,
      output [31 :0] po_prdata,
      output         po_pslverr,
      
      //SPI Interface
      input  [7:0]   SS_n,
      input          SCK,
      input          MOSI,
      output         MISO
);

//interconnections

    wire SCKOE, SCKOUT, SCKIN;
    wire MDOE, MDOUT, SDIN;
    wire SDOE, SDOUT, MDIN;
    
    wire [7:0] SSOE, SSOUT, SSIN;
      
top dut(
        // APB interface
        .pi_clk(pi_clk),
        .pi_rst_n(pi_rst_n),
        .pi_paddr(pi_paddr),
        .pi_psel(pi_psel),
        .pi_penable(pi_penable),
        .pi_pwrite(pi_pwrite),
        .pi_pwdata(pi_pwdata),
        .pi_pstrb(pi_pstrb),
        .po_pready(po_pready),
        .po_prdata(po_prdata),
        .po_pslverr(po_pslverr),
        // unconnected ports
        .po_intreq(),
        .pi_dma_rcv_ack(),
        .pi_dma_tr_ack(),
        .po_dma_rcv_req(),
        .po_dma_tr_req(),
        // SPI interface
        .pi_ss(SSIN),
        .pi_sck(SCKIN),
        .pi_sd(SDIN),
        .pi_md(MDIN),
        .po_ss_oe(SSOE),
        .po_ss(SSOUT),
        .po_sck_oe(SCKOE),
        .po_sck(SCKOUT),
        .po_md_oe(MDOE),
        .po_md(MDOUT),
        .po_sd_oe(SDOE),
        .po_sd(SDOUT)
);

// SCK line
bufif1  b1(SCK, SCKOUT, SCKOE);
buf     b2(SCKIN, SCK);         

// MOSI line
bufif1  b3(MOSI, MDOUT, MDOE);
buf     b4(SDIN, MOSI); 

// MISO line
bufif1  b5(MISO, SDOUT, SDOE);
buf     b6(MDIN, MISO); 

// SS lines 
bufif1  buf_arr1[7:0] (SS_n, SSOUT, SSOE);
buf     buf_arr2[7:0] (SSIN, SS_n); 

endmodule
