//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_protocol_cov.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_PROTOCOL_COV_SV
`define APB_PROTOCOL_COV_SV

class apb_protocol_cov extends uvm_subscriber #(apb_uvc_item);
  
    // item
    apb_uvc_item c_item;

    // registration macro
    `uvm_component_utils(apb_protocol_cov)

    // coverage groups
    covergroup apb_protocol_cg;

        option.per_instance = 1;

        paddr_range_cov:                    coverpoint c_item.paddr{
	                                            bins low = {[0 : 32'hff]};
	                                            bins med = {[32'h100 : 32'h0fffffff]};
	                                            bins high = {[32'h10000000 : 32'hffffffff]};
                                            }
     
        pwrite_cov:                         coverpoint c_item.pwdata{
                                                bins WRITE  = {1'b1};
                                                bins READ   = {1'b0};
                                            }
                                            
                                            
        pstrb_cov:                          coverpoint c_item.pstrb{
                                            }
                                            
        wait_delay_cov:                     coverpoint c_item.wait_delay{
                                                bins ZERO       = {0};
	                                            bins NON_ZERO   = {[SHORT_WD_LOWER:MAX_WAIT_DELAY]};
                                            }     
                                  
        trans_delay_cov:                    coverpoint c_item.pwdata{
                                                bins ZERO       = {0};
	                                            bins NON_ZERO   = {[SHORT_TD_LOWER:MAX_TRANS_DELAY]};
                                            }
                              
        cross_pwrite_wait_delay_cov:        cross pwrite_cov, wait_delay_cov;  
        
        cross_pwrite_paddr_cov:             cross pwrite_cov, paddr_range_cov;     
        
  
    endgroup
    
    // constructor
    extern function new(string name, uvm_component parent);
  
    // analysis implementation port function
    extern virtual function void write(apb_uvc_item t);

endclass : apb_protocol_cov

// constructor
function apb_protocol_cov::new(string name, uvm_component parent);
    super.new(name, parent);
 
    // instanciranje cover grupe
    apb_protocol_cg = new();
    apb_protocol_cg.set_inst_name("apb_protocol_cg");
    
endfunction : new

// analysis implementation port function
function void apb_protocol_cov::write(apb_uvc_item t);

	c_item = t;
	apb_protocol_cg.sample();
	
endfunction : write

`endif // APB_PROTOCOL_COV_SV
