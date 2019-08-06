//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb_uvc_base.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB_UVC_BASE_SV
`define TEST_APB_UVC_BASE_SV

class test_apb_uvc_base extends uvm_test;
  
    // registration macro
    `uvm_component_utils(test_apb_uvc_base)
  
    // component instance
    apb_uvc_env apb_uvc_env_top;
  
    // configuration instance
    apb_uvc_cfg apb_uvc_cfg_top;
   
    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    
    // end_of_elaboration phase
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    
    // set default configuration
    extern virtual function void set_default_configuration();
    
endclass : test_apb_uvc_base 

// constructor
function test_apb_uvc_base::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void test_apb_uvc_base::build_phase(uvm_phase phase);
    super.build_phase(phase);    
  
    // create top environment
    apb_uvc_env_top = apb_uvc_env::type_id::create("apb_uvc_env_top", this);
   
    // create and set configuration
    apb_uvc_cfg_top = apb_uvc_cfg::type_id::create("apb_uvc_cfg_top", this);
    set_default_configuration();
  
    // set configuration in DB
    uvm_config_db#(apb_uvc_cfg)::set(this, "apb_uvc_env_top", "apb_uvc_cfg_top", apb_uvc_cfg_top);
    
    // enable monitor item recording
    set_config_int("*", "recording_detail", 1);
  
    // define verbosity
    uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
endfunction : build_phase

// end_of_elaboration phase
function void test_apb_uvc_base::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    // allow additional time before stopping
    uvm_test_done.set_drain_time(this, 10us);
endfunction : end_of_elaboration_phase

// set default configuration
function void test_apb_uvc_base::set_default_configuration();
    
    // configure top environment
    apb_uvc_cfg_top.has_master      = 1;
    apb_uvc_cfg_top.has_slave       = 1;
    apb_uvc_cfg_top.has_checks      = 0;
    apb_uvc_cfg_top.has_coverage    = 1;
    
    // configure checks and coverage for agents
    apb_uvc_cfg_top.configure_agents();
    
    // configure master agent
    apb_uvc_cfg_top.master_agent_cfg.m_is_active    = UVM_ACTIVE;
    
    // configure slave agent
    apb_uvc_cfg_top.slave_agent_cfg.m_is_active     = UVM_ACTIVE;
    
endfunction : set_default_configuration

`endif // TEST_APB_UVC_BASE_SV
