//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_agent_cfg.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_AGENT_CFG_SV
`define APB_AGENT_CFG_SV

class apb_agent_cfg extends uvm_object;
  
    // configuration fields
    uvm_active_passive_enum m_is_active = UVM_ACTIVE;
    bit m_has_checks;
    bit m_has_coverage;  
    
    // registration macro
    `uvm_object_utils_begin(apb_agent_cfg)
        `uvm_field_enum(uvm_active_passive_enum, m_is_active, UVM_ALL_ON)
        `uvm_field_int(m_has_checks, UVM_ALL_ON)
        `uvm_field_int(m_has_coverage, UVM_ALL_ON)
    `uvm_object_utils_end
  
    // constructor   
    extern function new(string name = "apb_agent_cfg");
    
endclass : apb_agent_cfg

// constructor
function apb_agent_cfg::new(string name = "apb_agent_cfg");
    super.new(name);
endfunction : new

`endif // APB_AGENT_CFG_SV
