//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_read_regs_seq.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_READ_REGS_SEQ_SV
`define APB2SPI_READ_REGS_SEQ_SV

// this sequence reads rst vals from SPIxCAP, SPIxCTRL0, SPIxCTRL1, SPIxSTAT0, SPIxDAT
class apb2spi_read_regs_seq extends apb2spi_virt_seq_lib;
  
    // registration macro
    `uvm_object_utils(apb2spi_read_regs_seq)

    // constructor
    extern function new(string name = "apb2spi_read_regs_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_read_regs_seq

// constructor
function apb2spi_read_regs_seq::new(string name = "apb2spi_read_regs_seq");
    super.new(name);
endfunction : new

// body task
task apb2spi_read_regs_seq::body();
	
    // read from SPIxCAP register
  	if(!m_apb_seq.randomize() with { 
  	                            paddr   == SPIxCAP_ADDR;
  	                            pwrite  == 1'b0; 
  	                            pstrb   == 4'b0000; 
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
  
  
    // read from SPIxCTRL0 register
  	if(!m_apb_seq.randomize() with { 
  	                            paddr   == SPIxCTRL0_ADDR;
  	                            pwrite  == 1'b0; 
  	                            pstrb   == 4'b0000; 
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
  
  
    // read from SPIxCTRL1 register
  	if(!m_apb_seq.randomize() with { 
  	                            paddr   == SPIxCTRL1_ADDR;
  	                            pwrite  == 1'b0; 
  	                            pstrb   == 4'b0000; 
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
    
    
    // read from SPIxSTAT0 register
  	if(!m_apb_seq.randomize() with { 
  	                            paddr   == SPIxSTAT0_ADDR;
  	                            pwrite  == 1'b0; 
  	                            pstrb   == 4'b0000; 
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
    
    
    // read from SPIxDAT register
  	if(!m_apb_seq.randomize() with { 
  	                            paddr   == SPIxDAT_ADDR;
  	                            pwrite  == 1'b0; 
  	                            pstrb   == 4'b0000; 
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
    
endtask : body

`endif // APB2SPI_READ_REGS_SEQ_SV
