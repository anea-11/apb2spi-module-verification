//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb2spi_slv_general.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB2SPI_SLV_GENERAL_SV
`define TEST_APB2SPI_SLV_GENERAL_SV

class test_apb2spi_slv_general extends test_apb2spi_base;
  
    // registration macro
    `uvm_component_utils(test_apb2spi_slv_general)
  
    // fields
    data_order_type DORD_TEST; 
    int             DSIZ_TEST; 
    int             SS_sel_TEST = 0;
    int             SPI_TRANS_NUM = 50;
    int             NUM_OF_TRANS_BASIC = 20;
    int             RECONF_DSIZ;
    
    // sequences
    apb2spi_conf_seq        conf_seq;
    apb2spi_read_reg_seq    read_reg_seq;
    apb2spi_write_reg_seq   write_reg_seq; 
    apb2spi_spi_seq         spi_simple_seq;  
     
    // constructor
    extern function new(string name, uvm_component parent);
    
    // run phase
    extern virtual task run_phase(uvm_phase phase);
    
    // configure SPI module without enabling it
    extern virtual task configure(data_order_type _DORD, int _DSIZ, int _SS_sel, int _DIR);
    
    // configure SPI module and enable it
    extern virtual task configure_en(data_order_type _DORD, int _DSIZ, int _SS_sel, int _DIR);
    
    // general test in transmit-only mode
    extern virtual task general_transmit_only();
    
    // general test in receive-only mode
    extern virtual task general_receive_only();
    
endclass : test_apb2spi_slv_general 

// constructor
function test_apb2spi_slv_general::new(string name, uvm_component parent);
    super.new(name, parent);
    
    // create sequences
    conf_seq                    = apb2spi_conf_seq::type_id::create("conf_seq", this);
    read_reg_seq                = apb2spi_read_reg_seq::type_id::create("read_reg_seq", this);
    write_reg_seq               = apb2spi_write_reg_seq::type_id::create("write_reg_seq", this);
    spi_simple_seq              = apb2spi_spi_seq::type_id::create("spi_simple_seq", this);
   
endfunction : new

// run phase
task test_apb2spi_slv_general::run_phase(uvm_phase phase);
    super.run_phase(phase);
    
    // raise objections
    uvm_test_done.raise_objection(this, get_type_name());    
    `uvm_info(get_type_name(), "TEST STARTED", UVM_LOW)
    
    rst_interface.rst_n <= 1'b0;
    #(500ns);
    rst_interface.rst_n <= 1'b1;
    
    general_transmit_only();
    
    general_receive_only();
    
    // drop objections
    uvm_test_done.drop_objection(this, get_type_name());    
    `uvm_info(get_type_name(), "TEST FINISHED", UVM_LOW) 
    
endtask : run_phase

task test_apb2spi_slv_general::general_receive_only();

    DORD_TEST   = $urandom_range(1,0);
    DSIZ_TEST   = $urandom_range(32,5);
    SS_sel_TEST = $urandom_range(7,0);
    
    // configure SPI module without enabling it
    configure(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b01);
    
    // initial status check
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
   
   
    // reconfigure SPI module without changing any SPIxCTRL0 fields
    configure(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b01); 

    // check status after reconfiguration
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
 
    RECONF_DSIZ = $urandom_range(32,4);
    while(RECONF_DSIZ == DSIZ_TEST) RECONF_DSIZ = $urandom_range(32,4);
    
    // reconfigure and enable SPI module and change DSIZ field
    configure_en(DORD_TEST, RECONF_DSIZ, SS_sel_TEST, 2'b01); 
    
    for(int i = 0; i < 10; i++) begin
    
        // write data to Rx buffer
        if(!spi_simple_seq.randomize() with { 
                                            clock_gap   == 3;
                                            data_size   == RECONF_DSIZ;
                                            data_order  == DORD_TEST;
              	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end
 
    // reconfigure SPI module in a way that ENCBUF field changes it's value
    if(!write_reg_seq.randomize() with { 
                                    paddr       == SPIxCTRL0_ADDR;
                                    pwdata      == 32'h00000000;
                                    pstrb       == 4'b0100;
                                }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    write_reg_seq.start(apb2spi_env_top.v_sequencer);


    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // reestablish configuration from the beginning
    configure_en(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b01); 
    
    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // reconfigure SPI module in a way that DSIZ field == 4 
    // 4 is an arbitrary value
    if(!write_reg_seq.randomize() with { 
                                    paddr       == SPIxCTRL0_ADDR;
                                    pwdata      == 32'h00000400;
                                    pstrb       == 4'b0010;
                                }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    write_reg_seq.start(apb2spi_env_top.v_sequencer);
    
     // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
        
    // fill Rx buffer
    for(int i = 0; i < 10; i++) begin
    
        // write data to Rx buffer
        if(!spi_simple_seq.randomize() with { 
                                            clock_gap   == 3;
                                            data_size   == 5;
                                            data_order  == DORD_TEST;
              	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end
    
    
    // reconfigure SPI module in a way that DPACK field changes it's value
    if(!write_reg_seq.randomize() with { 
                                    paddr       == SPIxCTRL0_ADDR;
                                    pwdata      == 32'h00002400;
                                    pstrb       == 4'b0010;
                                }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    write_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // reestablish configuration from the beginning
    configure_en(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b01); 
    
    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // fill Rx buffer
    for(int i = 0; i < 10; i++) begin
    
        // write data to Rx buffer
        if(!spi_simple_seq.randomize() with { 
                                            clock_gap   == 3;
                                            data_size   == DSIZ_TEST;
                                            data_order  == DORD_TEST;
              	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end
        
        if(i == 9) begin
            apb2spi_env_top.m_scoreboard.rst = 1'b1;
            rst_interface.rst_n <= 1'b0;
            #(500ns);
            rst_interface.rst_n <= 1'b1;
        end
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end
 
    // enable spi module
    configure_en(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10); 
    
    // check status after enabling module
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // disable spi module
    configure_en(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10);    
    
    // check status after disabling module
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);   
    
    // issue reset in the middle of an ongoing SPI transaction
    fork
        read_block: begin
                        if(!spi_simple_seq.randomize() with { 
                                            clock_gap   == 3;
                                            data_size   == DSIZ_TEST;
                                            data_order  == DORD_TEST;
              	            }) 
                        begin
                            `uvm_fatal(get_type_name(), "Failed to randomize.")
                        end
                    end
                    
        rst_block:  begin
                        apb2spi_env_top.m_scoreboard.rst = 1'b1;
                        rst_interface.rst_n <= 1'b0;
                        #(500ns);
                        rst_interface.rst_n <= 1'b1;
                    end
    join
        
    // check status after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // check CTRL0 after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxCTRL0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // check CTRL1 after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxCTRL1_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
   
    // check CAP after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxCAP_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);     
   
endtask : general_receive_only


task test_apb2spi_slv_general::general_transmit_only();

    DORD_TEST   = $urandom_range(1,0);
    DSIZ_TEST   = $urandom_range(32,5);
    SS_sel_TEST = $urandom_range(7,0);
    
    // configure SPI module without enabling it
    configure(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10);
    
    // initial status check
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    
    for(int i = 0; i < 10; i++) begin
    
        // write data to Tx buffer
        if(!write_reg_seq.randomize() with { 
                                       paddr        == SPIxDAT_ADDR;
                                       pstrb        == 4'b1111;
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end 
        write_reg_seq.start(apb2spi_env_top.v_sequencer);
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end
    
    // reconfigure SPI module without changing any SPIxCTRL0 fields
    configure(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10); 

    // check status after reconfiguration
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    RECONF_DSIZ = $urandom_range(32,4);
    while(RECONF_DSIZ == DSIZ_TEST) RECONF_DSIZ = $urandom_range(32,4);
    
    
    // reconfigure SPI module and change DSIZ field
    configure(DORD_TEST, RECONF_DSIZ, SS_sel_TEST, 2'b10); 
    
    for(int i = 0; i < 10; i++) begin
    
        // write data to Tx buffer
        if(!write_reg_seq.randomize() with { 
                                       paddr        == SPIxDAT_ADDR;
                                       pstrb        == 4'b1111;
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end 
        write_reg_seq.start(apb2spi_env_top.v_sequencer);
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end

    // reconfigure SPI module in a way that ENCBUF field changes it's value
    if(!write_reg_seq.randomize() with { 
                                    paddr       == SPIxCTRL0_ADDR;
                                    pwdata      == 32'h00000000;
                                    pstrb       == 4'b0100;
                                }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    write_reg_seq.start(apb2spi_env_top.v_sequencer);

    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // reestablish configuration from the beginning
    configure(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10); 
    
    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
   
    // reconfigure SPI module in a way that DSIZ field == 4 
    // 4 is an arbitrary value
    if(!write_reg_seq.randomize() with { 
                                    paddr       == SPIxCTRL0_ADDR;
                                    pwdata      == 32'h00000400;
                                    pstrb       == 4'b0010;
                                }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    write_reg_seq.start(apb2spi_env_top.v_sequencer);
    
     // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
 
    // fill tx buffer
    for(int i = 0; i < 10; i++) begin
    
        // write data to Tx buffer
        if(!write_reg_seq.randomize() with { 
                                       paddr        == SPIxDAT_ADDR;
                                       pstrb        == 4'b1111;
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end 
        write_reg_seq.start(apb2spi_env_top.v_sequencer);
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end
       
    // reconfigure SPI module in a way that DPACK field changes it's value
    if(!write_reg_seq.randomize() with { 
                                    paddr       == SPIxCTRL0_ADDR;
                                    pwdata      == 32'h00002400;
                                    pstrb       == 4'b0010;
                                }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    write_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // reestablish configuration from the beginning
    configure(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10); 
    
    // check status after previous change
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);

    // fill tx buffer
    for(int i = 0; i < 10; i++) begin
    
        // write data to Tx buffer
        if(!write_reg_seq.randomize() with { 
                                       paddr        == SPIxDAT_ADDR;
                                       pstrb        == 4'b1111;
      	                         }) 
      	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
      	end 
        write_reg_seq.start(apb2spi_env_top.v_sequencer);
        
        // intermediate rst
        if(i == 9) begin
            apb2spi_env_top.m_scoreboard.rst = 1'b1;
            rst_interface.rst_n <= 1'b0;
            #(500ns);
            rst_interface.rst_n <= 1'b1;
        end
        
        // check status after each writing
        if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
        begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
        end 
        read_reg_seq.start(apb2spi_env_top.v_sequencer);
        
    end

    // enable spi module
    configure_en(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10); 
    
    // check status after enabling module
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // disable spi module
    configure_en(DORD_TEST, DSIZ_TEST, SS_sel_TEST, 2'b10);    
    
    // check status after disabling module
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);  
    
    // issue reset in the middle of an ongoing APB transaction
    fork
        read_block: begin
                        if(!read_reg_seq.randomize() with { 
                                                 trans_delay == 0;
                                                 paddr        == SPIxSTAT0_ADDR;
                        }) 
                        begin
                            `uvm_fatal(get_type_name(), "Failed to randomize.")
                        end 
                        read_reg_seq.start(apb2spi_env_top.v_sequencer);
                    end
                    
        rst_block:  begin
                        apb2spi_env_top.m_scoreboard.rst = 1'b1;
                        rst_interface.rst_n <= 1'b0;
                        #(500ns);
                        rst_interface.rst_n <= 1'b1;
                    end
    join
    
    // check status after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // check CTRL0 after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxCTRL0_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    // check CTRL1 after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxCTRL1_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
   
    // check CAP after reset
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxCAP_ADDR;
    }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);     
    
endtask : general_transmit_only


task test_apb2spi_slv_general::configure(data_order_type _DORD, int _DSIZ, int _SS_sel, int _DIR);

    bit DORD;
    bit[4:0] DSIZ;
    bit[7:0] SSEN;
    bit[31:0] SPIxSTAT0_CUR;
        
    case (_DORD)
        MSB : DORD = 1'b0;
        LSB : DORD = 1'b1;
    endcase

    DSIZ = _DSIZ-1;

    case (_SS_sel)
        0: SSEN = 8'b00000001;
        1: SSEN = 8'b00000010;
        2: SSEN = 8'b00000100;
        3: SSEN = 8'b00001000;
        4: SSEN = 8'b00010000;
        5: SSEN = 8'b00100000;
        6: SSEN = 8'b01000000;
        7: SSEN = 8'b10000000;
    endcase    
     
    // initial status check
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    
    // start conf sequence, do not enable SPI module
    if(!conf_seq.randomize() with { 
                                    SPIxCTRL1_SSEN  == SSEN;
                                    
                                    SPIxCTRL0_DSIZ  == DSIZ;    
                                    SPIxCTRL0_DORD  == DORD;    
                                    SPIxCTRL0_DIR   == _DIR; 
                                    SPIxCTRL0_SPIEN == 1'b0;
  	                         }) 
  	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
  	    
  	conf_seq.start(apb2spi_env_top.v_sequencer);
     
endtask : configure


task test_apb2spi_slv_general::configure_en(data_order_type _DORD, int _DSIZ, int _SS_sel, int _DIR);

    bit DORD;
    bit[4:0] DSIZ;
    bit[7:0] SSEN;
    bit[31:0] SPIxSTAT0_CUR;
        
    case (_DORD)
        MSB : DORD = 1'b0;
        LSB : DORD = 1'b1;
    endcase

    DSIZ = _DSIZ-1;

    case (_SS_sel)
        0: SSEN = 8'b00000001;
        1: SSEN = 8'b00000010;
        2: SSEN = 8'b00000100;
        3: SSEN = 8'b00001000;
        4: SSEN = 8'b00010000;
        5: SSEN = 8'b00100000;
        6: SSEN = 8'b01000000;
        7: SSEN = 8'b10000000;
    endcase    
     
    // initial status check
    if(!read_reg_seq.randomize() with { 
                             paddr        == SPIxSTAT0_ADDR;
          	            }) 
    begin
        `uvm_fatal(get_type_name(), "Failed to randomize.")
    end 
    read_reg_seq.start(apb2spi_env_top.v_sequencer);
    
    
    // start conf sequence, do not enable SPI module
    if(!conf_seq.randomize() with { 
                                    SPIxCTRL1_SSEN  == SSEN;
                                    
                                    SPIxCTRL0_DSIZ  == DSIZ;    
                                    SPIxCTRL0_DORD  == DORD;    
                                    SPIxCTRL0_DIR   == _DIR; 
                                    SPIxCTRL0_SPIEN == 1'b1;
  	                         }) 
  	begin
            `uvm_fatal(get_type_name(), "Failed to randomize.")
  	end  
  	    
  	conf_seq.start(apb2spi_env_top.v_sequencer);
     
endtask : configure_en

`endif // TEST_APB2SPI_SLV_GENERAL_SV
