//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : training_uvc_if.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_IF_SV
`define APB_UVC_IF_SV

interface apb_interface(input pi_clk, input pi_rst_n);
  
    `include "uvm_macros.svh"
    import uvm_pkg::*;
    
    // signals - master controlled
    logic [31:0]    paddr;
    logic           psel;
    logic           penable;
    logic           pwrite;
    logic [31:0]    pwdata;
    logic [3 :0]    pstrb;
    // signals - slave controlled
    logic           pready;
    logic [31:0]    prdata;
    logic           pslverr;

    // used for disabling assertions
    reg             has_checks;
    
    
    // protocol checkers
    
    // penable should be asserted one clock cycle after psel
    property penable_assert;
        @(posedge pi_clk) 
            disable iff( !pi_rst_n || !has_checks )
        $rose(psel) |=> $rose(penable);
    endproperty: penable_assert
    
    penable_assert_chk:             assert property(penable_assert)
                                    else $error("ASSERTION FAILED: PENABLE WAS NOT ASSERTED ONE CLOCK CYCLE AFTER PSEL!");
    
    // penable should be deasserted at the end of the transfer
    property penable_deassert;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        $rose(pready) |=> $fell(penable);
    endproperty: penable_deassert
    
    penable_deassert_chk:           assert property(penable_deassert)
                                    else $error("ASSERTION FAILED: PENABLE WAS NOT DEASSERTED AT THE END OF THE TRANSFER!");
    
    // penable should never be unknown                      
    property penable_not_unknown;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
                !($isunknown(penable));
    endproperty: penable_not_unknown
    
    penable_not_unknown_chk:        assert property(penable_not_unknown)
                                    else $error("APB ASSERTION FAILED: SIGNAL PENABLE HAD AN UNKNOWN VALUE!");
                                    
    // pready should never be unknown                      
    property pready_not_unknown;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
                !($isunknown(pready));
    endproperty: pready_not_unknown
    
    pready_not_unknown_chk:         assert property(pready_not_unknown)
                                    else $error("APB ASSERTION FAILED: SIGNAL PREADY HAD AN UNKNOWN VALUE!");
    
    // pwrite should never be unknown                      
    property pwrite_not_unknown;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
                !($isunknown(pwrite));
    endproperty: pwrite_not_unknown
    
    pwrite_not_unknown_chk:         assert property(pwrite_not_unknown)
                                    else $error("APB ASSERTION FAILED: SIGNAL PWRITE HAD AN UNKNOWN VALUE!");
    
    // paddr should remain stable during the entire access phase of the transfer
    property paddr_access_stable;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        (psel === 1'b1 && pready === 1'b0) |=> $stable(paddr);
    endproperty: paddr_access_stable
    
    paddr_access_stable_chk:        assert property(paddr_access_stable)
                                    else $error("ASSERTION FAILED: PADDR DID NOT REMAIN STABLE DURING THE ENTIRE ACCESS PHASE OF THE TRANSFER!"); 
    
    // pwrite should remain stable during the entire access phase of the transfer
    property pwrite_access_stable;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        (psel === 1'b1 && pready === 1'b0) |=> $stable(pwrite);
    endproperty: pwrite_access_stable
    
    pwrite_access_stable_chk:       assert property(pwrite_access_stable)
                                    else $error("ASSERTION FAILED: PWRITE DID NOT REMAIN STABLE DURING THE ENTIRE ACCESS PHASE OF THE TRANSFER!"); 
    
    // pwdata should remain stable during the entire access phase of the transfer
    property pwdata_waccess_stable;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        (psel === 1'b1 && pready === 1'b0 && pwrite == 1'b1) |=> $stable(pwdata);
    endproperty: pwdata_waccess_stable
    
    pwdata_waccess_stable_chk:      assert property(pwdata_waccess_stable)
                                    else $error("ASSERTION FAILED: PWDATA DID NOT REMAIN STABLE DURING THE ENTIRE ACCESS PHASE OF WRITE TRANSFER!");
    
    // psel should remain stable during the entire access phase of the transfer    
    property psel_access_stable;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        (psel === 1'b1 && pready === 1'b0) |=> $stable(psel);
    endproperty: psel_access_stable
    
    psel_access_stable_chk:         assert property(psel_access_stable)
                                    else $error("ASSERTION FAILED: PSEL DID NOT REMAIN STABLE DURING THE ENTIRE ACCESS PHASE OF WRITE TRANSFER!");
    
    // penable should remain stable during the entire access phase of the transfer    
    property penable_access_stable;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        (psel === 1'b1 && pready === 1'b0 && penable == 1'b1) |=> $stable(penable);
    endproperty: penable_access_stable
    
    penable_access_stable_chk:      assert property(penable_access_stable)
                                    else $error("ASSERTION FAILED: PENABLE DID NOT REMAIN STABLE DURING THE ENTIRE ACCESS PHASE!");
    
    // pstrb should remain stable during the entire access phase of the transfer  
    property pstrb_access_stable;
        @(posedge pi_clk)
            disable iff(!pi_rst_n || !has_checks)
        (psel === 1'b1 && pready === 1'b0 && pwrite == 1'b0) |=> $stable(pstrb);
    endproperty: pstrb_access_stable
    
    pstrb_access_stable_chk:        assert property(pstrb_access_stable)
                                    else $error("ASSERTION FAILED: PSTRB DID NOT REMAIN STABLE DURING THE ENTIRE ACCESS PHASE!");   
                      
endinterface : apb_interface

`endif // APB_UVC_IF_SV


