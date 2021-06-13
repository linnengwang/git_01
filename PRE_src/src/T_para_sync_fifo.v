/*
//���������������ļ� 
module T_para_sync_fifo#(
    parameter DATA_WIDTH    =  8                     ,                 //数据位宽 & FIFO位宽                 
	parameter DATA_DEPTH    =  4                      ,                 //FIFO 深度 = 2 ^ DATA_DEPTH = 16
	parameter PROG_FULL     =  12                    ,                //指示基本写满的参�?     ---> prog_full
	parameter PROG_EMPTY    =  4                     ,               //指示基本读空的参�?     ---> prog_empty
	parameter CNT_WIDTH     =  4                                       //计数器深�?
)(
    input                                clk                ,
	input                                rst           
);
reg     [DATA_WIDTH - 1:0]                 cnt  ;     
reg                           wr_en ;
reg                           rd_en ;
	wire         [DATA_WIDTH -1  : 0 ]   data_out               ;
    wire                                 full               ;
	wire                                 almost_full        ;                //FIFO 基本写满信号，指示下�?个时钟FIFO将写�?
	wire                                 prog_full          ;                //自定阈�?�，指示FIFO的写状�??
	wire                                 empty              ;                //FIFO 读空信号
	wire                                 almost_empty       ;                //FIFO 基本读空信号，指示下�?个时钟FIFO将读�?
	wire                                 prog_empty         ;               //自定阈�?�，指示FIFO的读状�??
	wire        [CNT_WIDTH     : 0]     data_count         ;               //计数当前FIFO的数据个�?	                          
always @ (posedge clk) begin
    if(rst)
	    cnt <= 0 ;
	else
	    cnt <= cnt + 1'd1 ;  // 0 -> 31
end
always @ (posedge clk) begin
    if(rst)
	    wr_en <= 1'b0 ;
	else if ( cnt >= 8'd0 && cnt < 8'd64 )
	    wr_en <= 1'b1  ;  // 0 -> 31
	else
	    wr_en <= 1'b0 ;
end
always @ (posedge clk)begin
    if(rst)
         rd_en <= 1'b0 ;
    else if ( cnt >= 8'd64 && cnt < 8'd128 )
        rd_en <= 1'b1 ;
    else
        rd_en <= 1'b0 ;
end



para_sync_fifo_ST # (
    //parameter FIFO_TYPE     =  1                     ,	               //ST: standard PRE: prefetch
    .DATA_WIDTH         (DATA_WIDTH),                 //数据位宽 & FIFO位宽                 
	.DATA_DEPTH         (DATA_DEPTH),                 //FIFO 深度 = 2 ^ DATA_DEPTH
	.PROG_FULL          (PROG_FULL),                  //指示基本写满的参�?     ---> prog_full
	.PROG_EMPTY         (PROG_EMPTY),                 //指示基本读空的参�?     ---> prog_empty
	.CNT_WIDTH          (CNT_WIDTH)                   //计数器深�?
)u_para_sync_fifo_ST(
    .clk                (clk),                       //时钟，同步FIFO �?个时�?
	.srst               (rst),                       //复位,高电平有�?,同步复位
	.din                (cnt),                          //数据输入
	.wr_en              (wr_en),                          //写使�?
	.rd_en              (rd_en),                          //读使�?
	.dout               (data_out),                      //数据输出
	.full               (full),                      //FIFO 写满信号
	.almost_full        (almost_full),               //FIFO 基本写满信号，指示下�?个时钟FIFO将写�?
	.prog_full          (prog_full),                 //自定阈�?�，指示FIFO的写状�??
	.empty              (empty),                      //FIFO 读空信号
	.almost_empty       (almost_empty),                //FIFO 基本读空信号，指示下�?个时钟FIFO将读�?
	.prog_empty         (prog_empty),                  //自定阈�?�，指示FIFO的读状�??
	.data_count         (data_count)                   //计数当前FIFO的数据个�?
);
endmodule
*/