//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_conf_seq.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_CONF_SEQ_SV
`define APB2SPI_CONF_SEQ_SV

// configuration sequence
class apb2spi_conf_seq extends apb2spi_virt_seq_lib;
  
    // const fields
    bit[31:0]       SPIxCTRL0_BASE_CONF_MASK = 32'h00010002; // enchanced buffering, slave mode
    bit[31:0]       SPIxCTRL1_BASE_CONF_MASK = 32'h00000000; 
    
    // rand fields - SPIxCTRL1
    rand bit[2:0]        SPIxCTRL1_SSINSEL;
    rand bit[7:0]        SPIxCTRL1_SSEN;
    
    // rand fields - SPIxCTRL0
    rand bit[4:0]        SPIxCTRL0_DSIZ;
    rand bit             SPIxCTRL0_DORD;
    rand bit[1:0]        SPIxCTRL0_DIR;
    rand bit             SPIxCTRL0_SPIEN;   
    
    // constraints
    
    constraint spi_ctrl1_ssen_c     {  
                                        $countones(SPIxCTRL1_SSEN) == 1;
                                    }
    
    constraint spi_ctrl1_ssinsel_c  {  
                                        (SPIxCTRL1_SSEN == 8'b00000001) ->  SPIxCTRL1_SSINSEL == 3'b000;
                                        (SPIxCTRL1_SSEN == 8'b00000010) ->  SPIxCTRL1_SSINSEL == 3'b001;
                                        (SPIxCTRL1_SSEN == 8'b00000100) ->  SPIxCTRL1_SSINSEL == 3'b010;
                                        (SPIxCTRL1_SSEN == 8'b00001000) ->  SPIxCTRL1_SSINSEL == 3'b011;
                                        (SPIxCTRL1_SSEN == 8'b00010000) ->  SPIxCTRL1_SSINSEL == 3'b100;
                                        (SPIxCTRL1_SSEN == 8'b00100000) ->  SPIxCTRL1_SSINSEL == 3'b101;
                                        (SPIxCTRL1_SSEN == 8'b01000000) ->  SPIxCTRL1_SSINSEL == 3'b110;
                                        (SPIxCTRL1_SSEN == 8'b10000000) ->  SPIxCTRL1_SSINSEL == 3'b111;     
                                    }

     // registration macro
    `uvm_object_utils_begin(apb2spi_conf_seq)
        `uvm_field_int(SPIxCTRL1_BASE_CONF_MASK, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL0_BASE_CONF_MASK, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL1_SSINSEL, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL1_SSEN, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL0_DSIZ, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL0_DORD, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL0_DIR, UVM_DEFAULT)
        `uvm_field_int(SPIxCTRL0_SPIEN, UVM_DEFAULT)
    `uvm_object_utils_end

    // constructor
    extern function new(string name = "apb2spi_conf_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_conf_seq

// constructor
function apb2spi_conf_seq::new(string name = "apb2spi_conf_seq");
    super.new(name);
endfunction : new

// body task
task apb2spi_conf_seq::body();

        // prepare SPIxCTRL1 conf value
        SPIxCTRL1_CONF          = SPIxCTRL1_BASE_CONF_MASK;
        SPIxCTRL1_CONF[11:9]    = SPIxCTRL1_SSINSEL;
        SPIxCTRL1_CONF[7:0]     = SPIxCTRL1_SSEN;
        
        // configure SPIxCTRL1 
        if(!m_apb_seq.randomize() with  { 
  	                                        paddr   == SPIxCTRL1_ADDR;
  	                                        pwdata  == SPIxCTRL1_CONF;
  	                                        pstrb   == 4'b1111;
  	                                        pwrite  == 1'b1;
  	                                    }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
        
        // prepare SPIxCTRL0 conf value
        SPIxCTRL0_CONF          = SPIxCTRL0_BASE_CONF_MASK;
        SPIxCTRL0_CONF[12:8]    = SPIxCTRL0_DSIZ;
        SPIxCTRL0_CONF[6]       = SPIxCTRL0_DORD;
        SPIxCTRL0_CONF[5:4]     = SPIxCTRL0_DIR;
        SPIxCTRL0_CONF[0]       = SPIxCTRL0_SPIEN;
        
        // configure SPIxCTRL0 
        if(!m_apb_seq.randomize() with  { 
  	                                        paddr   == SPIxCTRL0_ADDR;
  	                                        pwdata  == SPIxCTRL0_CONF;
  	                                        pstrb   == 4'b1111;
  	                                        pwrite  == 1'b1;
  	                                    }) 
  	    begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	    end  
  	    
  	    m_apb_seq.start(p_sequencer.apb_sequencer_inst, this);
       
endtask : body

`endif // APB2SPI_CONF_SEQ_SV
