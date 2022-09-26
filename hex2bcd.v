module hex2bcd
(
input   rst,clk,
input   pls1k,			// 1ms Pulse
input 	[6:0] 	hv,tv,
input  	[5:0] 	mv,sv,
output 	[31:0] 	bcd8d	// 8digit BCD Out for Time Counting Display.
);

reg	[6:0] thv,ttv;
reg	[5:0] tmv,tsv;
reg	[3:0] cnt;

reg	[3:0] hbcd_h, hbcd_l;
reg	[3:0] mbcd_h, mbcd_l;
reg	[3:0] sbcd_h, sbcd_l;
reg	[3:0] tbcd_h, tbcd_l;

reg  [7:0] hbcd,mbcd,sbcd,tbcd;

reg  tp0,tp1;	// 0.01 Sec. Pulse

// cnt & tp0, tp1 generation
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        tp0 <= 0;
        tp1 <= 0;
        cnt <= 7;
   	end
else 
	begin
        tp0 <= pls1k;
        tp1 <= tp0;
        if (tp0 & ~tp1)	// Rising Edge of TP0  
    		cnt <= 0;
    	else if (cnt < 7)
    		cnt <= cnt + 1;    
  	end                  
    
// Hex. to BCD Conversion for Hour
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
		thv <= 0;
		hbcd_h <= 0;  hbcd_l <= 0;
	end
else if (cnt == 0)		
	thv <= hv;
else if (cnt == 1)
	if      (thv >= 90)	begin	hbcd_h <= 9;	thv <= thv - 90;	end
	else if (thv >= 80)	begin	hbcd_h <= 8;	thv <= thv - 80;	end
	else if (thv >= 70)	begin	hbcd_h <= 7;	thv <= thv - 70;	end
	else if (thv >= 60)	begin	hbcd_h <= 6;	thv <= thv - 60;	end
	else if (thv >= 50)	begin	hbcd_h <= 5;	thv <= thv - 50;	end
	else if (thv >= 40)	begin	hbcd_h <= 4;	thv <= thv - 40;	end
	else if (thv >= 30)	begin	hbcd_h <= 3;	thv <= thv - 30;	end
	else if (thv >= 20)	begin	hbcd_h <= 2;	thv <= thv - 20;	end
	else if (thv >= 10)	begin	hbcd_h <= 1;	thv <= thv - 10;	end
	else 				begin	hbcd_h <= 0;	thv <= thv - 00;	end
else if (cnt == 2)
	if      (thv < 10)			hbcd_l <= thv[3:0];	
	
// Hex. to BCD Conversion for Min.
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
		tmv <= 0;
		mbcd_h <= 0;   mbcd_l <= 0;   
	end
else if (cnt == 0)		
	tmv <= mv;
else if (cnt == 1)
	if      (tmv >= 50)	begin	mbcd_h <= 5;	tmv <= tmv - 50;	end
	else if (tmv >= 40)	begin	mbcd_h <= 4;	tmv <= tmv - 40;	end
	else if (tmv >= 30)	begin	mbcd_h <= 3;	tmv <= tmv - 30;	end
	else if (tmv >= 20)	begin	mbcd_h <= 2;	tmv <= tmv - 20;	end
	else if (tmv >= 10)	begin	mbcd_h <= 1;	tmv <= tmv - 10;	end
	else 				begin	mbcd_h <= 0;	tmv <= tmv - 00;	end
else if (cnt == 2)
	if      (tmv < 10)			mbcd_l <= tmv[3:0];	
	

// Hex. to BCD Conversion for Sec.
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
		tsv <= 0;
		sbcd_h <= 0;  sbcd_l <= 0;  
	end
else if (cnt == 0)		
	tsv <= sv;
else if (cnt == 1)
	if      (tsv >= 50)	begin	sbcd_h <= 5;	tsv <= tsv - 50;	end
	else if (tsv >= 40)	begin	sbcd_h <= 4;	tsv <= tsv - 40;	end
	else if (tsv >= 30)	begin	sbcd_h <= 3;	tsv <= tsv - 30;	end
	else if (tsv >= 20)	begin	sbcd_h <= 2;	tsv <= tsv - 20;	end
	else if (tsv >= 10)	begin	sbcd_h <= 1;	tsv <= tsv - 10;	end
	else 				begin	sbcd_h <= 0;	tsv <= tsv - 00;	end
else if (cnt == 2)
	if      (tsv < 10)			sbcd_l <= tsv[3:0];	
	
// Hex. to BCD Conversion for Under Sec.
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
		ttv <= 0;
		tbcd_h <= 0;    tbcd_l <= 0;    
	end
else if (cnt == 0)		
    ttv <= tv;
else if (cnt == 1)
	if      (ttv >= 90)	begin	tbcd_h <= 9;	ttv <= ttv - 90;	end
	else if (ttv >= 80)	begin	tbcd_h <= 8;	ttv <= ttv - 80;	end
	else if (ttv >= 70)	begin	tbcd_h <= 7;	ttv <= ttv - 70;	end
	else if (ttv >= 60)	begin	tbcd_h <= 6;	ttv <= ttv - 60;	end
	else if (ttv >= 50)	begin	tbcd_h <= 5;	ttv <= ttv - 50;	end
	else if (ttv >= 40)	begin	tbcd_h <= 4;	ttv <= ttv - 40;	end
	else if (ttv >= 30)	begin	tbcd_h <= 3;	ttv <= ttv - 30;	end
	else if (ttv >= 20)	begin	tbcd_h <= 2;	ttv <= ttv - 20;	end
	else if (ttv >= 10)	begin	tbcd_h <= 1;	ttv <= ttv - 10;	end
	else 				begin	tbcd_h <= 0;	ttv <= ttv - 00;	end
else if (cnt == 2)
	if      (ttv < 10)			tbcd_l <= ttv[3:0];	
		
// Integration of Hex. to BCD Converting Result
always@(negedge rst, posedge clk)
if (rst == 0)
	begin
		hbcd <= 0;  mbcd <= 0;  sbcd <= 0;  tbcd <= 0; 
	end 
else if (cnt == 3)		
    begin
    	hbcd <= {hbcd_h,hbcd_l};
    	mbcd <= {mbcd_h,mbcd_l};
    	sbcd <= {sbcd_h,sbcd_l};
    	tbcd <= {tbcd_h,tbcd_l};
    end

assign    bcd8d = {hbcd,mbcd,sbcd,tbcd};
    			
endmodule

