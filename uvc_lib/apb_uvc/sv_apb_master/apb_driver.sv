//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_driver.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_DRIVER_SV
`define APB_DRIVER_SV

class apb_driver extends uvm_driver #(apb_uvc_item);
  
    // registration macro
    `uvm_component_utils(apb_driver)
  
    // virtual interface reference
    virtual interface apb_interface m_vif;
  
    // request item
    REQ m_req;
   
    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
    // process item
    extern virtual task process_item(apb_uvc_item item);

    // init signals
    extern virtual task init_signals();
    
    // regular operation
    extern virtual task regular_operation();
    
    // flags
    bit has_item = 0;
    
endclass : apb_driver


// constructor
function apb_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

// run phase
task apb_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    // wait until initial reset is asserted
    wait ( m_vif.pi_rst_n === 1'b0 );
    
    forever begin
    
        init_signals();
        
        // wait until reset is de-asserted
        while( m_vif.pi_rst_n === 1'b0 )
            @( posedge m_vif.pi_clk );
        
        fork 
            regular_operation();
        join_none 
           
        // handle intermediate reset         
        wait ( m_vif.pi_rst_n === 1'b0 );
        disable fork;
        if(has_item == 1) begin
            has_item = 0;
            seq_item_port.item_done();
        end   
    end // forever begin
    
endtask : run_phase

// init signals
task apb_driver::init_signals();
    m_vif.paddr     = 32'b0;
    m_vif.psel      = 1'b0;
    m_vif.penable   = 1'b0;
    m_vif.pwrite    = 1'b0;
    m_vif.pwdata    = 32'b0;
    m_vif.pstrb     = 4'b0;
endtask : init_signals

// regular_operation
task apb_driver::regular_operation();
    forever begin
        has_item = 0;
        seq_item_port.get_next_item(m_req);
        has_item = 1;
        process_item(m_req);
        seq_item_port.item_done();
    end
endtask : regular_operation

// process item
task apb_driver::process_item(apb_uvc_item item);

    // print master request
    `uvm_info(get_type_name(), $sformatf("Master request: \n%s", item.sprint()), UVM_HIGH)
    
    // provide delay between transactions 
    repeat (item.trans_delay) @(posedge m_vif.pi_clk);
    
    // TODO aded to check something
    if(item.trans_delay == 0) @(posedge m_vif.pi_clk);
    
    // begin setup phase 
    m_vif.paddr     = item.paddr;
    m_vif.psel      = 1'b1;
    m_vif.pwrite    = item.pwrite;
    m_vif.pstrb     = item.pstrb;
    if(item.pwrite == 1'b1) begin
        m_vif.pwdata    = item.pwdata;
    end
    
    // begin access phase 
    @(posedge m_vif.pi_clk);
    m_vif.penable = 1'b1;
    
    // wait for slave response
    while(m_vif.pready == 1'b0) begin
        @(posedge m_vif.pi_clk);
    end
    
    // memorize slave response
    if(m_vif.pwrite === 1'b0) begin
        item.prdata = m_vif.prdata;
    end
    
    // finish transfer
    m_vif.penable   = 1'b0;
    m_vif.psel      = 1'b0;
 
endtask : process_item

`endif // APB_DRIVER_SV
