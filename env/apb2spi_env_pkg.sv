//------------------------------------------------------------------------------
// Copyright (c) 2019 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_env_pkg.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_ENV_PKG_SV
`define APB2SPI_ENV_PKG_SV
    
    `include "apb2spi_rst_if.sv"
     
package apb2spi_env_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;
    import spi_uvc_pkg::*;
    import apb_uvc_pkg::*;
 
    `include "apb2spi_common.sv"
    `include "apb2spi_fifo_buf.sv"
    `include "apb2spi_cfg.sv"
    `include "apb2spi_wr_rd_reg_seq.sv"
    `include "apb2spi_virt_sequencer.sv"
    `include "apb2spi_virt_seq_lib.sv"
    `include "apb2spi_write_reg_seq.sv"
    `include "apb2spi_read_reg_seq.sv"
    `include "apb2spi_spi_seq.sv"
    `include "apb2spi_conf_seq.sv"
    `include "apb2spi_dat_seq.sv"
    `include "apb2spi_read_regs_seq.sv"
    `include "apb2spi_rwr_regs_seq.sv"  
    `include "apb2spi_conf_cov.sv"  
    `include "apb2spi_scoreboard.sv"  
    `include "apb2spi_env.sv" 
    
endpackage : apb2spi_env_pkg

`endif // APB2SPI_ENV_PKG_SV
