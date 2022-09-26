module key_ctl
(
input   rst,clk,
input   pls1k,		// 1kHz Pulse
input   key0,		// Start & Stop
input   key1,		// Clear
input	[3:0] enc,
output	reg buzz,
output 	reg cnt_en,cnt_clr
);

reg	[7:0] bzcnt;

reg p0,p1;

reg k0p0,k0p1;
reg	[4:0] k0cnt;

reg k1p0,k1p1;
reg	[4:0] k1cnt;

// 1KHz Pulse Edge Detection
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        p0 <= 0;
        p1 <= 0;
   	end
else 
	begin
        p0 <= pls1k;
        p1 <= p0;
  	end                  
    
// Key0 De-bounce check
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        k0p0 <= 0;
        k0p1 <= 0;
        k0cnt <= 20;
        cnt_en <= 0;
   	end
else if (p0 & ~p1)			// Rising Edge of 1kHz Pulse
	begin
        k0p0 <= ~key0;
        k0p1 <= k0p0;
        if (k0p0 != k0p1)	// Pushed Edge of Key0  
    		k0cnt <= 0;
    	else if (k0cnt < 20)
    		k0cnt <= k0cnt + 1; 
    	if ((k0cnt == 19) & (k0p0 == 1))
    		cnt_en <= ~cnt_en;   
  	end                  
    
// Key1 De-bounce check
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        k1p0 <= 0;
        k1p1 <= 0;
        k1cnt <= 20;
        cnt_clr <= 0;
   	end
else if (p0 & ~p1)			// Rising Edge of 1kHz Pulse
	begin
        k1p0 <= ~key1;
        k1p1 <= k1p0;
        if (k1p0 != k1p1)	// Both Edge of Key1  
    		k1cnt <= 0;
    	else if (k1cnt < 20)
    		k1cnt <= k1cnt + 1; 
    	if (k1cnt == 19) 
    		cnt_clr <= k1p0;   
  	end                  
    			
// BuzzerControl
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        buzz <= 0;
        bzcnt <= 255;
   	end
else if (p0 & ~p1)			// Rising Edge of 1kHz Pulse
	begin
        if (((k1cnt == 19) & (k1p0 == 1)) | ((k0cnt == 19) & (k0p0 == 1)))
    		bzcnt <= 0;   
    	else if (bzcnt < 255)
    		bzcnt <= bzcnt + 1;
    		
    	if (bzcnt < {enc,4'b0})
    		buzz <= 1;
    	else
    		buzz <= 0;
  	end                  
    			
endmodule

