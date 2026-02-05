// Code your testbench here
// or browse Examples
`timescale 1ns/1ps

module tb_traffic();
  
     logic clk;
     logic rst;
   logic [5:0] count;
   logic [2:0] light_ns;
   logic [2:0] light_ew;
 
  initial begin
   
    $dumpfile("dump.vcd"); 
    
   
    $dumpvars(0, tb_traffic); 
end
  
   traffic uut (
        .clk(clk),
        .rst(rst),
        .count(count),
        .light_ns(light_ns),
        .light_ew(light_ew)
    );
  
         initial begin
        clk = 0; forever #5 clk = ~clk;
    end

    initial begin
        rst = 1; #20; rst = 0;
        #500; $finish;
    end
endmodule
  
  
  
  