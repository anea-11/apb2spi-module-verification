//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_top_tb.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_TOP_TB_SV
`define APB2SPI_TOP_TB_SV

// define timescale
`timescale 1ns/1ns

module apb2spi_top_tb;
 
    `include "uvm_macros.svh"
    import uvm_pkg::*;
   
    import test_apb2spi_pkg::*;
    
    // signals    
    reg         clk_tb;
    reg         rst_n_tb;
    
    // APB signals
    reg [31:0]  paddr_tb;
    reg         psel_tb;
    reg         penable_tb;
    reg         pwrite_tb;                    
    reg [31:0]  pwdata_tb;                    
    reg [3 :0]  pstrb_tb;                              
    reg         pready_tb;                         
    reg [31:0]  prdata_tb;                    
    reg         pslverr_tb;                    
    
    // SPI signals                    
    reg [7 :0]  SS_n_tb;
    reg         SCK_tb;
    reg         MOSI_tb;
    reg         MISO_tb;
        
    // interface instances
    apb_interface   apb_interface_tb(clk_tb, rst_n_tb);
    spi_interface   spi_interface_tb(rst_n_tb);
    apb2spi_rst_if  rst_interface_tb();
    
    // rst interface interconnections
    assign rst_n_tb                     = rst_interface_tb.rst_n;
    
    // APB interface interconnections
    assign paddr_tb                     = apb_interface_tb.paddr;
    assign psel_tb                      = apb_interface_tb.psel;
    assign penable_tb                   = apb_interface_tb.penable;
    assign pwrite_tb                    = apb_interface_tb.pwrite;
    assign pwdata_tb                    = apb_interface_tb.pwdata;
    assign pstrb_tb                     = apb_interface_tb.pstrb;
    
    assign apb_interface_tb.pready      = pready_tb;
    assign apb_interface_tb.prdata      = prdata_tb;
    assign apb_interface_tb.pslverr     = pslverr_tb;
    
    // SPI interface interconnections
    assign SS_n_tb                     = spi_interface_tb.SS_n;
    assign SCK_tb                      = spi_interface_tb.SCK;
    assign MOSI_tb                     = spi_interface_tb.MOSI;
    assign spi_interface_tb.MISO       = MISO_tb;
    

    // configure virtual interface in DB
    initial begin : config_if_block
        uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "uvm_test_top.apb2spi_env_top.*", "apb_interface", apb_interface_tb);
        uvm_config_db#(virtual spi_interface)::set(uvm_root::get(), "uvm_test_top.apb2spi_env_top.*", "spi_interface", spi_interface_tb);
        uvm_config_db#(virtual apb2spi_rst_if)::set(uvm_root::get(), "uvm_test_top", "rst_interface", rst_interface_tb);
    end
     
// dut instantiation    
apb2spi_dut_wrapper dut_wrapper(
                        .pi_clk(clk_tb),
                        .pi_rst_n(rst_n_tb),
                        
                        .pi_paddr(paddr_tb),
                        .pi_psel(psel_tb),
                        .pi_penable(penable_tb),
                        .pi_pwrite(pwrite_tb),
                        .pi_pwdata(pwdata_tb),
                        .pi_pstrb(pstrb_tb),
                        .po_pready(pready_tb),
                        .po_prdata(prdata_tb),
                        .po_pslverr(pslverr_tb),
      
                        .SS_n(SS_n_tb),
                        .SCK(SCK_tb),
                        .MOSI(MOSI_tb),
                        .MISO(MISO_tb)
);
    
    // define initial clock value and generate reset
    initial begin : clock_and_rst_init_block
        clk_tb           <= 1'b1;
    end
    
    // generate clock
    always begin : clock_gen_block
        #50 clk_tb <= ~clk_tb;
    end
    
    // run test
    initial begin : run_test_block
        run_test();
    end
    
endmodule : apb2spi_top_tb

`endif // APB2SPI_TOP_TB_SV
