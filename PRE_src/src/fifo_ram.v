`timescale 1ns / 1ps
module fifo_ram
#(
    parameter  DATA_DEPTH = 9    ,        //数据位宽 & FIFO位宽 
    parameter  DATA_WIDTH = 64             //FIFO 深度 = 2 ^ DATA_DEPTH
)(
    input                        wclk,          //写时�?
    input                        wr_en,         //写使�
    input       [DATA_DEPTH-1:0] waddr,         //写地�?
    input       [DATA_WIDTH-1:0] wdata,        
    input                        wfull,
    input                        rclk ,
    input                        rd_en,
    input                        rempty,
    input       [DATA_DEPTH-1:0] raddr,
    output      [DATA_WIDTH-1:0] rdata
);
//Define localparam
localparam RAM_DEPTH   = 1 << DATA_DEPTH        ;         //FIFO深度
//Define reg 
(* ram_style =  "block" *)reg [DATA_WIDTH-1:0] ram [RAM_DEPTH -1 : 0]     ;

    always @(posedge wclk) begin
        if (wr_en && !wfull)
            ram[waddr] <= wdata;
    end
   assign rdata = (rd_en && !rempty) ? ram[raddr] : {(DATA_WIDTH-1){1'bx}};
    
endmodule
