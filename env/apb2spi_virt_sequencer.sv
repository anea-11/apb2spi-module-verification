//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_virt_sequencer.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_VIRT_SEQUENCER_SV
`define APB2SPI_VIRT_SEQUENCER_SV

class apb2spi_virt_sequencer extends uvm_sequencer;
  
    // registration macro
    `uvm_component_utils(apb2spi_virt_sequencer)

    // constructor    
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
  
    // handles to other sequencers
    apb_sequencer   apb_sequencer_inst;
    spi_sequencer   spi_sequencer_inst;
  
endclass : apb2spi_virt_sequencer

// constructor
function apb2spi_virt_sequencer::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb2spi_virt_sequencer::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

`endif // APB2SPI_VIRT_SEQUENCER_SV
