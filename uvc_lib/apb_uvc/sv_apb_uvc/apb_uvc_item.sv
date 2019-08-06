//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_uvc_item.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_ITEM_SV
`define APB_UVC_ITEM_SV

class apb_uvc_item extends uvm_sequence_item;

    // enum item fields
    rand delay_type         wait_delay_kind;
    rand delay_type         trans_delay_kind;
    
    // item fields controlled by master driver
    rand bit[31:0]  paddr;   
    rand bit[31:0]  pwdata;  
    rand bit        pwrite;
    rand bit[3: 0]  pstrb;    
    rand int        trans_delay;
    
    // item fields controlled by slave driver   
    rand bit[31:0]  prdata;  
    rand int        wait_delay;    
    rand bit        pslverr;
   
    // registration macro
    `uvm_object_utils_begin(apb_uvc_item)
        `uvm_field_enum(delay_type, wait_delay_kind, UVM_DEFAULT)
        `uvm_field_enum(delay_type, trans_delay_kind, UVM_DEFAULT)
        `uvm_field_int(paddr, UVM_DEFAULT)
        `uvm_field_int(pwdata, UVM_DEFAULT)
        `uvm_field_int(pwrite, UVM_DEFAULT)
        `uvm_field_int(pstrb, UVM_DEFAULT)
        `uvm_field_int(trans_delay, UVM_DEFAULT)
        `uvm_field_int(prdata, UVM_DEFAULT)
        `uvm_field_int(wait_delay, UVM_DEFAULT)
        `uvm_field_int(pslverr, UVM_DEFAULT)
    `uvm_object_utils_end
  
    // constraints
    
    constraint delay_order_c    {  
                                    solve wait_delay_kind before wait_delay; 
                                    solve trans_delay_kind before trans_delay; 
                                }

    constraint trans_delay_c    {
                                    (trans_delay_kind == ZERO)      -> trans_delay == 0;
		                            (trans_delay_kind == SHORT)     -> trans_delay inside { [SHORT_TD_LOWER : SHORT_TD_UPP] };
                                    (trans_delay_kind == MEDIUM)    -> trans_delay inside { [MEDIUM_TD_LOWER : MEDIUM_TD_UPP] };
                                    (trans_delay_kind == LARGE)     -> trans_delay inside { [LARGE_TD_LOWER : LARGE_TD_UPP] };
		                            (trans_delay_kind == MAX)       -> trans_delay == MAX_TRANS_DELAY;
                                }
  
    constraint wait_delay_c     {
		                            (wait_delay_kind == ZERO)       -> wait_delay == 0;
		                            (wait_delay_kind == SHORT)      -> wait_delay inside { [SHORT_WD_LOWER : SHORT_WD_UPP] };
		                            (wait_delay_kind == MEDIUM)     -> wait_delay inside { [MEDIUM_WD_LOWER : MEDIUM_WD_UPP] };
		                            (wait_delay_kind == LARGE)      -> wait_delay inside { [LARGE_TD_LOWER : LARGE_TD_UPP] };
		                            (wait_delay_kind == MAX )       -> wait_delay == MAX_WAIT_DELAY;
                                }


    // constructor  
    extern function new(string name = "apb_uvc_item");
  
endclass : apb_uvc_item

// constructor
function apb_uvc_item::new(string name = "apb_uvc_item");
    super.new(name);
endfunction : new

`endif // APB_UVC_ITEM_SV
