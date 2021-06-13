`timescale 1ns / 1ps
/*参数化同步FIFO设计*/
module para_sync_fifo_ST # (
    //parameter FIFO_TYPE     =  1                     ,	               //ST: standard PRE: prefetch
    parameter DATA_WIDTH    =  64                    ,                 //数据位宽 & FIFO位宽                 
	parameter DATA_DEPTH    =  9                     ,                 //FIFO 深度 = 2 ^ DATA_DEPTH
	parameter PROG_FULL   =  500                    ,                //指示基本写满的参�?     ---> prog_full
	parameter PROG_EMPTY  =  50                      ,               //指示基本读空的参�?     ---> prog_empty
	parameter CNT_WIDTH     =  9                                       //计数器深�?
)(
    input                         clk                ,                //时钟，同步FIFO �?个时�?
	input                         srst               ,                //复位,高电平有�?,同步复位
	input   [DATA_WIDTH - 1 : 0]  din                ,                //数据输入
	input                         wr_en              ,                //写使�?
	input                         rd_en              ,                //读使�?
	output  [DATA_WIDTH - 1 : 0]  dout               ,                //数据输出
	output                        full               ,                //FIFO 写满信号
	output                        almost_full        ,                //FIFO 基本写满信号，指示下�?个时钟FIFO将写�?
	output                        prog_full          ,                //自定阈�?�，指示FIFO的写状�??
	output                        empty              ,                //FIFO 读空信号
	output                        almost_empty       ,                //FIFO 基本读空信号，指示下�?个时钟FIFO将读�?
	output                        prog_empty         ,                //自定阈�?�，指示FIFO的读状�??
	output [CNT_WIDTH      : 0]   data_count                          //计数当前FIFO的数据个�?
);

// Define localparam
//localparam FULL          = {1'b1,{(DATA_DEPTH){1'b0}}} ;          //指示写满，不能再�?
localparam ALMOST_FULL   = {(DATA_DEPTH){1'b1}} ;   //允许再进行一次写         
//localparam EMPTY         = {(DATA_DEPTH){1'b0}}               ;   //指示读空,不能再读
localparam ALMOST_EMPTY  = 1'b1                               ;   //运行再进行一次读


//Define reg
reg  [DATA_DEPTH     : 0]         wr_addr_ptr   ;                 //写地�?
reg  [DATA_DEPTH     : 0]         rd_addr_ptr   ;                 //读地�?
reg  [CNT_WIDTH      : 0]         wr_rd_cnt ;                 //读写计数�?: 写有�? +1  �? 读有�? -1

//reg tepmp
reg                               empty_r        ;
reg                               almost_empty_r ;
reg                               almost_full_r  ;
reg                               full_r         ;
reg                               prog_empty_r   ;
reg                               prog_full_r    ;

//数据个数输出端口

assign almost_empty      = almost_empty_r;
assign almost_full       = almost_full_r ;
assign prog_full         = prog_full_r   ;
assign prog_empty        = prog_empty_r  ;
assign data_count        = wr_rd_cnt     ;
assign full  = (  {~wr_addr_ptr[DATA_DEPTH],wr_addr_ptr[DATA_DEPTH - 1 : 0] } == rd_addr_ptr );
assign empty = ( wr_addr_ptr == rd_addr_ptr ) ? 1'b1 : 1'b0 ;
//生成写地�?
always @ (posedge clk)begin
    if(srst)
	    wr_addr_ptr <= 0;
	else if ( wr_en && ~full )
	    wr_addr_ptr <= wr_addr_ptr + 1'd1 ;
end
//生成读地�?
always @ (posedge clk)begin
    if(srst)
	    rd_addr_ptr <= 0;
	else if ( rd_en && ~empty)
	    rd_addr_ptr <= rd_addr_ptr + 1'd1 ;
end
//计数当前FIFO的数据个�?
always @ (posedge clk)begin
    if(srst)
        wr_rd_cnt <= 0 ;
	else begin 
	    case ({wr_en,rd_en})
	        2'b00 : wr_rd_cnt <= wr_rd_cnt                ;
		    2'b10 : begin
			            if( full == 1'b0 )
			                wr_rd_cnt <= wr_rd_cnt + 1'd1 ;
					end
		    2'b01 : begin
			            if( empty == 1'b0 )
			                wr_rd_cnt <= wr_rd_cnt - 1'd1 ;
					end
		    2'b11 : wr_rd_cnt <= wr_rd_cnt                ;
        default:                                          ;
	    endcase
	end
end
always @ (*)begin
       if( wr_rd_cnt >= ALMOST_FULL )
            almost_full_r = 1'b1 ;
       else
            almost_full_r = 1'b0 ;
end
always @ (*)begin
       if( wr_rd_cnt >= PROG_FULL )
            prog_full_r  = 1'b1 ;
       else
            prog_full_r  = 1'b0  ;
end
always @ (*)begin
      if ( wr_rd_cnt <= ALMOST_EMPTY )
           almost_empty_r = 1'b1 ;
      else
          almost_empty_r  = 1'b0 ;
end
always @ (*) begin
      if ( wr_rd_cnt <  PROG_EMPTY )
          prog_empty_r = 1'b1 ;
      else
          prog_empty_r = 1'b0 ;
end

fifo_ram #(
    .DATA_DEPTH       (DATA_DEPTH),                 //数据位宽 & FIFO位宽 
    .DATA_WIDTH       (DATA_WIDTH)                  //FIFO 深度 = 2 ^ DATA_DEPTH
)u_fifo_ram(
    .wclk             (clk)       ,                 //写时�?
    .wr_en            (wr_en)     ,                 //写使�?
    .waddr            (wr_addr_ptr[DATA_DEPTH - 1 : 0])   ,                 //写地�?
    .wdata            (din)       ,                 //写入的数�?
    .wfull            (full)      ,
    .rclk             (clk)       ,                 //读时�?
    .rd_en            (rd_en)     ,
    .raddr            (rd_addr_ptr[DATA_DEPTH - 1 : 0])   ,
    .rempty           (empty)     ,
    .rdata            (dout)
);
endmodule