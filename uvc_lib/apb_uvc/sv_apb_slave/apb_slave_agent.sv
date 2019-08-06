//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_slave_agent.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SLAVE_AGENT_SV
`define APB_SLAVE_AGENT_SV

class apb_slave_agent extends uvm_agent;
  
    // registration macro
    `uvm_component_utils(apb_slave_agent)
  
    // analysis port
    uvm_analysis_port #(apb_uvc_item) m_aport;
    
    // virtual interface reference
    virtual interface apb_interface m_vif;
      
    // configuration reference
    apb_agent_cfg m_cfg;
  
    // components instances
    apb_slave_driver        m_driver;
    apb_slave_sequencer     m_sequencer;
    apb_slave_monitor       m_monitor;
    apb_slave_protocol_cov  m_cov;
  
    // constructor
    extern function new( string name, uvm_component parent );
    
    // build phase
    extern virtual function void build_phase( uvm_phase phase );
    
    // connect phase
    extern virtual function void connect_phase( uvm_phase phase );
    
    // print configuration
    extern virtual function void print_cfg();

endclass : apb_slave_agent

// constructor
function apb_slave_agent::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb_slave_agent::build_phase(uvm_phase phase);
    super.build_phase(phase);
  
    // create ports
    m_aport = new("m_aport", this);
  
    // get virtual interface from config db
    if(!uvm_config_db#(virtual apb_interface)::get(this, "", "apb_interface", m_vif)) begin
        `uvm_fatal(get_type_name(), "Failed to get virtual interface from config DB!")
    end
  
    // get configuration from config db
    if(!uvm_config_db #(apb_agent_cfg)::get(this, "", "slave_cfg", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
    end else begin
        print_cfg();
    end
    
    m_vif.has_checks = m_cfg.m_has_checks;
    
    // create components
    if (m_cfg.m_is_active == UVM_ACTIVE) begin
        m_driver    = apb_slave_driver::type_id::create("m_driver", this);
        m_sequencer = apb_slave_sequencer::type_id::create("m_sequencer", this);
    end
    
    m_monitor = apb_slave_monitor::type_id::create("m_monitor", this);
    
    if (m_cfg.m_has_coverage == 1) begin
        m_cov = apb_slave_protocol_cov::type_id::create("m_cov", this);
    end  
endfunction : build_phase

// connect phase
function void apb_slave_agent::connect_phase(uvm_phase phase);
    super.connect_phase(phase);
  
    // connect ports
    if (m_cfg.m_is_active == UVM_ACTIVE) begin
        m_driver.seq_item_port.connect(m_sequencer.seq_item_export);
    end
    
    m_monitor.m_aport.connect(m_aport);
    
    if (m_cfg.m_has_coverage == 1) begin
        m_monitor.m_aport.connect(m_cov.analysis_export);
    end
  
    // assign interface
    if (m_cfg.m_is_active == UVM_ACTIVE) begin
        m_driver.m_vif = m_vif;
    end
    
    m_monitor.m_vif = m_vif;
  
endfunction : connect_phase

// print configuration
function void apb_slave_agent::print_cfg();
    `uvm_info(get_type_name(), $sformatf("Configuration: \n%s", m_cfg.sprint()), UVM_HIGH)
endfunction : print_cfg

`endif // APB_SLAVE_AGENT_SV
