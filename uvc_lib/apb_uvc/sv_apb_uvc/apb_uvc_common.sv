//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb_uvc_common.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB_UVC_COMMON_SV
`define APB_UVC_COMMON_SV

// TODO da postanu localparam
// transaction delay consts
const int SHORT_TD_LOWER = 1;
const int SHORT_TD_UPP = 10;
const int MEDIUM_TD_LOWER = 11;
const int MEDIUM_TD_UPP = 20;
const int LARGE_TD_LOWER = 21;
const int LARGE_TD_UPP = 29;
const int MAX_TRANS_DELAY = 30;

// wait delay consts
const int SHORT_WD_LOWER = 1;
const int SHORT_WD_UPP = 3;
const int MEDIUM_WD_LOWER = 4;
const int MEDIUM_WD_UPP = 6;
const int LARGE_WD_LOWER = 7;
const int LARGE_WD_UPP = 9;
const int MAX_WAIT_DELAY = 10;

typedef enum {READ, WRITE} transaction_type;
typedef enum {ZERO, SHORT, MEDIUM, LARGE, MAX} delay_type;

bit[31:0] last_read_value;

`endif // APB_UVC_COMMON_SV
