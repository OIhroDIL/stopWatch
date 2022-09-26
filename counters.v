module counters
(
input   rst,clk,
input   cnt_en,cnt_clr,
output  reg [6:0] 	hcnt,tcnt,		// 7bit Counter : 00 ~ 99
output  reg [5:0] 	mcnt,scnt		// 6bit Counter : 00 ~ 59
);

reg  [15:0] cnt;

reg  hp0,hp1;	// 1 Hour Pulse 
reg  mp0,mp1;	// 1 Minute Pulse
reg  sp0,sp1;	// 1 Sec. Pulse
reg  tp0,tp1;	// 0.01 Sec. Pulse

// cnt & tp0, tp1 generation
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        tp0 <= 0;
        tp1 <= 0;
        cnt <= 0;
   	end
else if (cnt_en == 1)  		
    begin
	   	tp1 <= tp0;
	   	if (cnt < 49999)		// for Board Implementation
	   	//	if (cnt < 4)		// for Simulation Only
   	 		cnt <= cnt + 1;
    	else
    		begin
    			cnt <= 0;
    			tp0 <= ~tp0;	
    		end
  	end              
else if (cnt_en == 0)
    if (cnt_clr == 1)
    	begin
        	tp0 <= 0;
        	tp1 <= 0;
        	cnt <= 0;
   		end
   		   
// Sec. Pulse Generation and Under Sec. Counting
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
        sp0 <= 0;
        sp1 <= 0;
        tcnt <= 0;  
	end
else if (cnt_en == 1)
   	begin
   		sp1 <= sp0;
	   	if (tcnt < 49)
	   		sp0 <= 0;
	   	else
	   		sp0 <= 1;	
   		
   		if (tp1 & ~tp0)	// Falling Edge of TP0  		
    		if (tcnt < 99)
	   			tcnt <= tcnt + 1;
	   		else
	   			tcnt <= 0;   
	end                
else if (cnt_en == 0)
    if (cnt_clr == 1)
    	begin
        	sp0 <= 0;
        	sp1 <= 0;
        	tcnt <= 0;
   		end
   			
// Min. Pulse Generation and Sec. Counting
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
        mp0 <= 0;
        mp1 <= 0;
        scnt <= 0;  
	end
else if (cnt_en == 1)	
    begin
    	mp1 <= mp0;       				
    	if (scnt < 29)
    		mp0 <= 0;
    	else
    		mp0 <= 1; 
    		
    	if (sp1 & ~sp0)	// Falling Edge of SP0   
   			if (scnt < 59)
   				scnt <= scnt + 1;
   			else
   				scnt <= 0;
  	end  
else if (cnt_en == 0)                    
    if (cnt_clr == 1)
    	begin
        	mp0 <= 0;
        	mp1 <= 0;
        	scnt <= 0;
   		end                
		
// Hour Pulse Generation and Min. Counting
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
        hp0 <= 0;
        hp1 <= 0;
        mcnt <= 0;  
	end
else if (cnt_en == 1)	
   	begin
   		hp1 <= hp0;    		
   		if (mcnt < 29)
   			hp0 <= 0;
   		else
   			hp0 <= 1; 
   		
   		if (mp1 & ~mp0)	// Falling Edge of MP0   
   			if (mcnt < 59)
   				mcnt <= mcnt + 1;
   			else
   				mcnt <= 0;
	end    
else if (cnt_en == 0)         
    if (cnt_clr == 1)
    	begin
        	hp0 <= 0;
        	hp1 <= 0;
        	mcnt <= 0;
   		end              
			
// Hour Counting
always@(negedge rst, posedge clk)
if (rst == 0)
	hcnt <= 0;  
else if (cnt_en == 1)
	begin
  		if (hp1 & ~hp0)	// Falling Edge of HP0   
  		   if (hcnt < 99)
    			hcnt <= hcnt + 1;
    		else
    			hcnt <= 0;
    end
else if (cnt_en == 0)   
	if (cnt_clr == 1)
		hcnt <= 0;
			
endmodule

