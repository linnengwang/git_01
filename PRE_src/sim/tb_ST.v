`timescale 1ns / 1ps
module tb_PRE();
reg      clk;
reg      rst;
initial begin
    clk = 1 ;
    rst = 1 ;
#35
    rst = 0 ;
#20000
    rst = 1 ;   
end
always #10 clk = ~clk ;

T_para_sync_fifo#(
    .DATA_WIDTH    (8)                    ,                 //数据位宽 & FIFO位宽                 
	.DATA_DEPTH    (6)                     ,                 //FIFO 深度 = 2 ^ DATA_DEPTH = 16
	.PROG_FULL     (50)                    ,                //指示基本写满的参数     ---> prog_full
	.PROG_EMPTY    (10)                     ,               //指示基本读空的参数     ---> prog_empty
	.CNT_WIDTH     (6)                                       //计数器深度
)u_T_para_sync_fifo(
    .clk                (clk) ,
	.rst                (rst)
);
endmodule
