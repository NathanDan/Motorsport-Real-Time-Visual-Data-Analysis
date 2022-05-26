ods pdf file="/home/natdanjones0/Ferrari Team-Mate Driver Analysis Throughout the Race.pdf";
options nocenter;
options orientation=portrait;

title1 height=20pt "Emilia Romagna Grand Prix, 2021";
title2 height=14pt " ";
title3 height=18pt "Ferrari Team-Mate Driver Analysis Throughout the Race";
title4 height=12pt "Nathan Jones 2022";
title5 height=14pt " ";

*TEAMMATE 1 DATA;
proc import file="/home/natdanjones0/LeClerc/LeClerc.xlsx"
    out=work.LeClerc
    dbms=xlsx;
run;

proc import file="/home/natdanjones0/Sainz/Sainz.xlsx"
    out=work.Sainz
    dbms=xlsx;
run;

  ods layout gridded columns=2 width=3.8in column_gutter=.1in style={background=white};
 
 *COLUMN ONE CODE GOES BELOW;
 ods region style={background=white};
 ods graphics / reset width=6.4in height=4.8in imagemap;

 proc sort data=WORK.LECLERC out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
 	title height=14pt "LeClerc's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
 proc sort data=WORK.LECLERC out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "LeClerc's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;
 
ods graphics / reset;
title;

title3 height=12pt "LeClerc's Top 5 Fastest Laps";

PROC SORT DATA = work.LECLERC;
	BY time;
RUN;

proc print data=work.LECLERC(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT LECLERC.lap, LECLERC.position, LECLERC.time, LECLERC.secs, LECLERC.avg_speed, LECLERC.tyre 
FROM WORK.LECLERC LECLERC 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "LeClerc's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.8in imagemap;
 proc sort data=WORK.LECLERC out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "LeClerc Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CXf31212);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.LECLERC out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "LeClerc's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
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
		entrytitle "LeClerc's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.LECLERC;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "LeClerc's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.LECLERC;
run;

ods graphics / reset;
title;



title height=12pt "LeClerc's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT LECLERC.lap, LECLERC.position, LECLERC.pos_change, LECLERC.tyre, LECLERC.pit_stop 
FROM WORK.LECLERC LECLERC 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "LeClerc's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT LECLERC.lap, LECLERC.position, LECLERC.pos_change, LECLERC.tyre, LECLERC.pit_stop 
FROM WORK.LECLERC LECLERC 
WHERE 
   ( LECLERC.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "LeClerc's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT LECLERC.lap, LECLERC.position, LECLERC.pos_change, LECLERC.tyre, LECLERC.pit_stop 
FROM WORK.LECLERC LECLERC 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "LeClerc's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime 
AS 
SELECT RANGE(LECLERC.pit_stop) 
AS pit_stop, SUM(LECLERC.pit_stop_time) 
AS pit_stop_time 
FROM WORK.LECLERC LECLERC; 
QUIT;
proc print data=WORK.PitStopTime();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "LeClerc's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT LECLERC.lap, LECLERC.position, LECLERC.tyre, LECLERC.pit_stop, LECLERC.pit_stop_time 
FROM WORK.LECLERC LECLERC 
WHERE LECLERC.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "LeClerc's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.8in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.LECLERC;
run;

proc sort data=WORK.LECLERC out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "LeClerc's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

*COLUMN TWO GOES BELOW;
ods region style={background=white};	
ods graphics / reset width=6.4in height=4.67in imagemap;

proc sort data=WORK.SAINZ out=_SeriesPlotTaskData;
	by lap;
 run;
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Sainz's Lap Times During The Race";
	series x=lap y=time / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;


title;
proc sort data=WORK.SAINZ out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Sainz's Average Speed Per Lap (MPH)";
	series x=lap y=avg_speed / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid;
 run;

ods graphics / reset;
title;

title3 height=12pt "Sainz's Top 5 Fastest Laps";

PROC SORT DATA = work.SAINZ;
	BY time;
RUN;

proc print data=work.SAINZ(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

PROC SQL; 
CREATE TABLE WORK.SlowLaps 
AS 
SELECT SAINZ.lap, SAINZ.position, SAINZ.time, SAINZ.secs, SAINZ.avg_speed, SAINZ.tyre 
FROM WORK.SAINZ SAINZ 
ORDER BY 3 DESC; 
QUIT;

title3 height=12pt "Sainz's Top 5 Slowest Laps";

proc print data=WORK.SlowLaps(obs=5);
    VAR lap position time secs avg_speed tyre;  /* optional: the VAR statement specifies variables */
run;

ods graphics / reset width=6.4in height=4.67in imagemap;
 proc sort data=WORK.SAINZ out=_SeriesPlotTaskData;
	by lap;
 run;
 
 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Sainz Position Chnages";
	series x=lap y=position / markers markerattrs=(color=CX000000) 
		lineattrs=(pattern=solid color=CXf31212);  
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(1 to 20 by 1);
 run;

proc sort data=WORK.SAINZ out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Sainz's Postions Gained/Lost";
	series x=lap y=pos_change / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
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
		entrytitle "Sainz's Percentage of Positions in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=position / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.SAINZ;
run;

ods graphics / reset;
title;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Sainz's Percentage of Tyre Types Used in the Race" / 
			textattrs=(size=14);
		layout region;
		piechart category=tyre / stat=pct datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.SAINZ;
run;

ods graphics / reset;
title;



title height=12pt "Sainz's Starting Position";
PROC SQL; 
CREATE VIEW WORK.StartingPos 
AS 
SELECT SAINZ.lap, SAINZ.position, SAINZ.pos_change, SAINZ.tyre, SAINZ.pit_stop 
FROM WORK.SAINZ SAINZ 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.StartingPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;
   
title height=12pt "Sainz's Position After 1 Lap";
PROC SQL; 
CREATE VIEW WORK.FirstLap 
AS 
SELECT SAINZ.lap, SAINZ.position, SAINZ.pos_change, SAINZ.tyre, SAINZ.pit_stop 
FROM WORK.SAINZ SAINZ 
WHERE 
   ( SAINZ.lap = 2 ) 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.FirstLap(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
   
   run;

title height=12pt "Sainz's Final Finishing Position";
PROC SQL; 
CREATE VIEW WORK.FinishPos 
AS 
SELECT SAINZ.lap, SAINZ.position, SAINZ.pos_change, SAINZ.tyre, SAINZ.pit_stop 
FROM WORK.SAINZ SAINZ 
ORDER BY 1 DSC; 
QUIT;
proc print data=WORK.FinishPos(obs=1);
    
    VAR lap position pos_change tyre pit_stop;  /* optional: the VAR statement specifies variables */
    
run;
ods graphics / reset;
title;

ods graphics / reset;
title;

title height=12pt "Sainz's Total Time Lost in the Pits";
PROC SQL; 
CREATE TABLE WORK.PitStopTime2 
AS 
SELECT RANGE(SAINZ.pit_stop) 
AS pit_stop, SUM(SAINZ.pit_stop_time) 
AS pit_stop_time 
FROM WORK.SAINZ SAINZ; 
QUIT;
proc print data=WORK.PitStopTime2();
    
    VAR pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;

title height=12pt "Sainz's Pit Stops Information";
PROC SQL; 
CREATE TABLE WORK.PitStops 
AS 
SELECT SAINZ.lap, SAINZ.position, SAINZ.tyre, SAINZ.pit_stop, SAINZ.pit_stop_time 
FROM WORK.SAINZ SAINZ 
WHERE SAINZ.pit_stop_time IS NOT MISSING 
ORDER BY 1 ASC; 
QUIT;

proc print data=WORK.PitStops();
    
    VAR lap position tyre pit_stop pit_stop_time;  /* optional: the VAR statement specifies variables */
    
run;


proc template;
	define statgraph SASStudio.Pie;
		begingraph;
		entrytitle "Sainz's Pit Stop Times in Seconds" / textattrs=(size=14);
		layout region;
		piechart category=pit_stop_time response=pit_stop / datalabellocation=callout 
			dataskin=crisp;
		endlayout;
		endgraph;
	end;
run;

ods graphics / reset width=6.4in height=4.67in imagemap;

proc sgrender template=SASStudio.Pie data=WORK.SAINZ;
run;

proc sort data=WORK.SAINZ out=_SeriesPlotTaskData;
	by lap;
 run;

 proc sgplot data=_SeriesPlotTaskData;
	title height=14pt "Sainz's Lap Time Differences (Secs)";
	series x=lap y='lap_time _diff'n / markers markerattrs=(color=CX000000)
	lineattrs=(pattern=solid color=CXf31212);;
	xaxis grid values=(1 to 63 by 1);
	yaxis grid values=(-30 to 30 by 1);
 run;
ods graphics / reset;
title;

ods pdf close;