// Created by prof. Mingu Kang @VVIP Lab in UCSD ECE department
// Please do not spread this code without permission 
module l0 (clk, in, out, rd, wr, o_full, reset, o_ready);

  parameter row  = 8;
  parameter bw = 4;


  input  clk;
  input  wr;
  input  rd;
  input  reset;
  input  [row*bw-1:0] in;
  output [row*bw-1:0] out;
  output o_full;
  output o_ready;

  wire [row-1:0] empty;
  wire [row-1:0] full;
  reg [row-1:0] rd_en;
  
  genvar i;

  assign o_ready = |full ;
  assign o_full  = ~(&empty) ;


  for (i=0; i<row ; i=i+1) begin : row_num
      fifo_depth64 #(.bw(bw)) fifo_instance (
	 .rd_clk(clk),
	 .wr_clk(clk),
	 .rd(rd_en[i]),
	 .wr(wr),
         .o_empty(empty[i]),
         .o_full(full[i]),
	 .in(in[i*bw +: bw]),
	 .out(out[i*bw +: bw]),
         .reset(reset));
  end


  always @ (posedge clk) begin
   if (reset) begin
      rd_en <= 8'b00000000;
   end
   
      /////////////// version1: read all row at a time ////////////////
     else if (rd) begin
         rd_en <= {row{1'b1}};  // read all rows
      end
      else begin
         rd_en <= {row{1'b0}};
      end
  end


      //////////////// version2: read 1 row at a time /////////////////
      // Version 2: read 1 row at a time (round-robin)
      /**
      reg [$clog2(row)-1:0] rd_ptr;
      always @(posedge clk) begin
        if (reset) begin
          rd_en  <= {row{1'b0}};
          rd_ptr <= 0;
        end
        else begin
          rd_en <= {row{1'b0}};  // default disable all
          if (rd) begin
            rd_en[rd_ptr] <= 1'b1;   // read current row
            rd_ptr <= rd_ptr + 1;
          end
        end
      end
      **/
    
  
      ///////////////////////////////////////////////////////
    
endmodule
