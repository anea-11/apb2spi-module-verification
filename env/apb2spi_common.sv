//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_common.sv
// Developer  : Elsys EE
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_COMMON_SV
`define APB2SPI_COMMON_SV

localparam bit[31:0] SPIxCAP_ADDR       = 32'h00000000;
localparam bit[31:0] SPIxCTRL0_ADDR     = 32'h00000004;
localparam bit[31:0] SPIxCTRL1_ADDR     = 32'h00000008;
localparam bit[31:0] SPIxSTAT0_ADDR     = 32'h0000000C;
localparam bit[31:0] SPIxDAT_ADDR       = 32'h00000010;

localparam bit[31:0] SPIxCAP_RST_VAL     = 32'h0007CF01;
localparam bit[31:0] SPIxCTRL0_RST_VAL   = 32'h00000000;
localparam bit[31:0] SPIxCTRL1_RST_VAL   = 32'h00000000;
localparam bit[31:0] SPIxSTAT0_RST_VAL   = 32'h00000030;
localparam bit[31:0] SPIxDAT_RST_VAL     = 32'h00000000;
localparam bit[31:0] RX_UNDERFLOW_VAL    = 32'hffffffff;

localparam int SPIxCTRL0_RES_BIT_MASK    = 32'hff033f7f;
localparam int SPIxCTRL1_RES_BIT_MASK    = 32'h00ffffff;

localparam int FDEPTH                    = 16;

// conf
bit[31:0]       SPIxCTRL1_CONF;
bit[31:0]       SPIxCTRL0_CONF;

`endif // APB2SPI_COMMON_SV
