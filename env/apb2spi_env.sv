//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_env.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_ENV_SV
`define APB2SPI_ENV_SV

class apb2spi_env extends uvm_env;
  
    // registration macro
    `uvm_component_utils(apb2spi_env)  
  
    // configuration instance
    apb2spi_cfg m_cfg;  

    // APB UVC 
    apb_uvc_env apb_uvc;
    
    // SPI UVC 
    spi_uvc_env spi_uvc;
    
    // coverage instance
    apb2spi_conf_cov config_cov;
    
    // virtual sequencer instance
    apb2spi_virt_sequencer v_sequencer;
    
    // scoreboard instance
    apb2spi_scoreboard m_scoreboard;
    
    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    
    // connect phase
    extern virtual function void connect_phase(uvm_phase phase);

endclass : apb2spi_env

// constructor
function apb2spi_env::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb2spi_env::build_phase(uvm_phase phase);
    super.build_phase(phase);
  
    // get configuration
    if(!uvm_config_db #(apb2spi_cfg)::get(this, "", "apb2spi_cfg_top", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get apb2spi_cfg_top object from config DB!")
    end
    
    // create APB UVC 
    apb_uvc             = apb_uvc_env::type_id::create("apb_uvc", this);
    
    // create SPI UVC 
    spi_uvc             = spi_uvc_env::type_id::create("spi_uvc", this);
        
    // create coverage instance
    config_cov          = apb2spi_conf_cov::type_id::create("config_cov", this);
    
    // create virtual sequencer instance
    v_sequencer         = apb2spi_virt_sequencer::type_id::create("v_sequencer", this);
    
    // create scoreboard instance
    m_scoreboard        = apb2spi_scoreboard::type_id::create("m_scoreboard", this);
    
endfunction : build_phase

// connect phase
function void apb2spi_env::connect_phase(uvm_phase phase);
    super.connect_phase(phase);

    // connect APB UVC master analysis export to config_cov port
    apb_uvc.master_agent.m_aport.connect(config_cov.analysis_export);
 
    // connect APB UVC master analysis export to scb port
    apb_uvc.master_agent.m_aport.connect(m_scoreboard.apb_scb_port);
    
    // connect SPI UVC master analysis export to scb port
    spi_uvc.master_agent.m_aport.connect(m_scoreboard.spi_scb_port);
    
    // virtual sequencer receives handles to real sequencers
    v_sequencer.apb_sequencer_inst  = apb_uvc.master_agent.m_sequencer;
    v_sequencer.spi_sequencer_inst  = spi_uvc.master_agent.m_sequencer;
    
    // connect scoreboard and coverage
    m_scoreboard.config_cov = config_cov;
    
endfunction : connect_phase

`endif // APB2SPI_ENV_SV
