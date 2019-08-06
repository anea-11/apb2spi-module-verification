//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_uvc_env.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_ENV_SV
`define APB_UVC_ENV_SV

class apb_uvc_env extends uvm_env;
  
    // registration macro
    `uvm_component_utils(apb_uvc_env)  
  
    // configuration instance
    apb_uvc_cfg m_cfg;  

    // master agent instance
    apb_agent master_agent;
    
    // slave agent instance
    apb_slave_agent slave_agent;
    
    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
  
endclass : apb_uvc_env

// constructor
function apb_uvc_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb_uvc_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
  
    // get configuration
    if(!uvm_config_db #(apb_uvc_cfg)::get(this, "", "apb_uvc_cfg_top", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
    end

    // create master agent 
    if(m_cfg.has_master) begin
        master_agent = apb_agent::type_id::create("master_agent", this);
    end
    
    // create slave agent 
    if(m_cfg.has_slave) begin
        slave_agent = apb_slave_agent::type_id::create("slave_agent", this);
    end

    // set checks configuration
    m_cfg.master_agent_cfg.m_has_checks = m_cfg.has_checks;
    m_cfg.slave_agent_cfg.m_has_checks  = m_cfg.has_checks;
    
    // set master agent configuration
    if(m_cfg.has_master) begin
        uvm_config_db#(apb_agent_cfg)::set(this, "master_agent", "master_cfg", m_cfg.master_agent_cfg);
    end
    
     // set slave agent configuration
    if(m_cfg.has_slave) begin
        uvm_config_db#(apb_agent_cfg)::set(this, "slave_agent", "slave_cfg", m_cfg.slave_agent_cfg);
    end
    
endfunction : build_phase

`endif // APB_UVC_ENV_SV
