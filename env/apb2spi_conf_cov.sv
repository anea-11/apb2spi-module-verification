//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_conf_cov.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_CONF_COV_SV
`define APB2SPI_CONF_COV_SV

class apb2spi_conf_cov extends uvm_subscriber #(apb_uvc_item);
  
    // coverage fields
    bit[7:0] SPIxSTAT0_TXBEC;
    bit[7:0] SPIxSTAT0_RXBEC;
    bit      SPIxSTAT0_RFF;
    bit      SPIxSTAT0_RNE;
    bit      SPIxSTAT0_TNF;
    bit      SPIxSTAT0_TFE;
    bit      SPIxSTAT0_BUSY;   
    
    bit[2:0] SPIxCTRL1_SSINSEL;
    bit[7:0] SPIxCTRL1_SSEN;
    
    bit      SPIxCTRL0_FLUSHR;   
    bit      SPIxCTRL0_FLUSHT;
    bit[4:0] SPIxCTRL0_DSIZ;
    bit      SPIxCTRL0_DORD;   
    bit[1:0] SPIxCTRL0_DIR;
    bit      SPIxCTRL0_SPIEN;
    
    // fields
    bit collect_regs_test_coverage      = 1'b0;
    bit collect_trans_test_cov          = 1'b0;
        
    // item
    apb_uvc_item c_item;

    // registration macro
    `uvm_component_utils(apb2spi_conf_cov)
    
    // coverage groups
    covergroup regs_test_cg;

        option.per_instance = 1;

        registers_access_cov: coverpoint c_item.paddr{
	                                        bins SPIxCAP    = {SPIxCAP_ADDR};
	                                        bins SPIxCTRL0  = {SPIxCTRL0_ADDR};
	                                        bins SPIxCTRL1  = {SPIxCTRL1_ADDR};
	                                        bins SPIxSTAT0  = {SPIxSTAT0_ADDR};
	                                        bins SPIxDAT    = {SPIxDAT_ADDR};
                                         }
                                         
        pwrite_cov: coverpoint c_item.pwrite{
                                            bins WRITE  = {1'b1};
                                            bins READ   = {1'b0};
                                        }
        
        pstrb_cov:  coverpoint c_item.pstrb;
        
        pwdata_cov: coverpoint c_item.pwdata;

        cross_registers_pwrite_pstrb_cov: cross registers_access_cov, pwrite_cov, pstrb_cov{
                                            ignore_bins     ignore_pstrb_pread    =  binsof(pwrite_cov) intersect {1'b0} && binsof(pstrb_cov) intersect {[4'b0001:4'b1111]} ;
                                            
                                            ignore_bins     ignore_pwrite_dat     =  binsof(registers_access_cov) intersect {SPIxDAT_ADDR} && 
                                                                                     binsof(pwrite_cov) intersect {1'b1};
                                                                                     
                                        }
        
        SPIxCAP_wr_cov:     cross registers_access_cov, pwrite_cov, pstrb_cov, pwdata_cov{
        
                                             ignore_bins    of_registers_access_cov    = !binsof(registers_access_cov) intersect {SPIxCAP_ADDR} ;
                                             ignore_bins    of_pwrite_cov              =  binsof(pwrite_cov) intersect {1'b0};
                                             ignore_bins    of_pwdata_cov              =  binsof(pwdata_cov) intersect {SPIxCAP_RST_VAL};  
                                             
                                        }
        
        
        SPIxCTRL0_wr_res_cov: cross registers_access_cov, pwrite_cov, pstrb_cov, pwdata_cov{
        
                                             ignore_bins    of_registers_access_cov    = !binsof(registers_access_cov) intersect {SPIxCTRL0_ADDR} ;
                                             ignore_bins    of_pwrite_cov              = binsof(pwrite_cov) intersect {1'b0};
                                              
                                        }
                                        
        SPIxCTRL1_wr_res_cov: cross registers_access_cov, pwrite_cov, pstrb_cov, pwdata_cov{
        
                                             ignore_bins    of_registers_access_cov    = !binsof(registers_access_cov) intersect {SPIxCTRL1_ADDR} ;
                                             ignore_bins    of_pwrite_cov              = binsof(pwrite_cov) intersect {1'b0};
                                              
                                        }
                                        
        SPIxSTAT0_ro_cov: cross registers_access_cov, pwrite_cov, pstrb_cov, pwdata_cov{
        
                                             ignore_bins    of_registers_access_cov    = !binsof(registers_access_cov) intersect {SPIxSTAT0_ADDR} ;
                                             ignore_bins    of_pwrite_cov              = binsof(pwrite_cov) intersect {1'b0};
                                             ignore_bins    of_pwdata_cov              = binsof(pwdata_cov) intersect {SPIxSTAT0_RST_VAL}; 
                                        }
                                        
    endgroup
    
    // slv_trans_cg
    covergroup slv_trans_cg;
        
        option.per_instance = 1;
        
        ssin_cov: coverpoint SPIxCTRL1_SSINSEL{
                                                bins insel[] = {[3'b000:3'b111]};       
                            }
        
        ssen_cov: coverpoint SPIxCTRL1_SSEN {
                                                bins ssin0 = {8'b00000001};
                                                bins ssin1 = {8'b00000010};
                                                bins ssin2 = {8'b00000100};
                                                bins ssin3 = {8'b00001000};
                                                bins ssin4 = {8'b00010000};
                                                bins ssin5 = {8'b00100000};
                                                bins ssin6 = {8'b01000000};
                                                bins ssin7 = {8'b10000000};
                                        }
    
        dsiz_cov: coverpoint SPIxCTRL0_DSIZ{
                                                bins size[] = {[5'b0011:5'b11111]};
                                             }
        
        dord_cov: coverpoint SPIxCTRL0_DORD{
                                                bins LSB    = {1'b1};
                                                bins MSB    = {1'b0};
                                             }
        
        cross_dsize_dord_ss_cov: cross dsiz_cov, dord_cov, ssen_cov;
        
        flusht_cov: cross SPIxCTRL0_DIR, SPIxCTRL0_FLUSHT{
                                                ignore_bins    ign   = flusht_cov with (SPIxCTRL0_DIR != 2'b10);
                                            }
    
    endgroup
    
    // slv_trans_status_cg
    covergroup slv_trans_status_cg;
        
        option.per_instance = 1;
        
        tx_buff_elem_num_cov: coverpoint SPIxSTAT0_TXBEC{
                                                bins elem_num[] = {[0:FDEPTH]};
                                        }
        
        tx_flags_busy_comb_cov: cross SPIxSTAT0_TNF, SPIxSTAT0_TFE, SPIxSTAT0_BUSY{
                                                ignore_bins ign1 = binsof(SPIxSTAT0_TNF) intersect {1'b0} && binsof(SPIxSTAT0_TFE) intersect {1'b1};
                                                ignore_bins ign2 = binsof(SPIxSTAT0_TFE) intersect {1'b0} && binsof(SPIxSTAT0_BUSY) intersect {1'b0};
                                        }        

    endgroup
    
    // slv_receive_cg
    covergroup slv_receive_cg;
        
        option.per_instance = 1;
        
        ssin_cov: coverpoint SPIxCTRL1_SSINSEL{
                                                bins insel[] = {[3'b000:3'b111]};       
                                    }
        
        ssen_cov: coverpoint SPIxCTRL1_SSEN {
                                                bins ssin0 = {8'b00000001};
                                                bins ssin1 = {8'b00000010};
                                                bins ssin2 = {8'b00000100};
                                                bins ssin3 = {8'b00001000};
                                                bins ssin4 = {8'b00010000};
                                                bins ssin5 = {8'b00100000};
                                                bins ssin6 = {8'b01000000};
                                                bins ssin7 = {8'b10000000};
                                        }
    
        dsiz_cov: coverpoint SPIxCTRL0_DSIZ{
                                                bins size[] = {[5'b0011:5'b11111]};
                                             }
        
        dord_cov: coverpoint SPIxCTRL0_DORD{
                                                bins LSB    = {1'b1};
                                                bins MSB    = {1'b0};
                                             }
     
        cross_dsize_dord_ss_cov: cross dsiz_cov, dord_cov, ssen_cov;
        
        flushr_cov: cross SPIxCTRL0_DIR, SPIxCTRL0_FLUSHR{
                                                ignore_bins    ign   = flushr_cov with (SPIxCTRL0_DIR != 2'b01);
                                            }
    endgroup
    
    // slv_receive_status_cg
    covergroup slv_receive_status_cg;
        
        option.per_instance = 1;
        
        rx_buff_elem_num_cov: coverpoint SPIxSTAT0_RXBEC{
                                                bins elem_num[] = {[0:FDEPTH]};
                                        }
        
        rx_flags_busy_comb_cov: cross SPIxSTAT0_RFF, SPIxSTAT0_RNE, SPIxSTAT0_BUSY{
                                                ignore_bins ign = binsof(SPIxSTAT0_RFF) intersect {1'b1} && binsof(SPIxSTAT0_RNE) intersect {1'b0};
                                        }        

    endgroup
           
    // constructor
    extern function new(string name, uvm_component parent);
  
    // analysis implementation port function
    extern virtual function void write(apb_uvc_item t);

    // sample transmit cg
    extern task sample_transmit_cg();
    
    // sample receive cg
    extern task sample_receive_cg();
    
    // sample transmit status cg
    extern task sample_transmit_status_cg();
    
    // sample receive status cg
    extern task sample_receive_status_cg();

endclass : apb2spi_conf_cov

// constructor
function apb2spi_conf_cov::new(string name, uvm_component parent);
    super.new(name, parent);
 
    // instantiate cover groups
    regs_test_cg = new();
    regs_test_cg.set_inst_name("regs_test_cg");

    slv_trans_cg = new();
    slv_trans_cg.set_inst_name("slv_trans_cg");
    
    slv_receive_cg = new();
    slv_receive_cg.set_inst_name("slv_receive_cg");
    
    slv_trans_status_cg = new();
    slv_trans_status_cg.set_inst_name("slv_trans_status_cg");
    
    slv_receive_status_cg= new();
    slv_receive_status_cg.set_inst_name("slv_receive_status_cg");
    
endfunction : new

// sample transmit cg
task apb2spi_conf_cov::sample_transmit_cg();
    slv_trans_cg.sample();
endtask : sample_transmit_cg

// sample receive cg
task apb2spi_conf_cov::sample_receive_cg();
    slv_receive_cg.sample();
endtask : sample_receive_cg

// sample transmit status cg
task apb2spi_conf_cov::sample_transmit_status_cg();
    slv_trans_status_cg.sample();
endtask : sample_transmit_status_cg

// sample transmit status cg
task apb2spi_conf_cov::sample_receive_status_cg();
    slv_receive_status_cg.sample();
endtask : sample_receive_status_cg

// analysis implementation port function
function void apb2spi_conf_cov::write(apb_uvc_item t);
    
    c_item = t;
    
    // covergroup related to register test should be sampled on each apb transaction
    if(collect_regs_test_coverage) begin
	    regs_test_cg.sample();
	end
    
    // collect SPIxCTRL0 and SPIxCTRL1 fields from apb write transactions
    if(t.paddr == SPIxCTRL0_ADDR) begin
        SPIxCTRL0_FLUSHR = t.pwdata[19]; 
        SPIxCTRL0_FLUSHT = t.pwdata[18]; 
    end
    
    if(t.pwrite == 1'b1 && t.pwdata[18] != 1'b1 && t.pwdata[19] != 1'b1) begin
    
        if(t.paddr == SPIxCTRL0_ADDR) begin
            SPIxCTRL0_DSIZ   = t.pwdata[12:8]; 
            SPIxCTRL0_DORD   = t.pwdata[6]; 
            SPIxCTRL0_DIR    = t.pwdata[5:4]; 
            SPIxCTRL0_SPIEN  = t.pwdata[0]; 
        end
        
        else if (t.paddr == SPIxCTRL1_ADDR) begin
            SPIxCTRL1_SSINSEL = t.pwdata[11:9]; 
            SPIxCTRL1_SSEN    = t.pwdata[7:0]; 
        end
    end
    
    // collect SPIxSTAT0 fields from apb read transactions
    else begin
        if (t.paddr == SPIxSTAT0_ADDR) begin
            SPIxSTAT0_TXBEC = t.prdata[31:24]; 
            SPIxSTAT0_RXBEC = t.prdata[23:16]; 
            SPIxSTAT0_RFF   = t.prdata[7];
            SPIxSTAT0_RNE   = t.prdata[6];
            SPIxSTAT0_TNF   = t.prdata[5];
            SPIxSTAT0_TFE   = t.prdata[4]; 
            SPIxSTAT0_BUSY =  t.prdata[0]; 
        end
    end

endfunction : write

`endif // APB2SPI_CONF_COV_SV
