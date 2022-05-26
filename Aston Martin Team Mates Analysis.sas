ods pdf file="/home/natdanjones0/Aston Martin Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=20pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Aston Martin Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/Vettel/Vettel.xlsx"
    out=work.Vettel
    dbms=xlsx;
run;

*TEAMMATE 2 DATA;
proc import file="/home/natdanjones0/Stroll/Stroll.xlsx"
    out=work.Stroll
    dbms=xlsx;
run;

ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;

 proc sort data=WORK.VETTEL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Vettel Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000) 
		lineattrs=(color=CX12612b);
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
 proc sort data=WORK.VETTEL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Vettel's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX12612b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
title;

title3 height=12pt "Vettel's Top 5 Fastest Laps";

PROC SORT DATA = work.VETTEL;
	BY time;
RUN;

proc print data=work.VETTEL(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT VETTEL.lap, VETTEL.position, VETTEL.time, VETTEL.secs, VETTEL.avg_speed, VETTEL.tyre 
FROM WORK.VETTEL VETTEL 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Vettel's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.VETTEL out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Vettel Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX12612b);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.VETTEL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Vettel's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX12612b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-20 to 20 by 1);
 run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Vettel's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.VETTEL;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Vettel's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.VETTEL;
run;

ods graphics / reset;
title;



title height=12pt "Vettel's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT VETTEL.lap, VETTEL.position, VETTEL.pos_change, VETTEL.tyre, VETTEL.pit_stop 
FROM WORK.VETTEL VETTEL 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Vettel's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT VETTEL.lap, VETTEL.position, VETTEL.pos_change, VETTEL.tyre, VETTEL.pit_stop 
FROM WORK.VETTEL VETTEL 
WHERE 
   ( VETTEL.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Vettel's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT VETTEL.lap, VETTEL.position, VETTEL.pos_change, VETTEL.tyre, VETTEL.pit_stop 
FROM WORK.VETTEL VETTEL 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Vettel's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(VETTEL.pit_stop) 
AS pit_stop, SUM(VETTEL.pit_stop_time) 
AS pit_stop_time 
FROM WORK.VETTEL VETTEL; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Vettel's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT VETTEL.lap, VETTEL.position, VETTEL.tyre, VETTEL.pit_stop, VETTEL.pit_stop_time 
FROM WORK.VETTEL VETTEL 
WHERE VETTEL.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Vettel's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.VETTEL;
run;

proc sort data=WORK.VETTEL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Vettel's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX12612b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;

 proc sort data=WORK.STROLL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Stroll Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000) 
		lineattrs=(color=CX12612b);
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

 proc sort data=WORK.STROLL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Stroll's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX12612b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
ods graphics / reset;
title;

title3 height=12pt "Stroll's Top 5 Fastest Laps";

PROC SORT DATA = work.STROLL;
	BY time;
RUN;

proc print data=work.STROLL(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT STROLL.lap, STROLL.position, STROLL.time, STROLL.secs, STROLL.avg_speed, STROLL.tyre 
FROM WORK.STROLL STROLL 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Stroll's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.STROLL out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Stroll Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CX12612b);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.STROLL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Stroll's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX12612b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-20 to 20 by 1);
 run;

ods graphics / reset;
title;

proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc datasets library=WORK noprint;
	delete _SeriesPlotTaskData;
	run;
	
proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Stroll's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.STROLL;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Stroll's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.STROLL;
run;

ods graphics / reset;
title;



title height=12pt "Stroll's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT STROLL.lap, STROLL.position, STROLL.pos_change, STROLL.tyre, STROLL.pit_stop 
FROM WORK.STROLL STROLL 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Stroll's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT STROLL.lap, STROLL.position, STROLL.pos_change, STROLL.tyre, STROLL.pit_stop 
FROM WORK.STROLL STROLL 
WHERE 
   ( STROLL.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Stroll's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT STROLL.lap, STROLL.position, STROLL.pos_change, STROLL.tyre, STROLL.pit_stop 
FROM WORK.STROLL STROLL 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Stroll's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(STROLL.pit_stop) 
AS pit_stop, SUM(STROLL.pit_stop_time) 
AS pit_stop_time 
FROM WORK.STROLL STROLL; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Stroll's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT STROLL.lap, STROLL.position, STROLL.tyre, STROLL.pit_stop, STROLL.pit_stop_time 
FROM WORK.STROLL STROLL 
WHERE STROLL.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Stroll's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.STROLL;
run;

proc sort data=WORK.STROLL out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Stroll's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CX12612b);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

ods pdf close;