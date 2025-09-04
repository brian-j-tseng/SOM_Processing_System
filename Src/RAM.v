//*************************************************
//** 2019 spring iVCAD
//** Description: Random-access memory
//** Mar. 2018 Henry authored
//** Mar. 2019 Kevin revised
//** Mar. 2020 Claire revised
//*************************************************

`timescale 1ns/10ps

module RAM (CK, A, WE, OE, D, Q);

  input         CK;
  input  [17:0] A;
  input         WE;
  input         OE;
  input  [23:0] D;
  output [23:0] Q;

  reg    [23:0] Q;
  reg    [17:0] latched_A;
  reg    [17:0] latched_A_neg;
  reg    [23:0] memory [0:4096*15-1];

  always @(posedge CK) begin
  
    if (WE) begin
	
		memory[A] <= D;
		
    end
	
		latched_A <= A;
  end
  
  always@(negedge CK) begin
	latched_A_neg <= latched_A;
  end
  
  always @(*) begin
  
    if (OE) begin
	
      Q = memory[latched_A_neg];
	  
    end
    else begin
	
      Q = 24'hz;
	  
    end
	
  end

endmodule
