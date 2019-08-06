//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_rst_if.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_RST_IF_SV
`define APB2SPI_RST_IF_SV

interface apb2spi_rst_if;
  
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    
    // signals
    logic       rst_n;
    
endinterface : apb2spi_rst_if

`endif // APB2SPI_RST_IF_SV
