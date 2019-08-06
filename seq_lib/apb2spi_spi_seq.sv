//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_spi_seq.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_SEQ_SEQ_SV
`define APB2SPI_SEQ_SEQ_SV

class apb2spi_spi_seq extends apb2spi_virt_seq_lib;
  
    // fields
    rand bit    data_order;
    rand int    data_size;
    rand int    clock_gap;
    
    constraint clock_gap_c  {
                                clock_gap inside { [MIN_CLOCK_GAP : MAX_CLOCK_GAP] };
                            }
    
    // registration macro
    `uvm_object_utils_begin(apb2spi_spi_seq)
        `uvm_field_int(data_size, UVM_ALL_ON)
        `uvm_field_int(data_order, UVM_ALL_ON)
    `uvm_object_utils_end
    
    // constructor
    extern function new(string name = "apb2spi_spi_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_spi_seq

// constructor
function apb2spi_spi_seq::new(string name = "apb2spi_spi_seq");
    super.new(name);
endfunction : new

// body task
task apb2spi_spi_seq::body();

    // start one SPI transaction
    if(!m_spi_seq.randomize() with { 
                                        clock_gap   == local::clock_gap;
      	                                data_size   == local::data_size; 
      	                                data_order  == local::data_order;
                                    }) 
    begin
         `uvm_fatal(get_type_name(), "Failed to randomize.")
    end  
      	    
    m_spi_seq.start(p_sequencer.spi_sequencer_inst, this);
    
endtask : body

`endif // APB2SPI_SEQ_SEQ_SV
