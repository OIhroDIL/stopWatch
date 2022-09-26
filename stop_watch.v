module stop_watch
(
input   rst,clk,
input  	key0,		// Start & Stop
input   key1,		// Clear
input	[3:0] enc,
output	buzz,
output 	[7:0] seg_d,seg_com
);

wire	[3:0] encs;

reg	[12:0] plcnt;
reg pls1k;

// 1KHz Pulse Generation
always@(negedge rst, posedge clk)
if (rst == 0)
    begin
        pls1k <= 0;
        plcnt <= 0;
   	end
else if (plcnt < 4999)
	plcnt <= plcnt + 1;
else
	begin
        pls1k <= ~pls1k;
        plcnt <= 0;
  	end                  

assign encs = 4'h2;

//------ KEY_CTL.V ----------
wire cnt_en, cnt_clr;
key_ctl ukey_ctl
	(
// Input	
	.rst		(rst		),
	.clk		(clk		),
	.pls1k		(pls1k		),
	.key0		(key0		),
	.key1		(key1		),
	.enc		(encs		),
// Output
	.buzz		(buzz		),
	.cnt_en		(cnt_en		),
	.cnt_clr	(cnt_clr	)
	);
						
//------ COUNTERS.V ----------
wire [6:0] hcnt, tcnt;	
wire [5:0] mcnt, scnt;
counters ucounters
	(
// Input	
	.rst		(rst		),
	.clk		(clk		),
	.cnt_en		(cnt_en		),
	.cnt_clr	(cnt_clr	),
// Output
	.hcnt		(hcnt		),
	.tcnt		(tcnt		),
	.mcnt		(mcnt		),
	.scnt		(scnt		)
	);
									
//------ HEX2BCD.V ----------
wire [31:0] bcd8d;
hex2bcd uhex2bcd
	(
// Input	
	.rst		(rst		),
	.clk		(clk		),
	.pls1k		(pls1k		),
	.hv			(hcnt		),
	.tv			(tcnt		),
	.mv			(mcnt		),
	.sv			(scnt		),
// Output
	.bcd8d		(bcd8d		)
	);
							
//------ SEG_CTL.V ----------
seg_ctl useg_ctl
	(
// Input	
	.rst		(rst		),
	.clk		(clk		),
	.enc		(encs		),
	.bcd8d		(bcd8d		),
// Output
	.seg_d		(seg_d		),
	.seg_com	(seg_com	)
	);
				    		    			
endmodule

