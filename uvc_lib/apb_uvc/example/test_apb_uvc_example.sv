//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb_uvc_example.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB_UVC_EXAMPLE_SV
`define TEST_APB_UVC_EXAMPLE_SV

// example test
class test_apb_uvc_example extends test_apb_uvc_base;
  
    // registration macro
    `uvm_component_utils(test_apb_uvc_example)
  
    // fields
    int         num_of_trans    = 30;
    bit[31:0]   paddr_test      = 32'b0;
    
    // sequences
    apb_seq         master_seq;
    apb_slave_seq   slave_seq;
    apb_rmw_seq     master_rmw_seq;
    
    // constructor
    extern function new(string name, uvm_component parent);
    
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
    // build phase
    extern virtual function void build_phase(uvm_phase phase);
    
    // set default configuration
    extern function void set_default_configuration();
  
endclass : test_apb_uvc_example

// constructor
function test_apb_uvc_example::new(string name, uvm_component parent);
    super.new(name, parent);
endfunction : new

 // build phase
function void test_apb_uvc_example::build_phase(uvm_phase phase);
	super.build_phase(phase);
endfunction: build_phase

// run phase
task test_apb_uvc_example::run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    // create master sequence
    master_seq = apb_seq::type_id::create("master_seq", this);
    
    // create master rmw sequence
    master_rmw_seq = apb_rmw_seq::type_id::create("master_rmw_seq", this);
    
    // create slave sequence
    slave_seq = apb_slave_seq::type_id::create("slave_seq", this);
    
    // start test
    fork
    
        // start master sequences
        master_seq_block : begin
            // raise objection
            uvm_test_done.raise_objection(this, get_type_name());    
            `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
            
            /*************** PRVI ZADATAK - SAMO ADRESE RASTUCE *********************
            for ( int i = 0; i < num_of_trans; i++ ) begin
                if( !master_seq.randomize() with{ paddr == paddr_test; }) begin
                    `uvm_fatal(get_type_name(), "Failed to randomize.")
                end
                master_seq.start( apb_uvc_env_top.master_agent.m_sequencer );
                paddr_test = paddr_test + 4;
            end
            */
            
            for ( int i = 0; i < num_of_trans; i++ ) begin
                if( !master_rmw_seq.randomize() with{ paddr == paddr_test; } ) begin
                    `uvm_fatal(get_type_name(), "Failed to randomize.")
                end
                master_rmw_seq.start( apb_uvc_env_top.master_agent.m_sequencer );
                paddr_test = paddr_test + 4;
            end
            
            
            // drop objection
            uvm_test_done.drop_objection(this, get_type_name());    
            `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW) 
        end
        
        // start slave sequence
        slave_seq_block : begin
            slave_seq.start( apb_uvc_env_top.slave_agent.m_sequencer );
        end
    join_any
    
endtask : run_phase

// set default configuration
function void test_apb_uvc_example::set_default_configuration();
  super.set_default_configuration();
  
  // redefine configuration
 
endfunction : set_default_configuration

`endif // TEST_APB_UVC_EXAMPLE_SV
