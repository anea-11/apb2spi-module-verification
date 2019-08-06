//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_rwr_regs_seq.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_RWR_REGS_SEQ_SV
`define APB2SPI_RWR_REGS_SEQ_SV

// this sequence is supposed to be executed after apb2spi_read_regs_seq (after rst vals have been checked) 
// this sequence attempts to change register values in order to verify their RW/RO properties
class apb2spi_rwr_regs_seq extends apb2spi_virt_seq_lib;
  
    // fields
    int N = 10000;
    
    // wr_rd_sequence
    apb2spi_wr_rd_reg_seq m_seq;
    // read reg sequence
    apb2spi_read_reg_seq    read_reg_seq;
    
    // registration macro
    `uvm_object_utils(apb2spi_rwr_regs_seq)

    // constructor
    extern function new(string name = "apb2spi_rwr_regs_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_rwr_regs_seq

// constructor
function apb2spi_rwr_regs_seq::new(string name = "apb2spi_rwr_regs_seq");
    super.new(name);
    
    // create sequences
    m_seq           = apb2spi_wr_rd_reg_seq::type_id::create("m_seq");
    read_reg_seq    = apb2spi_read_reg_seq::type_id::create("read_reg_seq");
    
endfunction : new

// body task
task apb2spi_rwr_regs_seq::body();

    // check SPIxCAP read-only property
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr   == SPIxCAP_ADDR;
  	                            if(i == 0){ 
  	                                pwdata == 32'hfff830fe;
  	                                pstrb  == 4'b1111;
  	                            }
  	                            if(i%10 == 0){
  	                                pwdata == 32'hfff830fe;
  	                            }
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // check SPIxCTRL0 rw property while SPIEN == 0
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr   == SPIxCTRL0_ADDR;
  	                            pwdata%2 == 0;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // check SPIxCTRL1 rw property while SPIEN == 0;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr   == SPIxCTRL1_ADDR;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // check SPIxSTAT0 rw property while SPIEN == 0;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr   == SPIxSTAT0_ADDR;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // read initial value from empty Rx while SPIEN == 0;
    if(!read_reg_seq.randomize() with { 
      	                            paddr   == SPIxDAT_ADDR;
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end  
      	    
    read_reg_seq.start(p_sequencer, this);
    
    // set SPIEN = 1
    if(!m_seq.randomize() with { 
  	                            paddr   == SPIxCTRL0_ADDR;
  	                            pwdata  == 32'h00000001;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    
    // read initial value from empty Rx while SPIEN == 1;
    if(!read_reg_seq.randomize() with { 
      	                            paddr   == SPIxDAT_ADDR;
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end  
      	    
    read_reg_seq.start(p_sequencer, this);
    
    // check SPIxCTRL0 rw property while SPIEN == 1;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr       == SPIxCTRL0_ADDR;
  	                            pwdata%2    == 1;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // check SPIxCTRL1 rw property while SPIEN == 1;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr       == SPIxCTRL1_ADDR;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // check SPIxSTAT0 rw property while SPIEN == 1;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr       == SPIxSTAT0_ADDR;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
   	    
    // check SPIxCAP rw property while SPIEN == 1;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr       == SPIxCAP_ADDR;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // return SPIEN to 0
    if(!m_seq.randomize() with { 
  	                            paddr       == SPIxCTRL0_ADDR;
  	                            pwdata%2    == 0;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	m_seq.start(p_sequencer.apb_sequencer_inst, this);

     // check SPIxCTRL0 rw property while SPIEN == 0;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr   == SPIxCTRL0_ADDR;
  	                            pwdata%2 == 0;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end
    
    // check SPIxCTRL1 rw property while SPIEN == 0;
    for(int i = 0; i < N; i++) begin
        if(!m_seq.randomize() with { 
  	                            paddr   == SPIxCTRL1_ADDR;
  	                         }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_seq.start(p_sequencer.apb_sequencer_inst, this);
    end    
  
endtask : body

`endif // APB2SPI_RWR_REGS_SEQ_SV
