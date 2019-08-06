//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb2spi_base.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB2SPI_BASE_SV
`define TEST_APB2SPI_BASE_SV

`include "apb2spi_rst_if.sv"

class test_apb2spi_base extends uvm_test;
  
    // reset interface
    virtual apb2spi_rst_if  rst_interface;
  
    // registration macro
    `uvm_component_utils(test_apb2spi_base)

    // component instance
    apb2spi_env apb2spi_env_top;
  
    // configuration instance
    apb2spi_cfg apb2spi_cfg_top;
   
    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
    // end_of_elaboration phase
    extern virtual function void end_of_elaboration_phase(uvm_phase phase);
    
    // set default configuration
    extern virtual function void set_default_configuration();
    
endclass : test_apb2spi_base 

// constructor
function test_apb2spi_base::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void test_apb2spi_base::build_phase(uvm_phase phase);
    super.build_phase(phase);    
  
    // get virtual rst interface from config DB
    if(!uvm_config_db#(virtual apb2spi_rst_if)::get(this, "", "rst_interface", rst_interface)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB!")
    end
  
    // create top environment
    apb2spi_env_top = apb2spi_env::type_id::create("apb2spi_env_top", this);
   
    // create and set configuration
    apb2spi_cfg_top = apb2spi_cfg::type_id::create("apb2spi_cfg_top", this);
    set_default_configuration();

    // set configurations in DB
    uvm_config_db#(apb2spi_cfg)::set(this, "apb2spi_env_top.m_scoreboard", "apb2spi_cfg_top", apb2spi_cfg_top);
    uvm_config_db#(apb2spi_cfg)::set(this, "apb2spi_env_top", "apb2spi_cfg_top", apb2spi_cfg_top);
    uvm_config_db#(apb_uvc_cfg)::set(this, "apb2spi_env_top.apb_uvc", "apb_uvc_cfg_top", apb2spi_cfg_top.apb_uvc_cfg_inst);
    uvm_config_db#(spi_uvc_cfg)::set(this, "apb2spi_env_top.spi_uvc", "spi_uvc_cfg_top", apb2spi_cfg_top.spi_uvc_cfg_inst);
    
    // enable monitor item recording
    set_config_int("*", "recording_detail", 1);
  
    // define verbosity
    //uvm_top.set_report_verbosity_level_hier(UVM_HIGH);
endfunction : build_phase

// run phase
task test_apb2spi_base::run_phase(uvm_phase phase);
    super.run_phase(phase);
endtask : run_phase


// end_of_elaboration phase
function void test_apb2spi_base::end_of_elaboration_phase(uvm_phase phase);
    super.end_of_elaboration_phase(phase);

    // allow additional time before stopping
    uvm_test_done.set_drain_time(this, 10us);
endfunction : end_of_elaboration_phase

// set default configuration
function void test_apb2spi_base::set_default_configuration();
    
    // configure top environment
    apb2spi_cfg_top.SPI_UVC_T_SCK_ns    = 200;
    apb2spi_cfg_top.SPI_UVC_CPOL        = CPOL_0;
    apb2spi_cfg_top.SPI_UVC_CPHA        = CPHA_0;
    apb2spi_cfg_top.SPI_UVC_DORD        = LSB;
    apb2spi_cfg_top.SPI_UVC_DSIZ        = 16;
    apb2spi_cfg_top.SPI_UVC_SS_sel      = 1;
    
    // configure APB UVC
    apb2spi_cfg_top.apb_uvc_cfg_inst.has_master     = 1'b1;
    apb2spi_cfg_top.apb_uvc_cfg_inst.has_slave      = 1'b0;
    apb2spi_cfg_top.apb_uvc_cfg_inst.has_checks     = 1'b1;
    apb2spi_cfg_top.apb_uvc_cfg_inst.has_coverage   = 1'b1;
    
    apb2spi_cfg_top.apb_uvc_cfg_inst.configure_agents();
    
    apb2spi_cfg_top.apb_uvc_cfg_inst.master_agent_cfg.m_is_active       = UVM_ACTIVE;
    
    
    // configure SPI UVC
    apb2spi_cfg_top.spi_uvc_cfg_inst.has_master     = 1'b1;
    apb2spi_cfg_top.spi_uvc_cfg_inst.has_slave      = 1'b0;
    apb2spi_cfg_top.spi_uvc_cfg_inst.has_checks     = 1'b1;
    apb2spi_cfg_top.spi_uvc_cfg_inst.has_coverage   = 1'b1;
    
    apb2spi_cfg_top.spi_uvc_cfg_inst.configure_agents();
    
    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.m_is_active       = UVM_ACTIVE;
    

    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.T_SCK_ns  = 200;
    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.CPOL      = CPOL_0;
    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.CPHA      = CPHA_0;
    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.DORD      = LSB;
    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.DSIZ      = 16;
    apb2spi_cfg_top.spi_uvc_cfg_inst.master_agent_cfg.SS_sel    = 1;

endfunction : set_default_configuration

`endif // TEST_APB2SPI_BASE_SV
