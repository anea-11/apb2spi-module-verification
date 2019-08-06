//------------------------------------------------------------------------------
// Copyright (c) 2019 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_cfg.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_CFG_SV
`define APB2SPI_CFG_SV

class apb2spi_cfg extends uvm_object;
  
    // SPI UVC configuration fields
    int                     SPI_UVC_T_SCK_ns    = DEFAULT_T_NS;
    spi_polarity_type       SPI_UVC_CPOL        = CPOL_0;
    spi_phase_type          SPI_UVC_CPHA        = CPHA_0;
    data_order_type         SPI_UVC_DORD        = MSB;
    int                     SPI_UVC_DSIZ        = 16;
    int                     SPI_UVC_SS_sel      = 0;
    
    // uvc conf references
    apb_uvc_cfg apb_uvc_cfg_inst;
    spi_uvc_cfg spi_uvc_cfg_inst;
    
    // registration macro
    `uvm_object_utils_begin(apb2spi_cfg)
        `uvm_field_int(SPI_UVC_T_SCK_ns, UVM_ALL_ON)
        `uvm_field_enum(spi_polarity_type, SPI_UVC_CPOL, UVM_ALL_ON)
        `uvm_field_enum(spi_phase_type, SPI_UVC_CPHA, UVM_ALL_ON)
        `uvm_field_enum(data_order_type, SPI_UVC_DORD, UVM_ALL_ON)
        `uvm_field_int(SPI_UVC_DSIZ, UVM_ALL_ON)
        `uvm_field_int(SPI_UVC_SS_sel, UVM_ALL_ON)
    `uvm_object_utils_end
  
    // constructor   
    extern function new(string name = "apb2spi_cfg");
    
endclass : apb2spi_cfg

// constructor
function apb2spi_cfg::new(string name = "apb2spi_cfg");
    super.new(name);
    
    // create uvc config instances
    apb_uvc_cfg_inst    = apb_uvc_cfg::type_id::create("apb_uvc_cfg_inst");
    spi_uvc_cfg_inst    = spi_uvc_cfg::type_id::create("spi_uvc_cfg_inst");
    
endfunction : new

`endif // APB2SPI_CFG_SV
