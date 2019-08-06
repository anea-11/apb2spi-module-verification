//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_scoreboard.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_SCB_SV
`define APB2SPI_SCB_SV

`uvm_analysis_imp_decl(_apb)
`uvm_analysis_imp_decl(_spi)

class apb2spi_scoreboard extends uvm_scoreboard;
  
    // this flag is used in order to issue a UVM_WARNING instead of UVM_ERROR during transmit_only test
    // because of a bug
    bit tx_just_flushed = 1'b0;
    int cnt = 0;
    bit rst = 1'b0;
    
    // this flag is added to adjust prediction for SPIxSTAT0 register value after flushing Rx buffer
    bit rx_just_flushed = 1'b0;
    
    // configuration
    apb2spi_cfg m_cfg;
  
    // registration macro
    // TODO dodaj fieldove u makro
    // TODO, moram li zapravo?
    `uvm_component_utils(apb2spi_scoreboard)
    
    // real register values read from dut
    bit [31:0]          SPIxCAP_val;
    bit [31:0]          SPIxCTRL0_val;
    bit [31:0]          SPIxCTRL1_val;
    bit [31:0]          SPIxSTAT0_val;
    
    // data from FIFO's
    bit [31:0]          Tx_next_data;
    bit [31:0]          Rx_next_data = RX_UNDERFLOW_VAL;
    
    // data size mask
    bit [31:0]          DATA_SIZE_MASK = 32'h00000000;
    
    // predicted FIFO content
    apb2spi_fifo_buf#(bit[31:0], FDEPTH)    Tx_FIFO; 
    apb2spi_fifo_buf#(bit[31:0], FDEPTH)    Rx_FIFO; 
    
    // predicted register values
    bit [31:0] SPIxCAP_predicted    = SPIxCAP_RST_VAL;
    bit [31:0] SPIxCTRL0_predicted  = SPIxCTRL0_RST_VAL;
    bit [31:0] SPIxCTRL1_predicted  = SPIxCTRL1_RST_VAL;
    bit [31:0] SPIxSTAT0_predicted  = SPIxSTAT0_RST_VAL;
    
    // ports
    uvm_analysis_imp_apb#(apb_uvc_item, apb2spi_scoreboard) apb_scb_port;
    uvm_analysis_imp_spi#(spi_uvc_item, apb2spi_scoreboard) spi_scb_port;
  
    // coverage 
    apb2spi_conf_cov config_cov;
  
    // constructor
    extern function new(string name, uvm_component parent);

    // write apb
    extern function void write_apb(apb_uvc_item t);

    // write spi
    extern function void write_spi(spi_uvc_item t);
    
    // update regs
    extern function void update_predict_reg_vals(apb_uvc_item t);
    
    // check reg vals
    extern function void check_reg_vals(apb_uvc_item t);
    
    // model strb
    extern function int strobe(int current_val, int pstrb, int new_val);
    
    // put data to Tx_FIFO, predict SPIxCTRL0
    extern function void transmit_fifo_insert(apb_uvc_item t);

    // put data to Rx_FIFO, predict SPIxCTRL0
    extern function void receive_fifo_insert(spi_uvc_item t);
    
    // get data from Tx_FIFO, check if data is equal to data on SPI lines
    extern function transmit_only_spi(spi_uvc_item t);
    
    // get data from Rx_FIFO, check if data is equal to data on APB lines
    extern function void receive_only_apb(apb_uvc_item t);
    
endclass : apb2spi_scoreboard

// constructor
function apb2spi_scoreboard::new(string name, uvm_component parent);
    super.new(name, parent);
    
    // get configuration from config DB
    if(!uvm_config_db #(apb2spi_cfg)::get(this, "", "apb2spi_cfg_top", m_cfg)) begin
        `uvm_fatal(get_type_name(), "Failed to get configuration object from config DB!")
    end 

    // create ports
    apb_scb_port = new("apb_scb_port", this);
    spi_scb_port = new("scb_scb_port", this);
    
    // create FIFOs
    Tx_FIFO = new();
    Rx_FIFO = new();
    
endfunction : new

// write apb
function void apb2spi_scoreboard::write_apb(apb_uvc_item t);

    `uvm_info(get_type_name(), $sformatf("APB item in scb: \n%s", t.sprint()), UVM_LOW)
    
    if(rst == 1'b1) begin
        SPIxCAP_predicted    = SPIxCAP_RST_VAL;
        SPIxCTRL0_predicted  = SPIxCTRL0_RST_VAL;
        SPIxCTRL1_predicted  = SPIxCTRL1_RST_VAL;
        SPIxSTAT0_predicted  = SPIxSTAT0_RST_VAL;
        Rx_next_data = RX_UNDERFLOW_VAL;
        Rx_FIFO.flush();
        Tx_FIFO.flush();
        rst = 1'b0;
    end
     
    update_predict_reg_vals(t);
        
    if(t.pwrite === 1'b0) check_reg_vals(t);
   
endfunction : write_apb

// write spi
function void apb2spi_scoreboard::write_spi(spi_uvc_item t);

    `uvm_info(get_type_name(), $sformatf("SPI item in scb: \n%s", t.sprint()), UVM_LOW)
    
    if(rst == 1'b1) begin
        SPIxCAP_predicted    = SPIxCAP_RST_VAL;
        SPIxCTRL0_predicted  = SPIxCTRL0_RST_VAL;
        SPIxCTRL1_predicted  = SPIxCTRL1_RST_VAL;
        SPIxSTAT0_predicted  = SPIxSTAT0_RST_VAL;
        Rx_next_data = RX_UNDERFLOW_VAL;
        Rx_FIFO.flush();
        Tx_FIFO.flush();
        rst = 1'b0;
    end
       
    // transmit only mode
    if(SPIxCTRL0_predicted[5:4] == 2'b10) transmit_only_spi(t);

    // receive only mode
    else if(SPIxCTRL0_predicted[5:4] == 2'b01) receive_fifo_insert(t);
    
    
endfunction : write_spi

// check reg vals
function void apb2spi_scoreboard::check_reg_vals(apb_uvc_item t);
        
        case(t.paddr)
            SPIxCAP_ADDR:       begin
                                    if(t.prdata !== SPIxCAP_predicted)
                                    `uvm_error("SPIxCAP_val_chk", $sformatf("Reg value error: SPIxCAP has real value %h instead of predicted %h \n", t.prdata, SPIxCAP_predicted))
                                end
                                
            SPIxCTRL0_ADDR:     begin
                                    if(t.prdata !== SPIxCTRL0_predicted)
                                    `uvm_error("SPIxCTRL0_val_chk", $sformatf("Reg value error: SPIxCTRL0 has real value %h instead of predicted %h \n", t.prdata, SPIxCTRL0_predicted))
                                end
                                
            SPIxCTRL1_ADDR:     begin
                                    if(t.prdata !== SPIxCTRL1_predicted)
                                    `uvm_error("SPIxCTRL1_val_chk", $sformatf("Reg value error: SPIxCTRL1 has real value %h instead of predicted %h \n", t.prdata, SPIxCTRL1_predicted))
                                end
                                
            SPIxSTAT0_ADDR:     begin
                                    if(t.prdata !== SPIxSTAT0_predicted) begin
                                        if(tx_just_flushed) begin
                                            `uvm_warning("transmit_buffer_known_bug", $sformatf("Reg value error: SPIxSTAT0 has real value %h instead of predicted %h \n", t.prdata, SPIxSTAT0_predicted))
                                        end
                                        else if (rx_just_flushed) begin
                                            rx_just_flushed = 1'b0;
                                        end
                                        else begin
                                            `uvm_error("SPIxSTAT0_val_chk", $sformatf("Reg value error: SPIxSTAT0 has real value %h instead of predicted %h \n", t.prdata, SPIxSTAT0_predicted))
                                        end
                                    end
                                    // transmit-only mode
                                    if(SPIxCTRL0_predicted[5:4] == 2'b10) begin
                                        config_cov.sample_transmit_status_cg();
                                    end
                                    // receive-only mode
                                    if(SPIxCTRL0_predicted[5:4] == 2'b01) begin
                                        config_cov.sample_receive_status_cg();
                                    end
                                end
   
            SPIxDAT_ADDR:       begin
                                    if(t.prdata !== Rx_next_data)
                                    `uvm_error("receive_buffer_chk", $sformatf("Rx value error: %h was detected instead of predicted value %h \n", t.prdata, Rx_next_data))
                                end
        endcase

endfunction : check_reg_vals

// update regs / predict regs values
function void apb2spi_scoreboard::update_predict_reg_vals(apb_uvc_item t);
    
    // predict values
    if(t.pwrite === 1'b1) begin
        case(t.paddr)
            SPIxCAP_ADDR:       SPIxCAP_predicted         = SPIxCAP_val;
            SPIxCTRL0_ADDR:     begin
                                    SPIxCTRL0_val         = SPIxCTRL0_predicted;
                                    SPIxCTRL0_predicted   = strobe(SPIxCTRL0_predicted, t.pstrb, t.pwdata);
                                    SPIxCTRL0_predicted   = SPIxCTRL0_predicted&SPIxCTRL0_RES_BIT_MASK;
                                    // if SPIEN == 1 (some bits are locked)
                                    if(SPIxCTRL0_val[0] == 1'b1) begin
                                        SPIxCTRL0_predicted[17:16]  = SPIxCTRL0_val[17:16];
                                        SPIxCTRL0_predicted[13 :8]  = SPIxCTRL0_val[13 :8];
                                        SPIxCTRL0_predicted[6  :1]  = SPIxCTRL0_val[6  :1];
                                    end
                                    // flush Tx buffer
                                    if(t.pwdata[18] == 1'b1 && t.pstrb[2] == 1'b1) begin
                                        cnt = 0;
                                        tx_just_flushed = 1'b1;
                                        SPIxSTAT0_predicted[31:24]  = 8'h00;    // TXBEC
                                        SPIxSTAT0_predicted[5:4]    = 2'b11;    // TNF, TFE
                                        SPIxSTAT0_predicted[0]      = 1'b0;     // BSY
                                        Tx_FIFO.flush();
                                    end
                                    // flush Rx buffer
                                    if(t.pwdata[19] == 1'b1 && t.pstrb[2] == 1'b1) begin
                                        rx_just_flushed = 1'b1;
                                        SPIxSTAT0_predicted[23:16]   = 8'h00; // RXBEC
                                        SPIxSTAT0_predicted[7:6]     = 2'b00; // RFF, RNE
                                        Rx_FIFO.flush();
                                    end
                                    // flush is done every time ove of the following fields change it's value
                                        if( SPIxCTRL0_predicted[12:8] != SPIxCTRL0_val[12:8] ||
                                            SPIxCTRL0_predicted[16] != SPIxCTRL0_val[16]      ||
                                            SPIxCTRL0_predicted[13] != SPIxCTRL0_val[13]       ||
                                            SPIxCTRL0_predicted[17] != SPIxCTRL0_val[17]      
                                        )
                                        begin                                
                                            SPIxSTAT0_predicted[31:24]  = 8'h00;    // TXBEC
                                            SPIxSTAT0_predicted[23:16]  = 8'h00;    // RXBEC
                                            SPIxSTAT0_predicted[7:6]    = 2'b00;    // RFF, RNE
                                            SPIxSTAT0_predicted[5:4]    = 2'b11;    // TNF, TFE
                                            SPIxSTAT0_predicted[0]      = 1'b0;     // BSY
                                            Tx_FIFO.flush();
                                            Rx_FIFO.flush();                                   
                                    end
                                end
            SPIxCTRL1_ADDR:     begin
                                    SPIxCTRL1_predicted   = strobe(SPIxCTRL1_val, t.pstrb, t.pwdata);
                                    SPIxCTRL1_predicted   = SPIxCTRL1_predicted&SPIxCTRL1_RES_BIT_MASK;
                                    // if SPIEN == 1 (some bits are locked)
                                    if(SPIxCTRL0_val[0] == 1'b1) begin
                                        SPIxCTRL1_predicted[15:0]   = SPIxCTRL1_val[15:0];
                                    end
                                end
            // TODO trebalo bi zameniti linijom ... = SPIxSTAT0_predicted;
            SPIxSTAT0_ADDR:     SPIxSTAT0_predicted       = SPIxSTAT0_val;
            SPIxDAT_ADDR:       transmit_fifo_insert(t);
        endcase
    end
    
    // get real values from dut
    else begin
        case(t.paddr)
            SPIxCAP_ADDR:       SPIxCAP_val   = t.prdata;
            SPIxCTRL0_ADDR:     SPIxCTRL0_val = t.prdata;
            SPIxCTRL1_ADDR:     SPIxCTRL1_val = t.prdata;
            SPIxSTAT0_ADDR:     SPIxSTAT0_val = t.prdata;
            // predict values from Rx
            SPIxDAT_ADDR:       receive_only_apb(t);
        endcase
    end

endfunction : update_predict_reg_vals

// put data to Tx_FIFO, predict SPIxSTAT0 value
function void apb2spi_scoreboard::transmit_fifo_insert(apb_uvc_item t);
    
    DATA_SIZE_MASK = 32'b0;
    for(int i = 0; i< m_cfg.SPI_UVC_DSIZ; i++) DATA_SIZE_MASK[i] = 1'b1;
    
    // put data to Tx_FIFO
    Tx_FIFO.put(strobe(0, t.pstrb, t.pwdata) & DATA_SIZE_MASK);
   
    // drive TFE - transmit FIFO empty flag - low
    if(Tx_FIFO.size() != 0) begin
        SPIxSTAT0_predicted[4] = 1'b0;
        SPIxSTAT0_predicted[0] = 1'b1;
    end
    
    // drive TNF - transmit FIFO not full flag - low
    if(Tx_FIFO.size() == FDEPTH) SPIxSTAT0_predicted[5] = 1'b0;
    
    // set TXBEC - transmit buffer element count field - value
    SPIxSTAT0_predicted[31:24] = Tx_FIFO.size();
    
endfunction : transmit_fifo_insert

// put data to Rx_FIFO, predict SPIxSTAT0 value
function void apb2spi_scoreboard::receive_fifo_insert(spi_uvc_item t);
    
    // end of SPI transaction
    if(t.dummy != 1'b1) begin
    
        DATA_SIZE_MASK = 32'b0;
        for(int i = 0; i< m_cfg.SPI_UVC_DSIZ; i++) DATA_SIZE_MASK[i] = 1'b1;
        
        // put data to Rx_FIFO
        Rx_FIFO.put(t.data_mosi & DATA_SIZE_MASK);
        
        // drive RNE - receive FIFO not empty flag - high
        if(Rx_FIFO.size() != 0) SPIxSTAT0_predicted[6] = 1'b1;
       
        // drive RFF - receive FIFO full flag - high
        if(Rx_FIFO.size() == FDEPTH) SPIxSTAT0_predicted[7] = 1'b1;
        
        // set RXBEC - receive buffer element count field - value
        SPIxSTAT0_predicted[23:16] = Rx_FIFO.size();
        
        // drive BSY flag low
        SPIxSTAT0_predicted[0] = 1'b0;
        
        // check if flags read from empty Tx buffer are set correctly
        if(Tx_next_data != t.data_miso) begin
            `uvm_error("transmit_buffer_chk", $sformatf("Transmit buffer error: real value on SPI MISO line is %h instead of predicted %h \n", t.data_miso, Tx_next_data))
        end
        
        // sample covergroup related to receive-only test
        config_cov.sample_receive_cg();
        
    end
    
    // beginning of SPI transaction
    else begin
        Tx_next_data = 32'b0;
        // LSB data order
        if(SPIxCTRL0_predicted[6] == 1'b1) begin
            Tx_next_data[0] = SPIxSTAT0_predicted[4];   // TFE
            Tx_next_data[1] = SPIxSTAT0_predicted[5];   // TNF
            Tx_next_data[2] = SPIxSTAT0_predicted[6];   // RNE
            Tx_next_data[3] = SPIxSTAT0_predicted[7];   // RFF  
        end  
        // MSB data order
        // TODO - this prediction is added because I was unable to resolve a bug 
        else begin
            Tx_next_data[m_cfg.SPI_UVC_DSIZ-1]  = SPIxSTAT0_predicted[4];   // TFE
            Tx_next_data[m_cfg.SPI_UVC_DSIZ-2]  = SPIxSTAT0_predicted[5];   // TNF
            Tx_next_data[m_cfg.SPI_UVC_DSIZ-3]  = SPIxSTAT0_predicted[6];   // RNE
            Tx_next_data[m_cfg.SPI_UVC_DSIZ-4]  = SPIxSTAT0_predicted[7];   // RFF  
        end  
        
        // drive BSY flag high
        SPIxSTAT0_predicted[0] = 1'b1;
        
    end
    
endfunction : receive_fifo_insert

// get data from Tx_FIFO, check if that data is equal to data on SPI lines
function apb2spi_scoreboard::transmit_only_spi(spi_uvc_item t);

    // beginning of the SPI transaction
    if(t.dummy == 1'b1) begin
        
        SPIxSTAT0_predicted[0] = 1'b1; // BSY
        
        if(Tx_FIFO.size() > 0) begin  
            Tx_next_data = Tx_FIFO.get();
            if(Tx_FIFO.size() == 0) begin
                SPIxSTAT0_predicted[4] = 1'b1;  // set TFE high if fifo is empty
            end
            SPIxSTAT0_predicted[5] = 1'b1;      // set TNF high, as Tx FIFO is no longer full       
            SPIxSTAT0_predicted[31:24] = Tx_FIFO.size();
        end
      
        else begin
            Tx_next_data = 32'b0;
            // LSB data order
            if(SPIxCTRL0_predicted[6] == 1'b1) begin
                Tx_next_data[0] = SPIxSTAT0_predicted[4];   // TFE
                Tx_next_data[1] = SPIxSTAT0_predicted[5];   // TNF
                Tx_next_data[2] = SPIxSTAT0_predicted[6];   // RNE
                Tx_next_data[3] = SPIxSTAT0_predicted[7];   // RFF  
            end  
            // MSB data order
            // TODO - this prediction was added because I was unable to resolve a bug 
            else begin
                Tx_next_data[m_cfg.SPI_UVC_DSIZ-1]  = SPIxSTAT0_predicted[4];   // TFE
                Tx_next_data[m_cfg.SPI_UVC_DSIZ-2]  = SPIxSTAT0_predicted[5];   // TNF
                Tx_next_data[m_cfg.SPI_UVC_DSIZ-3]  = SPIxSTAT0_predicted[6];   // RNE
                Tx_next_data[m_cfg.SPI_UVC_DSIZ-4]  = SPIxSTAT0_predicted[7];   // RFF  
            end  
        end
        
    end
    
    // end of the SPI transaction
    if(t.dummy == 1'b0) begin
        
        if(Tx_next_data != t.data_miso) begin
            if(tx_just_flushed == 1'b1) begin
                cnt++;
                if(cnt == 2) tx_just_flushed = 1'b0;
                `uvm_warning("transmit_buffer_known_bug", $sformatf("Transmit buffer error: real value on SPI MISO line is %h instead of predicted %h \n", t.data_miso, Tx_next_data))
            end
            else begin
                `uvm_error("transmit_buffer_chk", $sformatf("Transmit buffer error: real value on SPI MISO line is %h instead of predicted %h \n", t.data_miso, Tx_next_data))
            end
        end
        
        // sample covergroup related to transmit-only test
        config_cov.sample_transmit_cg();
        
        if(Tx_FIFO.size() == 0) SPIxSTAT0_predicted[0] = 1'b0; // BSY
        
    end       

endfunction

// get data from Rx_FIFO, check if data is equal to data on APB lines
function void apb2spi_scoreboard::receive_only_apb(apb_uvc_item t);
    
    if(Rx_FIFO.size() > 0) Rx_next_data = Rx_FIFO.get();
    else Rx_next_data = RX_UNDERFLOW_VAL;
    
    SPIxSTAT0_predicted[7] = 1'b0;                          // RFF
    if(Rx_FIFO.size() == 0) SPIxSTAT0_predicted[6] = 1'b0;  // RNE
    SPIxSTAT0_predicted[23:16] = Rx_FIFO.size();            // RXBEC
    
endfunction

// strb
function int apb2spi_scoreboard::strobe(int current_val, int pstrb, int new_val);

    int return_val = current_val;

    case(pstrb)
        4'b0001: return_val[7:0]        = new_val[7:0];
        4'b0010: return_val[15:8]       = new_val[15:8];
        4'b0011: return_val[15:0]       = new_val[15:0];
        4'b0100: return_val[23:16]      = new_val[23:16];
        4'b0101: begin
                    return_val[7:0]     = new_val[7:0];
                    return_val[23:16]   = new_val[23:16];
                 end
        4'b0110: return_val[23:8]       = new_val[23:8];
        4'b0111: return_val[23:0]       = new_val[23:0];
        4'b1000: return_val[31:24]      = new_val[31:24];
        4'b1001: begin
                    return_val[31:24]   = new_val[31:24];
                    return_val[7:0]     = new_val[7:0];
                 end
        4'b1010: begin
                    return_val[31:24]   = new_val[31:24];
                    return_val[15:8]     = new_val[15:8];
                 end
        4'b1011: begin
                    return_val[31:24]   = new_val[31:24];
                    return_val[15:0]    = new_val[15:0];
                 end
        4'b1100: return_val[31:16]      = new_val[31:16];
        4'b1101: begin
                    return_val[31:16]   = new_val[31:16];
                    return_val[7:0]     = new_val[7:0];
                 end
        4'b1110: return_val[31:8]       = new_val[31:8];
        4'b1111: return_val             = new_val;
     endcase
     
     return return_val;
     
endfunction
`endif // APB2SPI_SCB_SV
