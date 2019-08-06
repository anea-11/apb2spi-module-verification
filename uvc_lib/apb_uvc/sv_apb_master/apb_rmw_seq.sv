//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_rmw_seq.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_RMW_SEQ_SV
`define APB_RMW_SEQ_SV

class apb_rmw_seq extends apb_seq;
  
    // fields
    bit[31:0] rdata;
    
    // rand fields
    rand bit[4:0]   index;
    rand bit        new_val;    
    
    // registration macro
    `uvm_object_utils(apb_rmw_seq)
  
    // constructor
    extern function new(string name = "apb_rmw_seq");

    // body task
    extern virtual task body();

endclass : apb_rmw_seq

// constructor
function apb_rmw_seq::new(string name = "apb_rmw_seq");
    super.new(name);
endfunction : new

// body task
task apb_rmw_seq::body();
	
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
    
    // modify
    rdata = req.prdata;
    rdata[index] = new_val;
    
    // write
    req = apb_uvc_item::type_id::create("req");
  
  	start_item(req);
    
  	if(!req.randomize() with { 
  	                            paddr   == local::paddr;
  	                            pwrite  == 1'b1;
  	                            pwdata  == local::rdata; 
  	                         })   	                         
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
  
  	finish_item(req);
  	
endtask : body

`endif // APB_RMW_SEQ_SV
