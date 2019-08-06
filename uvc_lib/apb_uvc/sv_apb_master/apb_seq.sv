//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_seq.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SEQ_SV
`define APB_SEQ_SV

class apb_seq extends uvm_sequence #(apb_uvc_item);
  
    // fields
    rand bit[31:0]      paddr;
    rand bit            pwrite;
    rand bit[ 3:0]      pstrb;
    rand bit[31:0]      pwdata;
    rand int            trans_delay;
    rand delay_type     trans_delay_kind;

    // registration macro
    `uvm_object_utils_begin(apb_seq)
        `uvm_field_int(paddr, UVM_DEFAULT)
        `uvm_field_int(pwrite, UVM_DEFAULT)
        `uvm_field_int(pstrb, UVM_DEFAULT)
        `uvm_field_int(pwdata, UVM_DEFAULT)
        `uvm_field_int(trans_delay, UVM_DEFAULT)        
        `uvm_field_enum(delay_type, trans_delay_kind, UVM_DEFAULT)
    `uvm_object_utils_end
    
    constraint trans_delay_c    {
                                    (trans_delay_kind == ZERO)      -> trans_delay == 0;
		                            (trans_delay_kind == SHORT)     -> trans_delay inside { [SHORT_TD_LOWER : SHORT_TD_UPP] };
                                    (trans_delay_kind == MEDIUM)    -> trans_delay inside { [MEDIUM_TD_LOWER : MEDIUM_TD_UPP] };
                                    (trans_delay_kind == LARGE)     -> trans_delay inside { [LARGE_TD_LOWER : LARGE_TD_UPP] };
		                            (trans_delay_kind == MAX)       -> trans_delay == MAX_TRANS_DELAY;
                                }
    
    // sequencer pointer macro
    `uvm_declare_p_sequencer(apb_sequencer)
  
    // constructor
    extern function new(string name = "apb_seq");

    // body task
    extern virtual task body();

endclass : apb_seq

// constructor
function apb_seq::new(string name = "apb_seq");
    super.new(name);
endfunction : new

// body task
task apb_seq::body();
	
  	req = apb_uvc_item::type_id::create("req");
  
  	start_item(req);
 
  	if(!req.randomize() with { 
  	                            trans_delay == local::trans_delay;
  	                            trans_delay_kind  ==  local::trans_delay_kind;
  	                            paddr       == local::paddr;
  	                            pwrite      == local::pwrite; 
  	                            pstrb       == local::pstrb;
  	                            pwdata      == local::pwdata;  
  	                         }) 
  	begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
  
  	finish_item(req);
   
endtask : body

`endif // APB_SEQ_SV
