//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_uvc_pkg.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_PKG_SV
`define APB_UVC_PKG_SV
    
package apb_uvc_pkg;

    `include "uvm_macros.svh"
    import uvm_pkg::*;

    `include "apb_uvc_common.sv"
    `include "apb_agent_cfg.sv" 
    `include "apb_uvc_cfg.sv"  
    `include "apb_uvc_item.sv" 
    
    // master  
    `include "apb_driver.sv"
    `include "apb_sequencer.sv"
    `include "apb_monitor.sv"
    `include "apb_protocol_cov.sv"
    `include "apb_agent.sv"
    `include "apb_seq.sv"
    `include "apb_rmw_seq.sv"
    
    // slave
    `include "apb_slave_driver.sv"
    `include "apb_slave_sequencer.sv"
    `include "apb_slave_monitor.sv"
    `include "apb_slave_protocol_cov.sv"
    `include "apb_slave_agent.sv"
    `include "apb_slave_seq.sv"
    
    // uvc environment
    `include "apb_uvc_env.sv" 

endpackage : apb_uvc_pkg

`include "apb_interface.sv"

`endif // APB_UVC_PKG_SV
