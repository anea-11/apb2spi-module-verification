//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : test_apb_uvc_pkg.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef TEST_APB_UVC_PKG
`define TEST_APB_UVC_PKG

package test_apb_uvc_pkg;

`include "uvm_macros.svh"

import uvm_pkg::*;

// import UVC's packages
import apb_uvc_pkg::*;

// include tests
`include "test_apb_uvc_base.sv"
`include "test_apb_uvc_example.sv"

endpackage : test_apb_uvc_pkg

`endif // TEST_APB_UVC_PKG
