//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_write_reg_seq.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_WRITE_REG_SEQ_SV
`define APB2SPI_WRITE_REG_SEQ_SV

// this sequence realizes one write to specified register
 class apb2spi_write_reg_seq extends apb2spi_virt_seq_lib;
  
    // fields
    rand reg[31:0]      paddr;
    rand reg[31:0]      pwdata;
    rand reg[3 :0]      pstrb;   
    rand delay_type     trans_delay_kind;
    rand int            trans_delay;
    
    constraint trans_delay_c    {
                                    (trans_delay_kind == ZERO)      -> trans_delay == 0;
		                            (trans_delay_kind == SHORT)     -> trans_delay inside { [SHORT_TD_LOWER : SHORT_TD_UPP] };
                                    (trans_delay_kind == MEDIUM)    -> trans_delay inside { [MEDIUM_TD_LOWER : MEDIUM_TD_UPP] };
                                    (trans_delay_kind == LARGE)     -> trans_delay inside { [LARGE_TD_LOWER : LARGE_TD_UPP] };
		                            (trans_delay_kind == MAX)       -> trans_delay == MAX_TRANS_DELAY;
                                }
    
    
    // registration macro
    `uvm_object_utils_begin(apb2spi_write_reg_seq)
        `uvm_field_int(paddr, UVM_ALL_ON)
        `uvm_field_int(pwdata, UVM_ALL_ON)
        `uvm_field_int(pstrb, UVM_ALL_ON)
        `uvm_field_int(trans_delay, UVM_ALL_ON)
        `uvm_field_enum(delay_type, trans_delay_kind, UVM_DEFAULT)
    `uvm_object_utils_end
    
    // constructor
    extern function new(string name = "apb2spi_write_reg_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_write_reg_seq

// constructor
function apb2spi_write_reg_seq::new(string name = "apb2spi_write_reg_seq");
    super.new(name);
endfunction : new

// body task
task apb2spi_write_reg_seq::body();
	
    // write to specified register
    if(!m_apb_seq.randomize() with { 
                                        trans_delay_kind    == local::trans_delay_kind;
                                        trans_delay         == local::trans_delay;
      	                                paddr               == local::paddr;
      	                                pwrite              == 1'b1; 
      	                                pstrb               == local::pstrb;
      	                                pwdata              == local::pwdata; 
      	                         }) 
    begin
         `uvm_fatal(get_type_name(), "Failed to randomize.")
    end  
    
    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
 
endtask : body

`endif // APB2SPI_WRITE_REG_SEQ_SV
