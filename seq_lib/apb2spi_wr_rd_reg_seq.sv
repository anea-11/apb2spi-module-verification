//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_wr_rd_reg_seq.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_WR_RD_REG_SEQ_SV
`define APB2SPI_WR_RD_REG_SEQ_SV

class apb2spi_wr_rd_reg_seq extends apb_seq;
  
    // fields 
    rand bit[31:0] paddr;
    rand bit[ 3:0] pstrb;
    rand bit[31:0] pwdata;
    
    // registration macro
    `uvm_object_utils_begin(apb2spi_wr_rd_reg_seq)
        `uvm_field_int(paddr, UVM_DEFAULT)
        `uvm_field_int(pstrb, UVM_DEFAULT)
        `uvm_field_int(pwdata, UVM_DEFAULT)
    `uvm_object_utils_end

    // constructor
    extern function new(string name = "apb2spi_wr_rd_reg_seq");

    // body task
    extern virtual task body();

endclass : apb2spi_wr_rd_reg_seq

// constructor
function apb2spi_wr_rd_reg_seq::new(string name = "apb2spi_wr_rd_reg_seq");
    super.new(name);
endfunction : new

// body task
task apb2spi_wr_rd_reg_seq::body();

    // attemp writing
    req = apb_uvc_item::type_id::create("req");
  
  	start_item(req);
 
  	if(!req.randomize() with { 
  	                            paddr   == local::paddr;
  	                            pwrite  == 1'b1; 
  	                            pstrb   == local::pstrb;
  	                            pwdata  == local::pwdata;  
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
  
  	finish_item(req);
    
    
    // read
    req = apb_uvc_item::type_id::create("req");
  
  	start_item(req);
 
  	if(!req.randomize() with { 
  	                            paddr   == local::paddr;
  	                            pwrite  == 1'b0; 
  	                            pstrb   == 4'b0000;  
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
  
  	finish_item(req);
    
endtask : body

`endif // APB2SPI_WR_RD_REG_SEQ_SV
