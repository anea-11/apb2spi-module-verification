//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb2spi_pkg.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB2SPI_PKG
`define TEST_APB2SPI_PKG

package test_apb2spi_pkg;

     `include "apb2spi_rst_if.sv"

`include "uvm_macros.svh"
import uvm_pkg::*;

    // import top env package
    import apb2spi_env_pkg::*;
    import spi_uvc_pkg::*;
    import apb_uvc_pkg::*;
    
    // include tests
    `include "test_apb2spi_base.sv"
    `include "test_apb2spi_regs.sv"
    `include "test_apb2spi_slv_trans.sv"
    `include "test_apb2spi_slv_receive.sv"
    `include "test_apb2spi_slv_general.sv"
    
endpackage : test_apb2spi_pkg

`endif // TEST_APB2SPI_PKG
