/////////////////////////////////////////////////////////////////////
// ---------------------- IVCAD 2022 Spring ---------------------- //
// ---------------------- Version : v.1.10  ---------------------- //
// ---------------------- Date : 2022.04.13 ---------------------- //
// --------------------- Controller module ------------------------//
// ----------------- Feb. 2022 Willie authored --------------------//
/////////////////////////////////////////////////////////////////////

module Controller(clk, rst, D_update, W_update, RAM_IF_A, RAM_IF_OE, RAM_W_A, RAM_W_WE, RAM_RESULT_A, RAM_RESULT_WE, done);

// ---------------------- input  ---------------------- //
	input clk;
	input rst;

// ---------------------- output  ---------------------- //	
	output reg D_update;
	output reg W_update;
	output reg [17:0] RAM_IF_A;
	output reg RAM_IF_OE;
	output reg [17:0] RAM_W_A;
	output reg RAM_W_WE;
	output reg [17:0] RAM_RESULT_A;
	output reg RAM_RESULT_WE;
	output reg done;
	
// ---------------------- Write down Your design below  ---------------------- //

reg [2:0] st, ns;

parameter  INI = 3'd0,
           READ = 3'd1,
           MAN_MIN_SEL = 3'd2,
           UPDATE = 3'd3,
           W_WEIGHT = 3'd4,
           W_PIC = 3'd5,
           DONE = 3'd6;
reg [17:0]counter;

always@(posedge clk or posedge rst)
begin
	if(rst)
	begin
		st <= INI;
		counter <= 18'd0;
	end
	else begin
        	st <= ns;
		counter <= counter + 18'd1;
	end
end


always @(st or counter) begin 
	case(st)
		INI		: ns = MAN_MIN_SEL;
		MAN_MIN_SEL	: ns = UPDATE;
		UPDATE		: ns = (counter<18'd81920)?MAN_MIN_SEL:W_WEIGHT;
		W_WEIGHT	: ns = (counter<18'd81984)?W_WEIGHT:W_PIC;
		W_PIC		: ns = (counter<18'd102466)?W_PIC:DONE;
		DONE		: ns = DONE;
		default		: ns = DONE;
	endcase
end

always @(st or counter) begin

	case(st)
		INI		: begin
			D_update = 1'd0;
			W_update = 1'd0;
			RAM_IF_A = 18'd0;
			RAM_IF_OE = 1'd0;
			RAM_W_A = 18'd0;
			RAM_W_WE = 1'd0;
			RAM_RESULT_A = 18'd0;
			RAM_RESULT_WE = 1'd0;
			done = 1'd0;
		end
		MAN_MIN_SEL	:begin
			D_update = 1'd1;
			W_update = 1'd0;
			RAM_IF_A = counter/2;
			RAM_IF_OE = 1'd1;
			RAM_W_A =  18'd0;
			RAM_W_WE = 1'd0;
			RAM_RESULT_A = 18'd0;
			RAM_RESULT_WE = 1'd0;
			done = 1'd0;
		end
		UPDATE		:begin
			D_update = 1'd0;
			W_update = 1'd1;
			RAM_IF_A =counter/2;
			RAM_IF_OE = 1'd1;
			RAM_W_A =  18'd0;
			RAM_W_WE = 1'd0;
			RAM_RESULT_A = 18'd0;
			RAM_RESULT_WE = 1'd0;
			done = 1'd0;
		end
		W_WEIGHT	:begin
			D_update = 1'd0;
			W_update = 1'd0;
			RAM_IF_A = 18'd0;
			RAM_IF_OE = 1'd0;
			RAM_W_A = counter-18'd81921;
			RAM_W_WE = 1'd1;
			RAM_RESULT_A = 18'd0;
			RAM_RESULT_WE = 1'd0;
			done = 1'd0;
		end
		W_PIC		:begin
			D_update = 1'd1;
			W_update = 1'd0;
			RAM_IF_A = counter - 18'd41025;
			RAM_IF_OE = 1'd1;
			RAM_W_A = 18'd0;
			RAM_W_WE = 1'd0;
			RAM_RESULT_A = counter - 18'd81987;
			RAM_RESULT_WE = 1'd1;
			done = 1'd0;
		end
		DONE		:begin
			D_update = 1'd0;
			W_update = 1'd0;
			RAM_IF_A = 18'd0;
			RAM_IF_OE = 1'd1;
			RAM_W_A = 18'd0;
			RAM_W_WE = 1'd0;
			RAM_RESULT_A = 18'd0;
			RAM_RESULT_WE = 1'd0;
			done = 1'd1;
		end
		default		:begin
			D_update = 1'd0;
			W_update = 1'd0;
			RAM_IF_A = 18'd0;
			RAM_IF_OE = 1'd0;
			RAM_W_A = 18'd0;
			RAM_W_WE = 1'd0;
			RAM_RESULT_A = 18'd0;
			RAM_RESULT_WE = 1'd0;
			done = 1'd1;
		end
	endcase
	
end

endmodule
