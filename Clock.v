module Clock(input wire clk,
             input wire reset,
				// input wire alarm,
				 //input wire time_set,
				 input wire [15:0]btn,
				 output wire [6:0] seg_A1,   // 时十位数
             output wire [6:0] seg_A0,   // 时个位数
             output wire [6:0] seg_B1,   // 分十位数
             output wire [6:0] seg_B0,    // 分个位数
				 output wire [3:0]sel,        //位选
				 output wire beep,
				 output wire beep_timer,
             output wire beep_alarm				 
             );
 //wire beep1;
 wire select_enable;
 wire [2:0]select;
 

 wire timer_cont;
 wire timer_finishflag;
 wire [3:0]timer_hd;
 wire [3:0]timer_hg;
 wire [3:0]timer_md;
 wire [3:0]timer_mg;
 
 wire [3:0]timer_hd_in;  //倒数计时
 wire [3:0]timer_hg_in;
 wire [3:0]timer_md_in;
 wire [3:0]timer_mg_in;
 
 wire [3:0]num_hd;
 wire [3:0]num_hg;
 wire [3:0]num_md;
 wire [3:0]num_mg;
 
 wire [3:0]minute_d; //个
 wire [3:0]minute_g;  //十
 wire [3:0]hour_d;
 wire [3:0]hour_g;
 
 wire [3:0]hour_dd; //闹钟个
 wire [3:0]hour_gg;  //十
 wire [3:0]minute_dd;
 wire [3:0]minute_gg;
 
 wire [3:0]store_hd,store_hg, store_md,store_mg;  //按键数字显示
 wire [1:0]switch;
 
 wire clk_1Hz;
 wire clk_2Hz;
 wire clk_100Hz;
 wire clk_1KHz;
 wire clk_60s;
 wire high; 
 fenpin fp(.clk(clk),
           .clk_1HZ(clk_1Hz),
			  .clk_2HZ(clk_2Hz),
			  .clk_100HZ(clk_100Hz),
			  .clk_1KHZ(clk_1KHz),
			  .clk_60s(clk_60s),
			  .high(high));
 clock cont(.CLK_60s(clk),
            .CLK_1Hz(clk),
				.reset(reset),
				.select(select),
				.select_enable(select_enable),
				.num_hd(num_hd),
				.num_mg(num_mg),
				.num_md(num_md),
				.num_hg(num_hg),
				.minute_d(minute_d),
				.minute_g(minute_g),
				.hour_d(hour_d),
				.hour_g(hour_g)
				);
 
 display dis(.CLK_60s(clk),
             .CLK_1kHz(clk),
             .CLK_2Hz(clk),
				 .minute_d(minute_d),
				 .minute_g(minute_g), 
				 .hour_d(hour_d), 
				 .hour_g(hour_g),
				 .time_led_hg(seg_A1), 
				 .time_led_hd(seg_A0),
				 .time_led_mg(seg_B1),
				 .time_led_md(seg_B0), 
				 .warn_led(beep), 
				 .sel(sel),
				 .minute_dd(minute_dd), 
				 .minute_gg(minute_gg),
				 .hour_dd(hour_dd), 
				 .hour_gg(hour_gg),
				 .switch(switch),
				 .store_hd(store_hd),
				 .store_hg(store_hg),
				 .store_md(store_md),
				 .store_mg(store_mg),
				 .beep_alarm(beep_alarm),
				 .timer_hd(timer_hd_in),
				 .timer_hg(timer_hg_in),
				 .timer_md(timer_md_in),
				 .timer_mg(timer_mg_in)
				
				 );
 control ctl(.clk(clk), 
             .key_press(btn), 
				 .num_hd(num_hd), 
				 .num_hg(num_hg), 
				 .num_md(num_md), 
				 .num_mg(num_mg), 
				 //.wrong_led(beep),
				 .switch(switch), 
				 .hour_gg(hour_gg),
				 .hour_dd(hour_dd),
				 .minute_gg(minute_gg),
				 .minute_dd(minute_dd),
				 .select_enable(select_enable),
				 .store_hd(store_hd),
				 .store_hg(store_hg),
				 .store_md(store_md),
				 .store_mg(store_mg),
				 .timer_hd(timer_hd),
				 .timer_hg(timer_hg),
				 .timer_md(timer_md),
				 .timer_mg(timer_mg),
				 .timer_cont(timer_cont),
				 .timer_finishflag(timer_finishflag)
				 );
timer tmr(.CLK_60s(clk), 
          .timer_cont(timer_cont),
		    .timer_finishflag(timer_finishflag),
		    .timer_md_in(timer_md_in),
		    .timer_mg_in(timer_mg_in),
		    .timer_hd_in(timer_hd_in),
		    .timer_hg_in(timer_hg_in),
		    .timer_hd(timer_hd),
		    .timer_hg(timer_hg),
		    .timer_md(timer_md),
		    .timer_mg(timer_mg),
			 .beep_timer(beep_timer)
		    );

endmodule




/////////////////////////////////分频模块

module fenpin (clk,clk_1HZ,clk_2HZ,clk_100HZ,clk_1KHZ,clk_60s,high);
input clk;
output clk_1HZ,clk_2HZ,clk_100HZ,clk_1KHZ,clk_60s,high;
reg clk_1HZ,clk_2HZ,clk_100HZ,clk_1KHZ,clk_60s,high;
reg[26:0] count1=0,count2=0,count3=0,count4=0;
reg[31:0] count5=0;
always@(*)
begin
	high<=1;
end

always@(posedge clk)
begin 
        count1<=count1+1;

        if(count1<25000000)
                clk_1HZ<=1;
        else if(count1<49999999)
                clk_1HZ<=0;
        if(count1==49999999)
                count1<=0;
            
        count2<=count2+1;
        
        if(count2<12500000)
                clk_2HZ<=1;
        else if(count2<24999999)
                clk_2HZ<=0;  
        if(count2==24999999)
                count2<=0;
            
        count3<=count3+1;

        if(count3<250000)
                clk_100HZ<=1;
        else if(count3<499999)
                clk_100HZ<=0;  
        if(count3==499999)
                count3<=0;
                
        count4<=count4+1;

        if(count4<25000)
                clk_1KHZ<=1;
        else if(count4<49999)
                clk_1KHZ<=0;  
        if(count4==49999)
                count4<=0;
			
		  count5<=count5+1;

        if(count5<30)
                clk_60s<=1;
        else if(count5<59)
                clk_60s<=0;  
        if(count5==59)
                count5<=0;

end
endmodule




/////////////////////时钟计数逻辑
module clock(CLK_60s,CLK_1Hz, reset, select, select_enable, num_hd,num_hg,num_mg,num_md,minute_d, minute_g, hour_d, hour_g); 
input CLK_60s,CLK_1Hz; 
input reset,select_enable;
input[2:0] select;
input [3:0] num_md;
input [3:0] num_mg;
input [3:0] num_hd;
input [3:0] num_hg;
output  reg[3:0]  minute_d, minute_g, hour_d, hour_g; 
wire   cout_m; 
wire [3:0]reg_num_hd;
wire [3:0]reg_num_hg;
wire [3:0]reg_num_md;
wire [3:0]reg_num_mg;

 //////////////////////////////////////////////////////////////////////
 
always @(posedge CLK_60s)  
begin  
  if(!reset) begin minute_d<=4'd0; end
   else if(select_enable==1) begin
	    if(num_md==4'd9) minute_d<=4'd0;
		 else minute_d<=num_md+4'd1;
       end   
    else if(minute_d==4'd9)  begin
    minute_d<=4'd0;  end
    else  begin
    minute_d<=minute_d+4'd1; end
	end 
  
always @(posedge CLK_60s)  
begin  
  if(!reset) minute_g<=4'd5;
    else if(select_enable==1)  begin
		minute_g<=num_mg;
      end 
    else if(minute_d==4'd9)  
      begin  
      if(minute_g==4'd5)  
         begin minute_g<=4'd0; end 
      else  begin
        minute_g<=minute_g+4'd1; end 
      end
   end	 
     
assign cout_m=((minute_d==4'd9)&&(minute_g==4'd5))?1:0; 
 
 
always @(posedge CLK_60s)  
begin
  if(!reset)  
        hour_d <= 4'd1;
  else if(select_enable==1) hour_d<=num_hd;
   else if(cout_m)  
    begin  
    if((hour_d==4'd3)&&(hour_g==4'd2))  
      hour_d<=4'd0;  
    else if(hour_d==4'd9)  
       begin hour_d <=4'd0;  end
     else  begin
        hour_d <= hour_d + 4'd1;  end
      end    
	  
  end
 
always @(posedge CLK_60s)  
begin 
  if(!reset)  
        hour_g <= 4'd1; 
   else if(select_enable==1) hour_g<=num_hg;
   else if(cout_m)  
     begin
      if((hour_d==4'd3)&&(hour_g==4'd2))  
        begin hour_g <= 4'd0;  end
      else begin if(hour_d==4'd9) begin 
        hour_g<=hour_g+4'd1;  end
		  end
		 end
end
 
 
endmodule




//////////////////////////////////倒计时模块

module timer(CLK_60s, timer_cont,timer_finishflag,timer_md_in,timer_mg_in,timer_hd_in,timer_hg_in,timer_hd,timer_hg,timer_md,timer_mg,beep_timer);
input CLK_60s;
input timer_cont;
output reg timer_finishflag;
output reg beep_timer;
input [3:0] timer_hd,timer_hg,timer_md,timer_mg;
output reg[3:0] timer_md_in,timer_mg_in,timer_hd_in,timer_hg_in;

reg ready_hd=0;
reg ready_hg=0;
reg ready_md=0;
reg ready_mg=0;

always @(posedge CLK_60s)  
begin  
  if(timer_cont==1) begin
    if(ready_md==0)begin timer_md_in<=timer_md; ready_md<=1; end  
    else if(ready_md==1)begin  //&&timer_hg_in!=0&&timer_hd_in!=0&&timer_mg_in!=0&&timer_md_in!=0
	 if(timer_md_in==4'd0)  begin
       timer_md_in<=4'd9;  end
    else  begin
    timer_md_in<=timer_md_in-4'd1; end
	  end
	 end
	else if(timer_cont==0)
		begin
			ready_md<=0;
		end
end
  
  
always @(posedge CLK_60s)  
begin  
  if(timer_cont==1) begin
        if(ready_mg==0)begin timer_mg_in<=timer_mg; ready_mg<=1; end  
    else if(timer_md_in==4'd0)  
      begin  
      if(timer_mg_in==4'd0)  
          timer_mg_in<=4'd9; 
      else  
        timer_mg_in<=timer_mg_in-4'd1;
      end
   end	
  else if(timer_cont==0)
		begin
			ready_mg<=0;
		end	
 end  

   
assign cout_tm=((timer_md_in==4'd0)&&(timer_mg_in==4'd0))?1:0;
 
 
 
 
 
 
always @(posedge CLK_60s)  
begin
  if(timer_cont==1) begin 
    if(ready_hd==0)begin timer_hd_in<=timer_hd; ready_hd<=1; end  
    else begin
    if(cout_tm)  
    begin  
    if(timer_hd_in==4'd0)  begin
       timer_hd_in<=4'd9;  end
    else  begin
    timer_hd_in<=timer_hd_in-4'd1; end
	   end 
	  end
  end
  else if(timer_cont==0)
		begin
			ready_hd<=0;
		end
end
 
always @(posedge CLK_60s)  
begin 
  if(timer_cont==1) begin 
      if(ready_hg==0)begin timer_hg_in<=timer_hg; ready_hg<=1; end  
    else begin
        if(cout_tm)  
     begin
      if(timer_hd_in==4'd0)  
      begin  
      if(timer_hg_in==4'd0)  
          timer_hg_in<=4'd9;  
      else 
        timer_hg_in<=timer_hg_in-4'd1; 
              end
		    end
		  end
		end
		else if(timer_cont==0)
		begin
			ready_hg<=0;
		end
		
end
 
//assign timer_finishflag<=(timer_cont==1&&timer_hg==0&&timer_hd==0&&timer_mg==0&&timer_md==0)?1:0;

always@(posedge CLK_60s)
begin
      if(ready_md==1&&timer_cont==1&&timer_hg_in==0&&timer_hd_in==0&&timer_mg_in==0&&timer_md_in==1)
		   begin
			beep_timer=1;
			timer_finishflag<=1;
			//ready<=0;
			end
		else begin 
		beep_timer<=0;
		timer_finishflag<=0;
		end
		
end

endmodule




////////////////////////////////数码管显示
module display(CLK_60s, CLK_1kHz, CLK_2Hz, minute_d, minute_g, hour_d, hour_g, time_led_hg,time_led_hd,time_led_mg,time_led_md, warn_led, sel, hour_dd, hour_gg,minute_dd, minute_gg, switch,store_hd,store_hg,store_md,store_mg,beep_alarm,timer_hd,timer_hg,timer_md,timer_mg);
//input timer_cont;
//output reg timer_finishflag;
input CLK_1kHz, CLK_2Hz,CLK_60s;
input [1:0] switch;
input[3:0]  minute_d, minute_g, hour_d, hour_g;
input[3:0] store_hd,store_hg,store_md,store_mg;
input[3:0] timer_hd,timer_hg,timer_md,timer_mg;
input[3:0]  hour_dd, hour_gg,minute_dd, minute_gg;
output[6:0]   time_led_hd,time_led_hg,time_led_md,time_led_mg;
output        warn_led;
output[3:0]   sel;
output reg beep_alarm;
//output reg beep_timer;

//reg[3:0]    timer_hd_in=4'd1;
//reg[3:0] timer_hg_in,timer_md_in,timer_mg_in;
reg[6:0]    time_led_reg_hd,time_led_reg_hg,time_led_reg_md,time_led_reg_mg;
reg        warn_led_reg;
reg[3:0]   sel_reg;
reg[3:0]   disp_data;
wire   reset;
wire   cout_tm; 
reg ready_hd=0;
reg ready_hg=0;
reg ready_md=0;
reg ready_mg=0;
//reg    line_count;
//reg[3:0]    line;
assign reset=1'b1;
//time

always@(posedge CLK_1kHz)
begin
    if(!reset) begin
        sel_reg<=4'b0000; 
  	 end 
	  else begin 
	     if(sel_reg == 4'b1000) begin
        sel_reg<=4'b0001; end 
      else begin if(sel_reg == 4'b0001) begin
        sel_reg<=4'b0010; end 
	     else begin 
	    if(sel_reg == 4'b0010) begin
        sel_reg<=4'b0100; end 
	       else begin 
		 if(sel_reg == 4'b0100) begin
        sel_reg<=4'b1000; end 
	          else begin sel_reg<=4'b0001; end
	          end
	        end
		  end
		end
end


always@(*)
begin
    if(!reset) begin
        time_led_reg_hd<=7'b1111111;
		  time_led_reg_hg<=7'b1111111;
		  time_led_reg_mg<=7'b1111111;
		  time_led_reg_md<=7'b1111111;
	 end else if(switch==2'b01)
	 begin
	 case(hour_dd)
            0: time_led_reg_hd = 7'b1000000;
            1: time_led_reg_hd = 7'b1111001;
            2: time_led_reg_hd = 7'b0100100;
            3: time_led_reg_hd = 7'b0110000;
            4: time_led_reg_hd = 7'b0011001;
            5: time_led_reg_hd = 7'b0010010;
            6: time_led_reg_hd = 7'b0000010;
            7: time_led_reg_hd = 7'b1111000;
            8: time_led_reg_hd = 7'b0000000;
            9: time_led_reg_hd = 7'b0010000;
            default: time_led_reg_hd = 7'b1111111;
       endcase	 
		 case(hour_gg)
            0: time_led_reg_hg = 7'b1000000;
            1: time_led_reg_hg = 7'b1111001;
            2: time_led_reg_hg = 7'b0100100;
            3: time_led_reg_hg = 7'b0110000;
            4: time_led_reg_hg = 7'b0011001;
            5: time_led_reg_hg = 7'b0010010;
            6: time_led_reg_hg = 7'b0000010;
            7: time_led_reg_hg = 7'b1111000;
            8: time_led_reg_hg = 7'b0000000;
            9: time_led_reg_hg = 7'b0010000;
            default: time_led_reg_hg = 7'b1111111;
       endcase		 
		 case(minute_gg)
            0: time_led_reg_mg = 7'b1000000;
            1: time_led_reg_mg = 7'b1111001;
            2: time_led_reg_mg = 7'b0100100;
            3: time_led_reg_mg = 7'b0110000;
            4: time_led_reg_mg = 7'b0011001;
            5: time_led_reg_mg = 7'b0010010;
            6: time_led_reg_mg = 7'b0000010;
            7: time_led_reg_mg = 7'b1111000;
            8: time_led_reg_mg = 7'b0000000;
            9: time_led_reg_mg = 7'b0010000;
            default: time_led_reg_mg = 7'b1111111;
       endcase		 
		 case(minute_dd)
            0: time_led_reg_md = 7'b1000000;
            1: time_led_reg_md = 7'b1111001;
            2: time_led_reg_md = 7'b0100100;
            3: time_led_reg_md = 7'b0110000;
            4: time_led_reg_md = 7'b0011001;
            5: time_led_reg_md = 7'b0010010;
            6: time_led_reg_md = 7'b0000010;
            7: time_led_reg_md = 7'b1111000;
            8: time_led_reg_md = 7'b0000000;
            9: time_led_reg_md = 7'b0010000;
            default: time_led_reg_md = 7'b1111111;
       endcase
	   end
		
	  else if(switch==2'b10)
	      begin
			case(timer_hd)
            0: time_led_reg_hd = 7'b1000000;
            1: time_led_reg_hd = 7'b1111001;
            2: time_led_reg_hd = 7'b0100100;
            3: time_led_reg_hd = 7'b0110000;
            4: time_led_reg_hd = 7'b0011001;
            5: time_led_reg_hd = 7'b0010010;
            6: time_led_reg_hd = 7'b0000010;
            7: time_led_reg_hd = 7'b1111000;
            8: time_led_reg_hd = 7'b0000000;
            9: time_led_reg_hd = 7'b0010000;
            default: time_led_reg_hd = 7'b1111111;
       endcase
		 
		 case(timer_hg)
            0: time_led_reg_hg = 7'b1000000;
            1: time_led_reg_hg = 7'b1111001;
            2: time_led_reg_hg = 7'b0100100;
            3: time_led_reg_hg = 7'b0110000;
            4: time_led_reg_hg = 7'b0011001;
            5: time_led_reg_hg = 7'b0010010;
            6: time_led_reg_hg = 7'b0000010;
            7: time_led_reg_hg = 7'b1111000;
            8: time_led_reg_hg = 7'b0000000;
            9: time_led_reg_hg = 7'b0010000;
            default: time_led_reg_hg = 7'b1111111;
       endcase
		 
		 case(timer_mg)
            0: time_led_reg_mg = 7'b1000000;
            1: time_led_reg_mg = 7'b1111001;
            2: time_led_reg_mg = 7'b0100100;
            3: time_led_reg_mg = 7'b0110000;
            4: time_led_reg_mg = 7'b0011001;
            5: time_led_reg_mg = 7'b0010010;
            6: time_led_reg_mg = 7'b0000010;
            7: time_led_reg_mg = 7'b1111000;
            8: time_led_reg_mg = 7'b0000000;
            9: time_led_reg_mg = 7'b0010000;
            default: time_led_reg_mg = 7'b1111111;
       endcase
		 
		 case(timer_md)
            0: time_led_reg_md = 7'b1000000;
            1: time_led_reg_md = 7'b1111001;
            2: time_led_reg_md = 7'b0100100;
            3: time_led_reg_md = 7'b0110000;
            4: time_led_reg_md = 7'b0011001;
            5: time_led_reg_md = 7'b0010010;
            6: time_led_reg_md = 7'b0000010;
            7: time_led_reg_md = 7'b1111000;
            8: time_led_reg_md = 7'b0000000;
            9: time_led_reg_md = 7'b0010000;
            default: time_led_reg_md = 7'b1111111;
       endcase
		 end

	  else if(switch==2'b11)
	      begin
			case(store_hd)
            0: time_led_reg_hd = 7'b1000000;
            1: time_led_reg_hd = 7'b1111001;
            2: time_led_reg_hd = 7'b0100100;
            3: time_led_reg_hd = 7'b0110000;
            4: time_led_reg_hd = 7'b0011001;
            5: time_led_reg_hd = 7'b0010010;
            6: time_led_reg_hd = 7'b0000010;
            7: time_led_reg_hd = 7'b1111000;
            8: time_led_reg_hd = 7'b0000000;
            9: time_led_reg_hd = 7'b0010000;
            default: time_led_reg_hd = 7'b1111111;
       endcase
		 
		 case(store_hg)
            0: time_led_reg_hg = 7'b1000000;
            1: time_led_reg_hg = 7'b1111001;
            2: time_led_reg_hg = 7'b0100100;
            3: time_led_reg_hg = 7'b0110000;
            4: time_led_reg_hg = 7'b0011001;
            5: time_led_reg_hg = 7'b0010010;
            6: time_led_reg_hg = 7'b0000010;
            7: time_led_reg_hg = 7'b1111000;
            8: time_led_reg_hg = 7'b0000000;
            9: time_led_reg_hg = 7'b0010000;
            default: time_led_reg_hg = 7'b1111111;
       endcase
		 
		 case(store_mg)
            0: time_led_reg_mg = 7'b1000000;
            1: time_led_reg_mg = 7'b1111001;
            2: time_led_reg_mg = 7'b0100100;
            3: time_led_reg_mg = 7'b0110000;
            4: time_led_reg_mg = 7'b0011001;
            5: time_led_reg_mg = 7'b0010010;
            6: time_led_reg_mg = 7'b0000010;
            7: time_led_reg_mg = 7'b1111000;
            8: time_led_reg_mg = 7'b0000000;
            9: time_led_reg_mg = 7'b0010000;
            default: time_led_reg_mg = 7'b1111111;
       endcase
		 
		 case(store_md)
            0: time_led_reg_md = 7'b1000000;
            1: time_led_reg_md = 7'b1111001;
            2: time_led_reg_md = 7'b0100100;
            3: time_led_reg_md = 7'b0110000;
            4: time_led_reg_md = 7'b0011001;
            5: time_led_reg_md = 7'b0010010;
            6: time_led_reg_md = 7'b0000010;
            7: time_led_reg_md = 7'b1111000;
            8: time_led_reg_md = 7'b0000000;
            9: time_led_reg_md = 7'b0010000;
            default: time_led_reg_md = 7'b1111111;
       endcase
		 end		 
	  
	  
	  else //if(switch==2'b00) 
	  begin
        case(hour_d)
            0: time_led_reg_hd = 7'b1000000;
            1: time_led_reg_hd = 7'b1111001;
            2: time_led_reg_hd = 7'b0100100;
            3: time_led_reg_hd = 7'b0110000;
            4: time_led_reg_hd = 7'b0011001;
            5: time_led_reg_hd = 7'b0010010;
            6: time_led_reg_hd = 7'b0000010;
            7: time_led_reg_hd = 7'b1111000;
            8: time_led_reg_hd = 7'b0000000;
            9: time_led_reg_hd = 7'b0010000;
            default: time_led_reg_hd = 7'b1111111;
       endcase
		 
		 case(hour_g)
            0: time_led_reg_hg = 7'b1000000;
            1: time_led_reg_hg = 7'b1111001;
            2: time_led_reg_hg = 7'b0100100;
            3: time_led_reg_hg = 7'b0110000;
            4: time_led_reg_hg = 7'b0011001;
            5: time_led_reg_hg = 7'b0010010;
            6: time_led_reg_hg = 7'b0000010;
            7: time_led_reg_hg = 7'b1111000;
            8: time_led_reg_hg = 7'b0000000;
            9: time_led_reg_hg = 7'b0010000;
            default: time_led_reg_hg = 7'b1111111;
       endcase
		 
		 case(minute_g)
            0: time_led_reg_mg = 7'b1000000;
            1: time_led_reg_mg = 7'b1111001;
            2: time_led_reg_mg = 7'b0100100;
            3: time_led_reg_mg = 7'b0110000;
            4: time_led_reg_mg = 7'b0011001;
            5: time_led_reg_mg = 7'b0010010;
            6: time_led_reg_mg = 7'b0000010;
            7: time_led_reg_mg = 7'b1111000;
            8: time_led_reg_mg = 7'b0000000;
            9: time_led_reg_mg = 7'b0010000;
            default: time_led_reg_mg = 7'b1111111;
       endcase
		 
		 case(minute_d)
            0: time_led_reg_md = 7'b1000000;
            1: time_led_reg_md = 7'b1111001;
            2: time_led_reg_md = 7'b0100100;
            3: time_led_reg_md = 7'b0110000;
            4: time_led_reg_md = 7'b0011001;
            5: time_led_reg_md = 7'b0010010;
            6: time_led_reg_md = 7'b0000010;
            7: time_led_reg_md = 7'b1111000;
            8: time_led_reg_md = 7'b0000000;
            9: time_led_reg_md = 7'b0010000;
            default: time_led_reg_md = 7'b1111111;
       endcase
		 
    end
	 
end


//warn    整点报时功能
always @(posedge CLK_2Hz)  
begin  
    if(!reset)   
    begin  
        warn_led_reg<=0;
        end  
    else
	    begin
			if(minute_d==9&&minute_g==5)begin
				warn_led_reg<=~warn_led_reg; end
			else begin warn_led_reg<=0; end
		end
end

   always @(posedge CLK_2Hz)
     begin
	   if(minute_d==minute_dd-4'd1&&minute_g==minute_gg&&hour_d==hour_dd&&hour_g==hour_gg)
		  beep_alarm=1;
		 else beep_alarm<=0;
		end
 


 
assign time_led_hd = time_led_reg_hd;
assign time_led_hg = time_led_reg_hg;
assign time_led_md = time_led_reg_md;
assign time_led_mg = time_led_reg_mg;
assign warn_led = warn_led_reg;
assign sel = sel_reg;

endmodule





/////////////////////////////控制模块
module control(timer_finishflag,timer_cont,clk, key_press, num_hd, num_hg, num_md, num_mg,switch, hour_gg,hour_dd,minute_gg,minute_dd,select_enable,store_hd,store_hg,store_md,store_mg,timer_hd,timer_hg,timer_md,timer_mg);
input timer_finishflag;
input clk;
input [15:0]key_press;
output reg timer_cont;
output reg [3:0] hour_gg, hour_dd,minute_gg,minute_dd;
output reg [1:0] switch;
output  reg [3:0] num_hd, num_hg, num_md, num_mg;
output reg[3:0]store_hd, store_hg, store_md, store_mg;
output reg[3:0]timer_hd, timer_hg, timer_md, timer_mg;
//output reg wrong_led;
output reg [2:0] select_enable;

reg waity;
reg reset;
reg[3:0] num;
reg[1:0] count;
reg [3:0]key_value;
//reg [3:0] store_hd, store_hg, store_md, store_mg;
reg [2:0] key_flag;
reg setime;
reg time_set;
reg alarm;
reg [2:0]turn_count;
reg timer;
/*
key_press 1 2 3 4 5 6 7 8 9 10   11    12     13  14 15 16
key_value 0 1 2 3 4 5 6 7 8 9 switch  time  alarm
*/

always@(*)
begin
   case(key_press)
	   16'b0000000000000000: key_flag=3'b000;
		16'b0000000000000001: begin key_value=4'd0; key_flag=3'b001; end
		16'b0000000000000010: begin key_value=4'd1; key_flag=3'b001; end
		16'b0000000000000100: begin key_value=4'd2; key_flag=3'b001; end
		16'b0000000000001000: begin key_value=4'd3; key_flag=3'b001; end
		16'b0000000000010000: begin key_value=4'd4; key_flag=3'b001; end
		16'b0000000000100000: begin key_value=4'd5; key_flag=3'b001; end
		16'b0000000001000000: begin key_value=4'd6; key_flag=3'b001; end
		16'b0000000010000000: begin key_value=4'd7; key_flag=3'b001; end
		16'b0000000100000000: begin key_value=4'd8; key_flag=3'b001; end
		16'b0000001000000000: begin key_value=4'd9; key_flag=3'b001; end
		16'b0000010000000000: begin timer<=1; key_flag=3'b100;   end
		16'b0000100000000000: begin time_set=1; key_flag=3'b010; end
		16'b0001000000000000: begin alarm=1; key_flag=3'b011; end
		default key_flag=3'b000;
	endcase
end

always@(posedge clk) 
begin
     if(key_flag==3'b001)
	  begin
	    switch<=2'b11;    //暂时显示
		case(count)
			0: begin store_hg<=key_value; end
			1: store_hd<=key_value;
			2: store_mg<=key_value;
			3: begin store_md<=key_value; setime<=1;waity<=1;turn_count<=3'd5; end   //turn_count<=3'd5; 
		endcase
		    //换时间标志位
		//count<=1;
		count<=count+1;
		end
	//end
	else if(key_flag==3'b010&&setime==1) begin
	    waity<=0;
	    select_enable<=1;
	    num_hd<=store_hd;
		 num_hg<=store_hg;
		 num_md<=store_md;
		 num_mg<=store_mg;
		 setime<=0;
		 switch<=2'b11;
		 end
	else if(key_flag==3'b011&&setime==1) begin
	     waity<=0;
	     hour_gg<=store_hg;
		  hour_dd<=store_hd;
		  minute_gg<=store_mg;
		  minute_dd<=store_md;
		  setime<=0;
		  end
	else if(key_flag==3'b011&&setime==0) begin
	     switch<=2'b01;
		  end
	else if(key_flag==3'b100&&setime==1) begin
	     //timer<=0;
		  waity<=0;
		  switch<=2'b11;
		  timer_hd<=store_hd;
		  timer_hg<=store_hg;
		  timer_md<=store_md;
		  timer_mg<=store_mg;
		  setime<=0;
		  timer_cont<=1;
		 // timer_finishflag<=0;
		  end
	/*	  
	else if(key_flag==3'b000&&timer_cont==0) begin 
    if(turn_count!=3'd0) begin turn_count<=turn_count-1'd1; switch<=2'b11; end
	 else begin switch<=2'b00; select_enable<=0; end
	end
	*/
	else if(waity==1&&key_flag==3'b000&&timer_cont==0) begin
	   if(turn_count!=3'd0) begin turn_count<=turn_count-1'd1; switch<=2'b11; end else begin waity<=0; select_enable<=0; switch<=2'b00;end end
	//else begin waity<=0; setime<=0;switch<=2'b00; select_enable<=0; end
	//end
	else if(timer_finishflag==1)begin timer_cont<=0; switch<=2'b00; end
   else if(timer_cont==1) switch<=2'b10;	
	else begin waity<=0; setime<=0;switch<=2'b00; select_enable<=0; end
	/*
	else if(waity==1&&key_flag==3'b000&&timer_cont==0) begin
	   if(turn_count!=3'd0) begin turn_count<=turn_count-1'd1; switch<=2'b11; end
	else begin waity<=0; setime<=0;switch<=2'b00; select_enable<=0; end
	end
	*/
end
	  


endmodule





