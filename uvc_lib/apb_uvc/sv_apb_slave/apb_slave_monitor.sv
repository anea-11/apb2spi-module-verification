//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_slave_monitor.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_SLAVE_MONITOR_SV
`define APB_SLAVE_MONITOR_SV

class apb_slave_monitor extends uvm_monitor;
  
    // registration macro
    `uvm_component_utils(apb_slave_monitor)
  
    // virtual interface reference
    virtual interface apb_interface m_vif;
  
    // monitor item
    apb_uvc_item m_item;
  
    // analysis port
    uvm_analysis_port #(apb_uvc_item) m_aport;
  
    // configuration reference
    apb_agent_cfg m_cfg;
  
    // fields
    int wait_delay;
    int trans_delay;

    // constructor
    extern function new(string name, uvm_component parent);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);

    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
    // collect item
    extern virtual task collect_item();
    
    // print item
    extern virtual function void print_item(apb_uvc_item item);

endclass : apb_slave_monitor


// constructor
function apb_slave_monitor::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new


// build phase
function void apb_slave_monitor::build_phase(uvm_phase phase);
  super.build_phase(phase);
  
  // create port
  m_aport = new("m_aport", this);
  
  // create item
  m_item = apb_uvc_item::type_id::create("m_item", this);

endfunction : build_phase


// run phase
task apb_slave_monitor::run_phase(uvm_phase phase);
    super.run_phase(phase);
  
    // wait until initial reset is asserted
    wait( m_vif.pi_rst_n === 1'b0 );
    
    forever begin
        
        // wait until reset is de-asserted
        while( m_vif.pi_rst_n === 1'b0 )
            @( posedge m_vif.pi_clk );
            
        fork 
            collect_item();
        join_none    
        
        // handle intermediate reset
        wait( m_vif.pi_rst_n === 1'b0 );
        disable fork;
        
    end // forever begin
    
endtask : run_phase


// collect item
task apb_slave_monitor::collect_item();  
   
    trans_delay = 0;
    wait_delay  = 0;

    forever begin    
        
        trans_delay = 0;
        wait_delay  = 0;
        
        while(m_vif.penable === 1'b0) begin
	        trans_delay = trans_delay + 1;
	        @(posedge m_vif.pi_clk);
        end

        while(m_vif.pready === 1'b0) begin
	        wait_delay = wait_delay + 1;
	        @(posedge m_vif.pi_clk);
        end
 
        // collect item 
        m_item.paddr        = m_vif.paddr;
        m_item.pwrite       = m_vif.pwrite;
        m_item.pstrb        = m_vif.pstrb;
        m_item.trans_delay  = trans_delay - 1;
        m_item.wait_delay   = wait_delay;
        if(m_vif.pwrite === 1'b1) begin
            m_item.pwdata   = m_vif.pwdata;
            m_item.prdata   = 32'b0;
        end
        else begin
            m_item.pwdata   = 32'b0;
            m_item.prdata   = m_vif.prdata;
        end
        
        // print collected item
        print_item(m_item);       
        
        // pass collected item to port listeners
    	m_aport.write(m_item);
	    
	    // wait for the end of transfer
        while(m_vif.penable === 1'b1)
            @(posedge m_vif.pi_clk);

    end // forever begin  
endtask : collect_item

// print item
function void apb_slave_monitor::print_item(apb_uvc_item item);
    `uvm_info(get_type_name(), $sformatf("Item collected: \n%s", item.sprint()), UVM_HIGH)
endfunction : print_item

`endif // APB_SLAVE_MONITOR_SV
