`timescale 1ns/1ps

module NAND_controller_testbench();
reg	CE;
reg	WE;
reg	OE;
reg	CLK;
reg	RESET;
wire	RnB;
reg	[15:0] DATA;
reg	[11:0] ADDRESS;
wire	CE_n;
wire	WE_n;
reg	RnB_n;
wire	CLE_n;
wire ALE_n;
reg	[15:0] data_n;
wire RE_n;

nand_controller #(1024) UI(
	DATA,
	CLK,
	WE_n,
	WE,
	CE_n,
	CE,
	OE, 
	RESET,
	ADDRESS,
	RnB,
	CLE_n,
	ALE_n,
	RE,
	data_n,
	RnB_n
);

reg [15:0] read_reg;

always
#10 CLK = ~CLK;

initial 
begin
	CLK = 1'b0;
	RESET = 1'b0;
#20 RESET = 1'b1;
#20 RESET = 1'b0;
/*** RESET OPERATION ***/
reset_state();
/*** ERASE OPERATION  ***/
erase_state(data_n,read_reg);
/*** PROGRAM OPERATION  ***/
program_state(data_n,read_reg);	
/*** READ OPERATION  ***/
read_state(data_n,read_reg);
$finish;
end



/*** TASK ***/
/*** RESET ***/
task reset_state;
		reg CE;
		reg WE;
		reg OE;
		reg [11:0] ADDRESS;
		reg [15:0] DATA;
		//Read from the buffer that the host controls
		CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFFA;//ffa register address
		DATA = 16'hFFFF;
		//reset operation
#60 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b1;
endtask
/*** ERASE ***/
task erase_state;
		reg CE;
		reg WE;
		reg OE;
		reg [11:0] ADDRESS;
		reg [15:0] DATA;
		reg RnB_n;
		reg [15:0] data_n;
		reg [15:0] read_reg;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF6F;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF2;
		DATA = 16'hFF60; 
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF3;
		DATA = 16'hFF70; 
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF4;
		DATA = 16'hFF80; 
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF6F;
#20 RnB_n = 1'b0;
#20 RnB_n = 1'b1;
#20 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b0;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF7F;	
		data_n = 16'h0000;
		read_reg = data_n;
#60 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b1;
endtask
/*** PROGRAM ***/
task program_state;
		reg CE;
		reg WE;
		reg OE;
		reg [11:0] ADDRESS;
		reg [15:0] DATA;
		reg RnB_n;
		reg [15:0] data_n;
		reg [15:0] read_reg;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF8F;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF0;
		DATA = 16'h0070;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF1;
		DATA = 16'h0080;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF2;
		DATA = 16'h000A;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF3;
		DATA = 16'h000B;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF4;
		DATA = 16'h000C; 	
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF8F;
#20 RnB_n = 1'b0;
#20 RnB_n = 1'b1;
#20 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b0;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF7F;	
		data_n = 16'h0000;
		read_reg = data_n;
#60 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b1;	
endtask
/*** READ ***/
task read_state;
		reg CE;
		reg WE;
		reg OE;
		reg [11:0] ADDRESS;
		reg [15:0] DATA;
		reg RnB_n;
		reg [15:0] data_n;
		reg [15:0] read_reg;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF0F;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF0;
		DATA = 16'h0070;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hF1;
		DATA = 16'h0080;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF2;
		DATA = 16'h000A;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF3;
		DATA = 16'h000B;
#20 CE = 1'b0;
		WE = 1'b0;
		OE = 1'b1;
		ADDRESS = 12'hFF4;
		DATA = 16'h000C;
#20 RnB_n = 1'b0;
#20 RnB_n = 1'b1;
#20 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b0;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF7F;
#20 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b0;
		ADDRESS = 12'hFFA;
		DATA = 16'hFF0F;
		data_n = 16'h0000;
		read_reg = data_n;
#60 CE = 1'b0;
		WE = 1'b1;
		OE = 1'b1;		

endtask

endmodule




