//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb2spi_regs.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB2SPI_REGS_SV
`define TEST_APB2SPI_REGS_SV

class test_apb2spi_regs extends test_apb2spi_base;
  
    // registration macro
    `uvm_component_utils(test_apb2spi_regs)
  
    // sequences
    apb2spi_read_regs_seq   all_regs_rst_vals_seq;
    apb2spi_rwr_regs_seq    rwr_properties_regs_seq;
    
    // constructor
    extern function new(string name, uvm_component parent);
    
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
endclass : test_apb2spi_regs 

// constructor
function test_apb2spi_regs::new(string name, uvm_component parent);
    super.new(name, parent);
    
    // create sequences
    all_regs_rst_vals_seq       = apb2spi_read_regs_seq::type_id::create("all_regs_rst_vals_seq", this);
    rwr_properties_regs_seq     = apb2spi_rwr_regs_seq::type_id::create("rwr_properties_regs_seq", this);
    
endfunction : new

// run phase
task test_apb2spi_regs::run_phase(uvm_phase phase);
    super.run_phase(phase);

    // raise objections
    uvm_test_done.raise_objection(this, get_type_name());    
    `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
    
    // initial reset
    rst_interface.rst_n <= 1'b0;
    #(500ns);
    rst_interface.rst_n <= 1'b1;
    
    // covergroup related to register test should be sampled   
    apb2spi_env_top.config_cov.collect_regs_test_coverage = 1'b1;
       
    // read rst vals from all regs   
    all_regs_rst_vals_seq.start(apb2spi_env_top.v_sequencer);
    
    // check regs rw properties 
    rwr_properties_regs_seq.N = 1000;
    rwr_properties_regs_seq.start(apb2spi_env_top.v_sequencer);
    
    // covergroup related to register test should no longer be sampled   
    apb2spi_env_top.config_cov.collect_regs_test_coverage = 1'b0;
    
    // drop objections
    uvm_test_done.drop_objection(this, get_type_name());    
    `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW) 
    
endtask : run_phase

`endif // TEST_APB2SPI_REGS_SV
