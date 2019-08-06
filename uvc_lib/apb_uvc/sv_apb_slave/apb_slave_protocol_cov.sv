//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_slave_protocol_cov.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SLAVE_PROTOCOL_COV_SV
`define APB_SLAVE_PROTOCOL_COV_SV

class apb_slave_protocol_cov extends uvm_subscriber #(apb_uvc_item);
  
    // registration macro
    `uvm_component_utils(apb_slave_protocol_cov)

    // item koji se obradjuje
    apb_uvc_item c_item;
    
    /*
    // coverage groups
    covergroup training_uvc_cg;

        option.per_instance = 1;

        ADDR_CP: coverpoint c_item.paddr{
	        bins low[] = {[0 : 32'hff]} with (item % 4 == 0);
	        bins med = {[32'h100 : 32'h0fffffff]};
	        bins high = {[32'h10000000 : 32'hffffffff]};
	        ignore_bins addr0 = {32'h00000000};
        }

        coverpoint c_item.pwdata{
        } 


        coverpoint c_item.prdata{
        }

        PWRITE_CP:  coverpoint c_item.pwrite{
	        bins READ = {0};
	        bins WRITE = {1};
        }

        coverpoint c_item.wait_delay{
	        bins ZERO = {0};
	        bins SHORT = {[1:3]};
	        bins MEDIUM = {[4:6]};
	        bins LARGE = {[7:9]};
	        bins MAX_DELAY  = {10}; 
        }

        coverpoint c_item.trans_delay{
	        bins ZERO = {0};
	        bins SHORT = {[1:3]};
	        bins MEDIUM = {[4:6]};
	        bins LARGE = {[7:9]};
	        bins MAX_DELAY  = {10}; 
        }

 
        cross c_item.pwrite, c_item.trans_delay;

        PWR_CROSS_PADDR_ITEM:  cross c_item.pwrite, c_item.paddr;

        PWR_CROSS_PADDR_LAB:  cross PWRITE_CP, ADDR_CP;
 
    endgroup
    */
    
    // constructor
    extern function new(string name, uvm_component parent);
  
    // analysis implementation port function
    extern virtual function void write(apb_uvc_item t);

endclass : apb_slave_protocol_cov

// constructor
function apb_slave_protocol_cov::new(string name, uvm_component parent);
    super.new(name, parent);
    /*
    // instanciranje cover grupe
    training_uvc_cg = new();
    training_uvc_cg.set_inst_name("training_uvc_cg");
    */
endfunction : new

// analysis implementation port function
function void apb_slave_protocol_cov::write(apb_uvc_item t);
	c_item = t;
	/*training_uvc_cg.sample();*/
endfunction : write

`endif // APB_SLAVE_PROTOCOL_COV_SV
