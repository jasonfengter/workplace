module BRAM_model_wr(
	i_clk,
	i_rstn,
	i_bram_addr,
	i_bram_data,
	i_bram_trig,
	o_bram_done
	
);
	parameter WRITE_LATENCY=0;  // Defined as: cyc# after 'trig' assertion being accepted
	input i_clk;
	input i_rstn;
	
	input [12:0] 	i_bram_addr;
	input [31:0] 	i_bram_data;
	input 			i_bram_trig;
	output 			o_bram_done;
	
	reg o_bram_done_pre;
	
	// IMPORTANT! 'done' signal must be suppressed when i_trig is down!
	assign o_bram_done = o_bram_done_pre & i_bram_trig;
	
	
	reg [7:0] latency_cnter;

	always@(posedge i_clk or negedge i_rstn) begin
		if(~i_rstn) begin
			//o_bram_data <= 32'd0;
			o_bram_done_pre <= 1'b0;
			latency_cnter<=8'd0;
		
			end
		else 
			begin
				if(i_bram_trig)
					begin
						
						if(latency_cnter==WRITE_LATENCY)
							begin
								o_bram_done_pre<=1'b1;
								//o_bram_data<=return_bram_data(i_bram_addr);
								$display ("Addr=%0h, Data=%0h" , i_bram_addr, i_bram_data);
							end
						else
							begin
								o_bram_done_pre<=1'b0;
								latency_cnter<=latency_cnter+1'b1;
						
								//do not touch o_bram_data
							end
					end
				else
					begin
						o_bram_done_pre<=1'b0;
						latency_cnter<=0;
					end
			end
	
	end

	
	function automatic [31:0] return_bram_data;
		input [12:0] addr;
		begin
				case(addr)
					13'd0: return_bram_data=32'h1234_5678;
					13'd1: return_bram_data=32'h8765_4321;
					13'd14: return_bram_data=32'h1010_1010;
					default: return_bram_data=32'hffff_ffff;
				endcase
		end
	endfunction

endmodule