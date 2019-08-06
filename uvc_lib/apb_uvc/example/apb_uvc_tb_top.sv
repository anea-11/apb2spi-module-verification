//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_uvc_tb_top.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_TB_TOP_SV
`define APB_UVC_TB_TOP_SV

// define timescale
`timescale 1ns/1ns

`include "apb_interface.sv" 

module apb_uvc_tb_top;
  
    `include "uvm_macros.svh"
    import uvm_pkg::*;
  
    // import test package
    import test_apb_uvc_pkg::*;
    
    // signals
    reg         pi_rst_n_tb;
    reg         pi_clk_tb;
    reg  [31:0] paddr_tb;
    reg         psel_tb;
    reg         penable_tb;
    reg         pwrite_tb;
    reg  [31:0] pwdata_tb;
    reg  [3 :0] pstrb_tb;
    reg         pready_tb;
    reg  [31:0] prdata_tb;
    reg         pslverr_tb;
  
    // UVC interface instance
    apb_interface apb_interface_tb(pi_clk_tb, pi_rst_n_tb);
    
    assign paddr_tb                     = apb_interface_tb.paddr;
    assign psel_tb                      = apb_interface_tb.psel;
    assign penable_tb                   = apb_interface_tb.penable;
    assign pwrite_tb                    = apb_interface_tb.pwrite;
    assign pwdata_tb                    = apb_interface_tb.pwdata;
    assign pstrb_tb                     = apb_interface_tb.pstrb;
    assign pready_tb                    = apb_interface_tb.pready;
    assign prdata_tb                    = apb_interface_tb.prdata;
    assign pslverr_tb                   = apb_interface_tb.pslverr;
    
    // configure virtual interface in DB
    // TODO TODO sa ovom * sam htela da postignem da sve komponente u uvm env mogu da dobiju ref na interface - nadam se da je ovo ok
    initial begin : config_if_block
        uvm_config_db#(virtual apb_interface)::set(uvm_root::get(), "uvm_test_top.apb_uvc_env_top.*", "apb_interface", apb_interface_tb);
    end
    
    // define initial clock value and generate reset
    initial begin : clock_and_rst_init_block
        pi_clk_tb           <= 1'b1;
        pi_rst_n_tb         <= 1'b0;
        #501 pi_rst_n_tb    <= 1'b1;
    end
    
    /*
    initial begin : intermediate_rst
        #8000 pi_rst_n_tb   <= 1'b0;
        #257 pi_rst_n_tb   <= 1'b1;
    end
    */
    
    // generate clock
    always begin : clock_gen_block
        #50 pi_clk_tb <= ~pi_clk_tb;
    end
  
    // run test
    initial begin : run_test_block
        run_test();
    end
  
endmodule : apb_uvc_tb_top

`endif // APB_UVC_TB_TOP_SV
