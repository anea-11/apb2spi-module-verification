//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_seq_lib.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SLAVE_SEQ_LIB_SV
`define APB_SLAVE_SEQ_LIB_SV

class apb_slave_seq extends uvm_sequence #(apb_uvc_item);
  
    // registration macro
    `uvm_object_utils(apb_slave_seq)
  
    // sequencer pointer macro
    `uvm_declare_p_sequencer(apb_slave_sequencer)

/*  
    // fields
    rand bit[31:0] paddr_seq; 
    rand bit[31:0] pwdata_seq;
    rand transaction_type transaction_seq;
    rand int trans_delay_seq;
    rand int wait_delay_seq;

    // constraints
    constraint paddr_c {paddr_seq < 32'hFF; paddr_seq != 32'h0; paddr_seq % 4 == 0;}
*/  
    // constructor
    extern function new(string name = "apb_slave_seq");

    // body task
    extern virtual task body();

endclass : apb_slave_seq

// constructor
function apb_slave_seq::new(string name = "apb_slave_seq");
    super.new(name);
endfunction : new

// body task
task apb_slave_seq::body();
	
	forever begin
	    
      	req = apb_uvc_item::type_id::create( "req" );
        rsp = apb_uvc_item::type_id::create( "rsp" );
        
        // slave request - read from interface to learn what to do next
      	start_item( req );
        finish_item( req );
        
        // slave response 
        start_item( rsp );
      	if( !rsp.randomize() with { rsp.prdata <= 32'h0000FFFF; } ) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end  
      	
        rsp.pwrite = req.pwrite;
      	finish_item(rsp);
   end // forever begin
   
endtask : body

`endif // APB_SLAVE_SEQ_LIB_SV
