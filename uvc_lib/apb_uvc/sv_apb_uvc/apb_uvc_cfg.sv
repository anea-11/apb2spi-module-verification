//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_uvc_cfg.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_CFG_SV
`define APB_UVC_CFG_SV

class apb_uvc_cfg extends uvm_object;
  
    // flags used by apb_uvc_env
    bit has_master;
    bit has_slave;
    bit has_checks;
    bit has_coverage;
    
    // master configuration
    apb_agent_cfg master_agent_cfg;

    // slave configuration
    apb_agent_cfg slave_agent_cfg;
   
    // registration macro
    `uvm_object_utils_begin(apb_uvc_cfg)
        `uvm_field_int(has_master, UVM_ALL_ON)
        `uvm_field_int(has_slave, UVM_ALL_ON)
        `uvm_field_int(has_coverage, UVM_ALL_ON)
        `uvm_field_int(has_checks, UVM_ALL_ON)
        `uvm_field_object(master_agent_cfg, UVM_ALL_ON)
        `uvm_field_object(slave_agent_cfg, UVM_ALL_ON)
    `uvm_object_utils_end
  
    // constructor   
    extern function new(string name = "apb_uvc_cfg");
    
    // configure agents   
    extern function void configure_agents();
    
endclass : apb_uvc_cfg

// constructor
function apb_uvc_cfg::new(string name = "apb_uvc_cfg");
    super.new(name);
  
    // create master agent configuration
    master_agent_cfg = apb_agent_cfg::type_id::create("master_agent_cfg");
    
    // create agent configuration
    slave_agent_cfg = apb_agent_cfg::type_id::create("slave_agent_cfg");   
    
endfunction : new

// configure agents
function void apb_uvc_cfg::configure_agents();
        
    master_agent_cfg.m_has_checks       = has_checks;
    master_agent_cfg.m_has_coverage     = has_coverage;
    
    slave_agent_cfg.m_has_checks        = has_checks;
    slave_agent_cfg.m_has_coverage      = has_coverage;
    
endfunction : configure_agents

`endif // APB_UVC_CFG_SV
