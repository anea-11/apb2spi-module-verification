//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_virt_seq_lib.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_VIRT_SEQ_LIB_SV
`define APB2SPI_VIRT_SEQ_LIB_SV

class apb2spi_virt_seq_lib extends uvm_sequence;
  
    // registration macro
    `uvm_object_utils(apb2spi_virt_seq_lib)
    
    // sequencer pointer macro
    `uvm_declare_p_sequencer(apb2spi_virt_sequencer)
  
    // sequences
    apb_seq m_apb_seq;
    spi_seq m_spi_seq;
    
    // constructor
    extern function new(string name = "apb2spi_virt_seq_lib");

    // pre_body task
    extern virtual task pre_body();

    // body task
    extern virtual task body();

endclass : apb2spi_virt_seq_lib

// constructor
function apb2spi_virt_seq_lib::new(string name = "apb2spi_virt_seq_lib");
    super.new(name);
endfunction : new

// pre_body task
task apb2spi_virt_seq_lib::pre_body();
	
  	m_apb_seq = apb_seq::type_id::create("m_apb_seq");
    m_spi_seq = spi_seq::type_id::create("m_spi_seq");
    
endtask : pre_body

// body task
task apb2spi_virt_seq_lib::body();
	
  //TODO TODO TODO
  
endtask : body

`endif // APB2SPI_VIRT_SEQ_LIB_SV
