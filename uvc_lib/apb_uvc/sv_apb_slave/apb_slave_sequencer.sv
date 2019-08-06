//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_sequencer.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SLAVE_SEQUENCER_SV
`define APB_SLAVE_SEQUENCER_SV

class apb_slave_sequencer extends uvm_sequencer #(apb_uvc_item);
  
    // registration macro
    `uvm_component_utils(apb_slave_sequencer)

    // constructor    
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
  
endclass : apb_slave_sequencer

// constructor
function apb_slave_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb_slave_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

`endif // APB_SLAVE_SEQUENCER_SV
