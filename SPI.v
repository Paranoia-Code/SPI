module SPI(
	input clk,
	input rst_n,
	input start,
	input [2:0]channel,
	
	//========ADC128S022===========//
	output reg SCLK,
	output reg DIN,
	output reg CS_N,
	input DOUT,
	
	output reg done,
	output reg [11:0]data
);

	reg en;
	reg [2:0]r_channel;
	reg [4:0]cnt;
	reg cnt_flag;
	reg [5:0]SCLK_CNT;
	reg [11:0]r_data;
	
//=============r_channel==================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			r_channel <= 'd0;
		else if(start)
			r_channel <= channel;
		else
			r_channel <= r_channel;
	end
	
//============转换使能信号==================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			en <= 1'b0;
		else if(start)
			en <= 1'b1;
		else if(done)
			en <= 1'b0;
		else
			en <= en;
	end
	
//==================cnt=====================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt <= 'd0;
		else if(en)begin
			if(cnt == 'd10)
				cnt <= 'd0;
			else
				cnt <= cnt + 1'b1;
		end
	else
		cnt <= 'd0;
	end
	
//===================cnt_flag===============//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			cnt_flag <= 1'b0;
		else if(cnt == 'd10)
			cnt_flag <= 1'b1;
		else
			cnt_flag <= 1'b0;
	end

//===============SCLK_CNT===================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			SCLK_CNT <= 'd0;
		else if(en)begin
			if(cnt_flag && (SCLK_CNT == 'd33))
				SCLK_CNT <= 'd0;
			else if(cnt_flag)
				SCLK_CNT <= SCLK_CNT + 1'b1;
			else
				SCLK_CNT <= SCLK_CNT;
		end
		else
			SCLK_CNT <= 'd0;
	end

//===========================================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)begin
			SCLK <= 1'b1;
			CS_N <= 1'b1;
			DIN <= 1'b1;
		end
		else if(en)begin
			if(cnt_flag)begin
				case(SCLK_CNT)
					6'd0:begin CS_N <= 1'b0;end
					6'd1:begin SCLK <= 1'b0;DIN <= 1'b0;end
					6'd2:begin SCLK <= 1'b1;end
					6'd3:begin SCLK <= 1'b0;end
					6'd4:begin SCLK <= 1'b1;end
					6'd5:begin SCLK <= 1'b0;DIN <= r_channel[2];end
					6'd6:begin SCLK <= 1'b1;end
					6'd7:begin SCLK <= 1'b0;DIN <= r_channel[1];end
					6'd8:begin SCLK <= 1'b1;end
					6'd9:begin SCLK <= 1'b0;DIN <= r_channel[0];end
					6'd10,6'd12,6'd14,6'd16,6'd18,6'd20,6'd22,6'd24,6'd26,6'd28,6'd30,6'd32:
						begin SCLK <= 1'b1;r_data <= {r_data[10:0],DOUT};end
					6'd11,6'd13,6'd15,6'd17,6'd19,6'd21,6'd23,6'd25,6'd27,6'd29,6'd31:
						begin SCLK <= 1'b0;end
					6'd33:begin CS_N <= 1'b1;end
					default:begin CS_N <= 1'b1;end
				endcase
			end
			else ;
		end
		else begin
			SCLK <= 1'b1;
			CS_N <= 1'b1;
			DIN <= 1'b1;
		end
	end
	
//================done=================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			done <= 1'b0;
		else if(cnt_flag && (SCLK_CNT == 'd33))
			done <= 1'b1;
		else
			done <= 1'b0;
	end
	
//================data=================//
	always@(posedge clk or negedge rst_n)begin
		if(!rst_n)
			data <= 'd0;
		else if(cnt_flag && (SCLK_CNT == 'd33))
			data <= r_data;
		else
			data <= data;
	end

endmodule
