//------------------------------------------------------------------------------
// Copyright (c) 2018 Elsys Eastern Europe
// All rights reserved.
//------------------------------------------------------------------------------
// File name  : apb2spi_fifo_buf.sv
// Developer  : andrijana.ojdanic
// Date       : 
// Description: 
// Notes      : 
//
//------------------------------------------------------------------------------

`ifndef APB2SPI_FIFO_BUF_SV
`define APB2SPI_FIFO_BUF_SV

interface class PutImp#(type PUT_T = logic);
    pure virtual function void put(PUT_T elem);
endclass
 
interface class GetImp#(type GET_T = logic);
    pure virtual function GET_T get();
endclass

class apb2spi_fifo_buf#(type T = logic, int DEPTH=1) implements PutImp#(T), GetImp#(T);

    T my_fifo [$:DEPTH-1];

    // put elem
    extern virtual function void put(T elem);
    
    // get elem
    extern virtual function T get();
    
    // return num of elems in queue
    extern virtual function int size();
    
    // flush
    extern virtual function void flush();
    
endclass

function void apb2spi_fifo_buf::put(T elem);
    my_fifo.push_back(elem);
endfunction

function T apb2spi_fifo_buf::get();
    get = my_fifo.pop_front();
endfunction

function int apb2spi_fifo_buf::size();
    size = my_fifo.size();
endfunction

function void apb2spi_fifo_buf::flush();
    my_fifo = {};
endfunction

`endif // APB2SPI_FIFO_BUF_SV
