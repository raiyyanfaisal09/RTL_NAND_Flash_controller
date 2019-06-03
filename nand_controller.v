module nand_controller #(parameter PACKET_LENGTH = 1024)(data_bus_host,
	clock,
	we_n,
	we_h,
	ce_n,
	ce_h,
	oe_h, 
	reset_h,
	addr_h,
	rb_h,
	cle_n,
	ale_n,
	re_n,
	data_bus_n,
	rb_n);
	
	inout [15:0] data_bus_n, data_bus_host;
	input [11:0] addr_h;
	input oe_h;
	reg [15:0] data_bus_nand;
	input we_h, ce_h, clock, reset_h, rb_n;
	output reg ce_n, cle_n, ale_n, we_n, re_n, rb_h;
	assign data_bus_n = data_bus_nand;
	reg [9:0] packet_counter;
reg [1:0] cmd_cycle_cnt;
reg start_program, start_erase;
reg [2:0] counter_add_cycle;
		reg [7:0] REGaddress [7:0];
		reg [7:0] data_buffer[1023:0];
		reg [7:0]CommandREG; 
	reg [9:0]dbf_addr;
	reg cmd_prgm_prog, cmd_prgm_2_prog, cmd_rd_st_prog, cmd_write_prog,
                                            add_latch_prog,
                                            add_write_en_prog,
                                            prgm_data_latch_prog,
                                            prgm_data_en_prog, cmd_prgm_erase, cmd_prgm_2_erase, cmd_rd_st_erase, cmd_write_erase,
                                                                                        add_latch_erase,
                                                                                        add_write_en_erase, 
                                                                                        
                     cmd_prgm,
                                                                                                                            cmd_prgm_2,
                                                                                                                            cmd_rd_st,
                                                                                                                            cmd_write,
                                                                                                                            add_latch,
                                                                                                                            add_write_en,
                                                                                                                            prgm_data_latch,
                                                                                                                            prgm_data_en;
                                            integer i=0;
                                            
       
	always@(posedge clock)
		begin
		if(reset_h)
			begin
					for(i=0;i<8;i=i+1)
					begin	
				        REGaddress[i] <= 8'h00;
						
					end
						CommandREG <= 8'h00;
						dbf_addr <= 8'h00;
			end
		else 
			begin
				if((addr_h == 12'hFF0 && we_h == 1'b0 && ce_h == 1'b0)) begin
						REGaddress[addr_h[3:0]] <= data_bus_host[7:0];
					end
				else if((addr_h == 12'hFF1 && we_h == 1'b0 && ce_h == 1'b0)) begin
						REGaddress[addr_h[3:0]] <= data_bus_host[7:0];
					end
				else if((addr_h == 12'hFF2 && we_h == 1'b0 && ce_h == 1'b0)) begin
						REGaddress[addr_h[3:0]] <= data_bus_host[7:0];
					end
				else if((addr_h == 12'hFF3 && we_h == 1'b0 && ce_h == 1'b0)) begin
						REGaddress[addr_h[3:0]] <= data_bus_host[7:0];
					end
				else if((addr_h == 12'hFF4 && we_h == 1'b0 && ce_h == 1'b0)) begin
						REGaddress[addr_h[3:0]] <= data_bus_host[7:0];
					end	
				else if((addr_h == 12'hFF5 && we_h == 1'b0 && ce_h == 1'b0)) begin
						data_buffer[dbf_addr] <= data_bus_host[7:0];
						if(dbf_addr == PACKET_LENGTH)
							dbf_addr <= 0;
						else
							dbf_addr <= dbf_addr + 1'b1;
					end	
				else if((addr_h == 12'hFFA && we_h == 1'b0 && ce_h == 1'b0)) begin
						CommandREG <= data_bus_host[7:0];
						if(data_bus_host[7:4]==4'h8) 
							start_program <= 1'b1;
						else if (data_bus_host[7:4]==4'h6)
							start_erase <= 1'b1;
					end
			end
			
		end 
	
	always@(*)
		begin
			if(start_program)
				begin
				cmd_prgm <= cmd_prgm_prog;
				cmd_prgm_2 <= cmd_prgm_2_prog;
				cmd_rd_st <= cmd_rd_st_prog;
				add_latch <= add_latch_prog;
				add_write_en <= add_write_en_prog;
				prgm_data_latch <= prgm_data_latch_prog;
				prgm_data_en <= prgm_data_en_prog;
				end
			else if (start_erase)
				begin
				cmd_prgm <= cmd_prgm_erase;
				cmd_prgm_2 <= cmd_prgm_2_erase;
				cmd_rd_st <= cmd_rd_st_erase;
				add_latch <= add_latch_erase;
				add_write_en <= add_write_en_erase;
				//prgm_data_latch <= prgm_data_latch_erase;
				//prgm_data_en <= prgm_data_en_erase;
				end
		end
		
	always@(posedge clock)
		begin
			if(reset)
				begin
				cle_n <= 1'b0;
				ale_n <= 1'b0;
				re_n <= 1'b1;
				we_n <= 1'b1;
				ce_n <= 1'b0;
				end
		
			else if(cmd_prgm)
				begin
				cle_n <= 1'b1;
				ale_n <= 1'b0;
				re_n <= 1'b1;
				we_n <= 1'b0;
				ce_n <= 1'b0;

				end
			else if (cmd_prgm_2)
				begin
				cle_n <= 1'b0;
				ale_n <= 1'b0;
				re_n <= 1'b1;
				we_n <= 1'b1;
				ce_n <= 1'b0;

				end
			else if (cmd_rd_st)
				begin
				cle_n <= 1'b1;
				ale_n <= 1'b0;
				re_n <= 1'b1;
				we_n <= 1'b0;
				ce_n <= 1'b0;

				end
			else if(add_latch)
				begin
				
				cle_n <= 1'b0;
				ale_n <= 1'b1;
				re_n <= 1'b1;
				we_n <= 1'b0;
				ce_n <= 1'b0;

				if(CommandREG[7:4] == 4'h8) begin
					if(counter_add_cycle == 3'b000)
						data_bus_nand[7:0] <= REGaddress[0 /*column address*/];
					else if(counter_add_cycle == 3'b001)
						data_bus_nand[7:0] <= REGaddress[1 /*column address*/];
					else if(counter_add_cycle == 3'b010)
						data_bus_nand[7:0] <= REGaddress[1 /*row address*/];
					else if(counter_add_cycle == 3'b011)
						data_bus_nand[7:0] <= REGaddress[1 /*row address*/];
					else if(counter_add_cycle == 3'b100)
						data_bus_nand[7:0] <= REGaddress[1 /*row address*/];
					end
				else if(CommandREG[7:4] == 4'h6) begin
					if(counter_add_cycle == 3'b001)
						data_bus_nand[7:0] <= REGaddress[1 /*row address*/];
					else if(counter_add_cycle == 3'b010)
						data_bus_nand[7:0] <= REGaddress[1 /*row address*/];
					else if(counter_add_cycle == 3'b011)
						data_bus_nand[7:0] <= REGaddress[1 /*row address*/];
				end
					
				end
			else if(add_write_en)
				begin
				cle_n <= 1'b0;
				ale_n <= 1'b1;
				re_n <= 1'b1;
				we_n <= 1'b1;
				ce_n <= 1'b0;

				end
			else if(prgm_data_latch)
				begin
				cle_n <= 1'b0;
				ale_n <= 1'b0;
				re_n <= 1'b1;
				we_n <= 1'b0;
				ce_n <= 1'b0;

				if(CommandREG[7:4] == 4'h8) begin
					data_bus_nand[7:0] <= data_buffer[packet_counter];
					end
					
				end
			else if(prgm_data_en)
				begin
				cle_n <= 1'b0;
				ale_n <= 1'b0;
				re_n <= 1'b1;
				we_n <= 1'b1;
				ce_n <= 1'b0;

				end
		end
		
		
		
always@(posedge clock)
		begin
			if(reset)
				cmd_cycle_cnt <= 0;
			else if(cmd_cycle_cnt == 2'b10)
				cmd_cycle_cnt <= 2'b00;
			else if(cmd_write) 
				cmd_cycle_cnt <= cmd_cycle_cnt + 1'b1;
		end
		
always@(posedge clock)
		begin
			if(reset)
				counter_add_cycle <= 0;
			else if(counter_add_cycle == 3'b100)
				counter_add_cycle <= 3'b000;
			else if(add_write_en)
				counter_add_cycle <= counter_add_cycle + 1'b1;
		end

always@(posedge clock)
		begin
			if(reset)
				packet_counter <= 0;
			else if(packet_counter == PACKET_LENGTH)
				packet_counter <= 0;
			else if(add_write_en)
				packet_counter <= packet_counter + 1'b1;
		end
				
		
program_nand  #(1024) DUTX (start_program, rb_n, clock, reset, CommandREG, data_bus_nand, cmd_cycle_cnt, packet_counter, counter_add_cycle, cmd_prgm_prog, cmd_prgm_2_prog, cmd_rd_st_prog, cmd_write_prog,
                                                    add_latch_prog,
                                                    add_write_en_prog,
                                                    prgm_data_latch_prog,
                                                    prgm_data_en_prog);
erase_nand DUT (start_erase,

	rb_n,
	clock,
	reset, 
	data_bus_nand,
	CommandREG,
	cmd_cycle_cnt,
	counter_add_cycle,
	cmd_prgm_erase, cmd_prgm_2_erase, cmd_rd_st_erase, cmd_write_erase,
                                                                                            add_latch_erase,
                                                                                            add_write_en_erase 
	);
	
				
				
endmodule
	
	
		
			
	
			
		