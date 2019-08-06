//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_slave_driver.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SLAVE_DRIVER_SV
`define APB_SLAVE_DRIVER_SV

class apb_slave_driver extends uvm_driver #(apb_uvc_item);
  
    // registration macro
    `uvm_component_utils(apb_slave_driver)
  
    // virtual interface reference
    virtual interface apb_interface m_vif;
  
    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
    // regular operation
    extern virtual task regular_operation();
    
    // init signals
    extern virtual task init_signals();
    
    // read signals
    extern virtual task read_signals(apb_uvc_item req);
    
    // drive signals
    extern virtual task drive_signals(apb_uvc_item rsp);
    
    // flags
    bit has_item = 0;
    
endclass : apb_slave_driver


// constructor
function apb_slave_driver::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

// build phase
function void apb_slave_driver::build_phase(uvm_phase phase);
    super.build_phase(phase);
endfunction : build_phase

// run phase
task apb_slave_driver::run_phase(uvm_phase phase);
    super.run_phase(phase);

    // wait until initial reset is asserted
    wait( m_vif.pi_rst_n === 1'b0 );
   
   forever begin
   
        init_signals();
        
        // wait until reset is de-asserted
        while( m_vif.pi_rst_n === 1'b0 )
            @( posedge m_vif.pi_clk );
        
        fork
            regular_operation();
        join_none
        
        // handle intermediate reset
        wait( m_vif.pi_rst_n === 1'b0 );
        disable fork;
        if(has_item == 1) begin
            has_item = 0;
            seq_item_port.item_done();
        end
        
    end // forever begin
endtask : run_phase

// init signals
task apb_slave_driver::init_signals();
    m_vif.prdata    = 32'b0;
    m_vif.pslverr   = 1'b0;
    m_vif.pready    = 1'b0;
endtask : init_signals

// regular operation
task apb_slave_driver::regular_operation();
    forever begin
    
        // read from apb bus
        has_item = 0;
        seq_item_port.get_next_item(req);
        has_item = 1;
        read_signals(req);
        seq_item_port.item_done();
        
        // drive signals on apb bus   
        has_item = 0; 
        seq_item_port.get_next_item(rsp);
        has_item = 1;
        drive_signals(rsp);
        seq_item_port.item_done();
    end
endtask : regular_operation

// read signals
task apb_slave_driver::read_signals(apb_uvc_item req);
    
    while(m_vif.penable === 1'b0)
        @( posedge m_vif.pi_clk );
        
    req.paddr   = m_vif.paddr;
    req.pwdata  = m_vif.pwdata;
    req.pwrite  = m_vif.pwrite;
    req.pstrb   = m_vif.pstrb;
    
endtask : read_signals

// drive signals
task apb_slave_driver::drive_signals(apb_uvc_item rsp);
    
    // print slave response 
    `uvm_info(get_type_name(), $sformatf("Slave response: \n%s", rsp.sprint()), UVM_HIGH)
    
    // create delay
        repeat(rsp.wait_delay) @( posedge m_vif.pi_clk );
    
    // if read transfer
    if(rsp.pwrite === 1'b0)
        m_vif.prdata = rsp.prdata;
        
    // end transfer
    m_vif.pslverr = rsp.pslverr;
    m_vif.pready = 1'b1;
    
    @(posedge m_vif.pi_clk);
    
    m_vif.pready = 1'b0;
    // driving rdata low is not necessary, but adds to the waveform clarity
    m_vif.prdata = 32'h00000000;    
     
endtask : drive_signals


`endif // APB_SLAVE_DRIVER_SV
