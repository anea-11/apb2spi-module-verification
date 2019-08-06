//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_dat_seq.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_DAT_SEQ_SV
`define APB2SPI_DAT_SEQ_SV

// this sequence checks SPIxSTAT0 flags while SPIEN==0
class apb2spi_dat_seq extends apb2spi_virt_seq_lib;
  
    // sequences
    apb_rmw_seq flush_tx_seq;
    
    // fields
    
    
    // registration macro
    `uvm_object_utils(apb2spi_dat_seq)

    // constructor
    extern function new(string name = "apb2spi_dat_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_dat_seq

// constructor
function apb2spi_dat_seq::new(string name = "apb2spi_dat_seq");
    super.new(name);
    flush_tx_seq = apb_rmw_seq::type_id::create("flush_tx_seq");
endfunction : new

// body task
task apb2spi_dat_seq::body();
	
    /*
    for(int i = 0; i<16; i++) begin
    
        // write to SPIxDAT register
      	if(!m_apb_seq.randomize() with { 
      	                            paddr   == SPIxDAT_ADDR;
      	                            pwrite  == 1'b1; 
      	                            pstrb   == 4'b1111; 
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end  
        m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
        
       
        // flush Tx buffer using apb read-modify-write sequence
        if(i == 10) begin
            if(!flush_tx_seq.randomize() with { 
      	                            paddr   == SPIxCTRL0_ADDR;
      	                            index   == 18;
      	                            new_val == 1'b1;
      	                         }) 
          	begin
                `uvm_fatal(get_type_name(), "Failed to randomize.")
          	end  
            flush_tx_seq.start(p_sequencer.apb_sequencer_inst, this);
        end
        
        
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
            
    end
    */
   
        // write to SPIxDAT register
      	if(!m_apb_seq.randomize() with { 
      	                            paddr   == SPIxDAT_ADDR;
      	                            pwrite  == 1'b1; 
      	                            pstrb   == 4'b1111; 
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end  
        m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
 
endtask : body

`endif // APB2SPI_DAT_SEQ_SV
